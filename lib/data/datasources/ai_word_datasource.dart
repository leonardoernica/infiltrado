import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import '../../domain/entities/word_pair.dart';
import '../models/word_pair_model.dart';
import '../../core/api/open_router_client.dart';
import '../services/game_log_service.dart';
import '../models/game_log_entry.dart';

class AiWordDatasource {
  final OpenRouterClient _client;

  AiWordDatasource(this._client);

  // Portuguese descriptions (for user display)
  static const Map<String, String> _categoryDescriptions = {
    'Cinema':
        'Abrange todo o ecossistema audiovisual e cinematográfico, incluindo filmes, séries, gêneros narrativos, estilos visuais, técnicas de filmagem, profissões da indústria (direção, atuação, roteiro, edição, produção), equipamentos técnicos, linguagem cinematográfica, elementos de cena, bastidores, festivais, premiações, personagens, narrativas, efeitos especiais e tudo que compõe a experiência do cinema e do audiovisual.',
    'Comida':
        'Abrange o universo completo da alimentação e gastronomia, incluindo pratos, ingredientes, bebidas, sobremesas, temperos, métodos de preparo, técnicas culinárias, utensílios, eletrodomésticos, culturas gastronômicas, hábitos alimentares, refeições do dia, comidas típicas, processos industriais, conceitos nutricionais e tudo relacionado ao ato de cozinhar, comer e servir.',
    'Animais':
        'Abrange o reino animal em sua totalidade, incluindo mamíferos, aves, répteis, anfíbios, insetos, peixes e animais marinhos, além de habitats, comportamentos, características físicas, sons, alimentação, reprodução, domesticação, fauna selvagem, animais extintos, classificação biológica e interações com o meio ambiente e com os seres humanos.',
    'Lugares':
        'Abrange espaços físicos e geográficos de qualquer escala, incluindo países, cidades, bairros, pontos turísticos, monumentos, construções, estabelecimentos, ambientes naturais, biomas, paisagens, locais públicos ou privados, reais ou conceituais, além de espaços urbanos, rurais, culturais, históricos e funcionais do cotidiano.',
    'História':
        'Abrange TODA a história humana em sua diversidade: eventos históricos de qualquer época (antiga, medieval, moderna, contemporânea), figuras históricas (líderes, inventores, artistas, cientistas, revolucionários), civilizações e impérios, guerras e conflitos, revoluções e movimentos sociais, descobertas e invenções, períodos históricos, documentos e tratados, artefatos arqueológicos, culturas e tradições, eventos modernos (séculos XX e XXI), catástrofes históricas, mudanças tecnológicas, movimentos culturais, e qualquer elemento que faça parte da construção da humanidade ao longo do tempo. EXPLORE DIFERENTES ÉPOCAS E TIPOS DE CONCEITOS - não se limite apenas a revoluções e impérios clássicos.',
    'Esportes':
        'Abrange o universo esportivo em sentido amplo, incluindo modalidades individuais e coletivas, práticas recreativas ou competitivas, regras, fundamentos técnicos, equipamentos, espaços de prática, atletas, posições, competições, torneios, eventos esportivos, termos específicos, treinamento físico, estratégias e elementos culturais ligados ao esporte.'
  };

  // English translations for LLM prompt
  static const Map<String, String> _categoryNamesEnglish = {
    'Cinema': 'Cinema',
    'Comida': 'Food',
    'Animais': 'Animals',
    'Lugares': 'Places',
    'História': 'History',
    'Esportes': 'Sports',
  };

  static const Map<String, String> _categoryDescriptionsEnglish = {
    'Cinema':
        'Encompasses the entire audiovisual and cinematic ecosystem.',
    'Comida':
        'Encompasses the complete universe of food and gastronomy.',
    'Animais':
        'Encompasses the entire animal kingdom.',
    'Lugares':
        'Encompasses physical and geographical spaces of any scale.',
    'História':
        'Encompasses ALL of human history in its diversity.',
    'Esportes':
        'Encompasses the sports universe in a broad sense.'
  };

  /// Main entry point for the Multi-Agent Orchestration
  Future<WordPairModel> fetchWordPair(
      String category, List<WordPair> history, {String? customDescription}) async {
    final categoryDescription = customDescription ?? _categoryDescriptions[category] ?? category;

    // 1. Prepare forbidden words list once
    final forbiddenInfo = _buildForbiddenInfo(history);

    final sbLog = StringBuffer(); // Accumulate logs for the final entry
    final random = Random();
    int attempts = 0;

    // Outer loop: Attempts to get a full valid flow
    while (attempts < 2) {
      attempts++;
      sbLog.writeln("=== ATTEMPT $attempts ===");

      try {
        // --- AGENT 1: THE DIRECTOR ---
        // Responsibility: Select a Civilian word with forced randomness.
        final targetIndex = random.nextInt(10) + 1; // 1 to 10
        sbLog.writeln("[Director] Target Index: $targetIndex");
        
        final civilianWord = await _runDirectorAgent(
          category, 
          targetIndex, 
          forbiddenInfo,
          customDescription, 
          sbLog
        );
        
        if (civilianWord == null) {
          sbLog.writeln("[Director] Failed to generate civilian word.");
          continue; // Retry outer loop
        }

        // --- AGENT 2 & 3: DESIGNER AND GUARDIAN LOOP ---
        // Loop for refining the Infiltrator word
        String? validInfiltratorWord;
        List<String> feedbackHistory = [];

        int refinementAttempts = 0;
        while (refinementAttempts < 3 && validInfiltratorWord == null) {
          refinementAttempts++;
          sbLog.writeln("-- Refinement Round $refinementAttempts --");

          // Agent 2: Designer
          final candidateInfiltrator = await _runDesignerAgent(
             category, 
             civilianWord, 
             forbiddenInfo, 
             feedbackHistory, 
             sbLog
          );

          if (candidateInfiltrator == null) {
             sbLog.writeln("[Designer] Failed to generate infiltrator word.");
             break; // Break refinement, retry outer loop (new civilian)
          }

          // Agent 3: Guardian
          final (approved, feedback) = await _runGuardianAgent(
            category,
            civilianWord, 
            candidateInfiltrator, 
            forbiddenInfo, 
            sbLog
          );

          if (approved) {
            validInfiltratorWord = candidateInfiltrator;
            sbLog.writeln("[Guardian] APPROVED: $civilianWord / $validInfiltratorWord");
          } else {
            sbLog.writeln("[Guardian] REJECTED: $feedback");
            feedbackHistory.add("Attempt: '$candidateInfiltrator'. Reject reason: $feedback");
          }
        }

        if (validInfiltratorWord != null) {
          // SUCCESS! Save log and return.
          await _saveLog(
            category, 
            categoryDescription, 
            civilianWord, 
            validInfiltratorWord, 
            sbLog.toString()
          );

          return WordPairModel(
            civilian: civilianWord, 
            infiltrator: validInfiltratorWord
          );
        } else {
             _log(sbLog, "[Refinement] Failed to find valid infiltrator after 3 tries.");
        }

      } catch (e) {
        _log(sbLog, "[System] Exception: $e");
        if (attempts == 2) rethrow;
      }
    }
    
    throw Exception('Failed to generate valid word pair after multiple attempts.');
  }

  // --- AGENT 1: THE DIRECTOR ---
  Future<String?> _runDirectorAgent(
      String category, 
      int targetIndex, 
      String playedWords,
      String? customDescription, 
      StringBuffer log) async {
    
    final catEng = _categoryNamesEnglish[category] ?? category;
    final descPrompt = customDescription != null ? "DESCRIPTION: $customDescription" : "";

    final prompt = '''
You are the DIRECTOR AGENT for the game "The Infiltrator".
Your GOAL is to select a CIVILIAN WORD based on a specific random index.

CATEGORY: $catEng
$descPrompt
PLAYED HISTORY (DO NOT REPEAT): $playedWords

PROCESS:
1. ANALYSIS: Look at the "PLAYED HISTORY". These words are burned and MUST NOT be used.
2. BRAINSTORMING: Generate 10 distinct, popular, well-known concepts for '$catEng'.
   - FILTER 1: Is the word in the PLAYED HISTORY? -> Discard.
   - FILTER 2: Is it the Category Name itself (e.g. "$catEng" or "$category")? -> Discard.
   - FILTER 3: Is it too niche? -> Discard.
   - FILTER 4: Is it a duplicate of another list item? -> Discard.
3. SELECTION: Select item #$targetIndex from your final filtered list.

OUTPUT FORMAT (JSON ONLY):
{
  "history_check": "I confirmed my selection is not in the history.",
  "brainstorm": ["Item 1", "Item 2", ...],
  "selection_index": $targetIndex,
  "selected_word": "The Word"
}
LANGUAGE: Brazilian Portuguese.
''';

    final response = await _callLLM(prompt, 0.8); // Slightly lower temp for stability
    if (response == null) return null;

    _log(log, "[Director Output]: $response");

    try {
      final json = _extractJson(response);
      final word = json['selected_word'] as String;
      
      // Strict Check: Cannot be the Category Name
      if (word.trim().toLowerCase() == category.trim().toLowerCase() ||
          word.trim().toLowerCase() == catEng.trim().toLowerCase()) {
         _log(log, "[Director Error] Selected word '$word' is the Category Name. Rejected.");
         return null;     
      }
      
      return word;
    } catch (e) {
      _log(log, "[Director Error] Parse failed: $e");
      return null;
    }
  }

  // --- AGENT 2: THE DESIGNER ---
  Future<String?> _runDesignerAgent(
      String category, 
      String civilianWord, 
      String playedWords, 
      List<String> feedbackHistory, 
      StringBuffer log) async {
    
    final catEng = _categoryNamesEnglish[category] ?? category;
    
    final feedbackContext = feedbackHistory.isEmpty 
        ? "No previous feedback." 
        : "PREVIOUS REJECTIONS:\n${feedbackHistory.map((f) => "- $f").join('\n')}";

    final prompt = '''
You are the DESIGNER AGENT for the game "The Infiltrator".
Your GOAL is to create the PERFECT "Infiltrator Word" for "$civilianWord".

CATEGORY: $catEng
CIVILIAN WORD: "$civilianWord"
PLAYED HISTORY: $playedWords

PROCESS:
1. ANALYZE "$civilianWord": What are its meanings and contexts?
2. STRATEGY SELECTION (Pick ONE):
   - A: POLYSEMY (Double Meaning).
     Example: "Banco" (Assento) -> Hint "Dinheiro" (Banco Finaceiro).
   - B: SPECIFIC ASSOCIATION.
     Example: "Nuvem" -> Hint "Algodão" (Visual).
   - C: POPULAR REFERENCE (Only if UNIVERSALLY knwon).
     Example: "Anel" -> Hint "Sauron".
3. DRAFTING & FILTERING (The Checklist):
   - [ ] Is it a COMMON, EVERYDAY word? (Avoid weird cultural leaps like Papagaio->Papel).
   - [ ] Is it NON-OBVIOUS? (If I say the Hint, is the Civilian Word the IMMEDIATE answer? If yes, REJECT).
   - [ ] Is it DISTINCT? (Not a synonym, not same root like Flor/Floricultura).
   - [ ] Is it NOT in the Played History?
4. SELF-TEST (Reverse Obviousness - "The Trojan Horse Test"):
   - "If I say [YOUR_HINT] (Hint) + Category '$catEng', does '$civilianWord' become the ONLY logical answer?"
   - ❌ "Troia" -> "Cavalo" (REJECT! Unique Trigger).
   - ❌ "Listras" -> "Zebra" (REJECT! Immediate Association).
   - ✅ "Algodão" -> "Nuvem" (Good! Could be Camiseta, Doce, Farmácia...).

OUTPUT FORMAT (JSON ONLY):
{
  "reasoning": "Step-by-step analysis passing the checklist...",
  "strategy": "Polysemy/Association/Reference",
  "infiltrator_word": "The Word"
}
LANGUAGE: Brazilian Portuguese.
''';

    final response = await _callLLM(prompt, 0.9); // High creativity
    if (response == null) return null;

    _log(log, "[Designer Output]: $response");

    try {
      final json = _extractJson(response);
      return json['infiltrator_word'];
    } catch (e) {
       _log(log, "[Designer Error] Parse failed: $e");
       return null;
    }
  }

  // --- AGENT 3: THE GUARDIAN ---
  Future<(bool, String)> _runGuardianAgent(
      String category,
      String civilianWord,
      String infiltratorWord,
      String playedWords,
      StringBuffer log) async {

      final catEng = _categoryNamesEnglish[category] ?? category;

      final prompt = '''
You are the GUARDIAN AGENT.
MISSION: Ensure the game is FLUID, FUN, and FAIR.
PRINCIPLE: Use COMMON, EVERYDAY words. Avoid weird logic or "forced" cultural references.

CATEGORY: $catEng
PAIR TO VALIDATE:
- CIVILIAN WORD: "$civilianWord"
- INFILTRATOR HINT: "$infiltratorWord"

VALIDATION CHECKLIST:
1. [ ] IS IT NATURAL? Does the connection make sense to a normal person? 
   - Reject "forced" associations (e.g. Papagaio -> Papel is BAD).
2. [ ] IS IT COMMON? Is the hint a word regular people use daily?
   - Reject obscure terms or weird slang.
3. [ ] REVERSE OBVIOUSNESS CHECK (The "Unique Trigger" Test):
   - If you hear "$infiltratorWord", is "$civilianWord" the IMMEDIATE/ONLY answer?
   - ❌ "Troia" -> "Cavalo" (REJECT! Too specific/obvious).
   - ❌ "Listras" -> "Zebra" (REJECT! Top-of-mind association).
   - If NO -> APPROVE (Ambiguity is maintained).
4. [ ] INDEPENDENCE: Is it NOT a synonym? Is it FREE of shared roots?
5. [ ] HISTORY CHECK: Is the hint free of played words?

DECISION:
- All checks pass? -> APPROVED: true.
- Any check fails? -> APPROVED: false. Provide strict feedback.

OUTPUT FORMAT (JSON ONLY):
{
  "analysis": "Reviewing checklist item by item...",
  "approved": true/false,
  "feedback": "If rejected, strict instruction on what to fix."
}
''';

    final response = await _callLLM(prompt, 0.4); // Low temp for strict logic
    if (response == null) return (false, "LLM failed");

    _log(log, "[Guardian Output]: $response");

    try {
      final json = _extractJson(response);
      return (json['approved'] as bool, json['feedback'] as String);
    } catch (e) {
      _log(log, "[Guardian Error] Parse failed: $e");
      return (false, "Parse error");
    }
  }

  void _log(StringBuffer sb, String message) {
    if (kDebugMode) {
      print(message);
    }
    sb.writeln(message);
  }


  // --- HELPER METHODS ---

  Future<String?> _callLLM(String prompt, double totalTemperature) async {
    // Validate API key before making request
    final apiKey = _client.dio.options.headers['Authorization'] as String?;
    if (apiKey == null || apiKey == 'Bearer ' || apiKey.isEmpty) {
      final errorMsg = '❌ CRITICAL: OpenRouter API key is not configured! Check .env file.';
      if (kDebugMode) {
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print(errorMsg);
        print('Authorization header: $apiKey');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }
      throw Exception(errorMsg);
    }
    
    int retries = 0;
    const maxRetries = 3;

    while (retries <= maxRetries) {
      try {
        if (kDebugMode) {
          print('[LLM] Attempt ${retries + 1}/${maxRetries + 1}');
          print('[LLM] Calling API with model: qwen/qwen3-235b-a22b-2507');
        }
        
        final response = await _client.dio.post(
          '/chat/completions',
          data: {
            "model": "qwen/qwen3-235b-a22b-2507",
            "messages": [
              {"role": "user", "content": prompt}
            ],
            "temperature": totalTemperature,
          },
        );
        
        if (kDebugMode) {
          print('[LLM] ✅ Response received with status: ${response.statusCode}');
        }
        
        if (response.statusCode == 200) {
          return response.data['choices'][0]['message']['content'];
        }
      } on DioException catch (e) {
         if (kDebugMode) {
           print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
           print("❌ LLM Call Error (Attempt ${retries + 1}/${maxRetries + 1})");
           print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
           print("Error Type: ${e.type}");
           print("Status Code: ${e.response?.statusCode ?? 'N/A'}");
           print("Message: ${e.message}");
           
           if (e.response != null) {
             print("Response Data: ${e.response?.data}");
             print("Response Headers: ${e.response?.headers}");
           }
           
           if (e.type == DioExceptionType.connectionTimeout) {
             print("⏱️ Connection timeout - network issue");
           } else if (e.type == DioExceptionType.receiveTimeout) {
             print("⏱️ Receive timeout - slow response");
           } else if (e.type == DioExceptionType.badCertificate) {
             print("🔒 SSL Certificate error - common on iOS");
           } else if (e.type == DioExceptionType.connectionError) {
             print("🌐 Connection error - check network/firewall");
           }
           
           print("Stack trace: ${e.stackTrace}");
           print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
         }
         
         // Check for 429 or 5xx to retry
         bool shouldRetry = false;
         final statusCode = e.response?.statusCode;
         
         if (statusCode == 429) {
           shouldRetry = true;
           if (kDebugMode) print("🔄 Rate limited (429) - will retry");
         } else if (statusCode != null && statusCode >= 500) {
           shouldRetry = true;
           if (kDebugMode) print("🔄 Server error ($statusCode) - will retry");
         }
         
         if (shouldRetry && retries < maxRetries) {
            retries++;
            final waitSeconds = pow(2, retries); // Exponential backoff: 2s, 4s, 8s
            if (kDebugMode) print("⏳ Waiting ${waitSeconds}s before retry...");
            await Future.delayed(Duration(seconds: waitSeconds.toInt()));
            continue;
         }
         
         if (kDebugMode) print("❌ Giving up after ${retries + 1} attempts");
         return null; // Give up if other error or max retries
      } catch (e) {
         if (kDebugMode) {
           print("❌ Unexpected error (not DioException): $e");
           print("Stack trace: ${StackTrace.current}");
         }
         return null;
      }
      break; 
    }
    return null;
  }

  Map<String, dynamic> _extractJson(String content) {
    String jsonString = content;
    final regex = RegExp(r'\{.*\}', dotAll: true);
    final match = regex.firstMatch(content);
    if (match != null) {
      jsonString = match.group(0)!;
    }
     return jsonDecode(jsonString);
  }

  String _buildForbiddenInfo(List<WordPair> history) {
     final Set<String> forbidden = {};
     for (final pair in history) {
        forbidden.add(pair.civilian.toLowerCase().trim());
        forbidden.add(pair.infiltrator.toLowerCase().trim());
     }
     if (forbidden.isEmpty) return "None";
     return forbidden.join(", ");
  }

  Future<void> _saveLog(String category, String catDesc, String civ, String inf, String thoughts) async {
      final logService = GameLogService();
      final logEntry = GameLogEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        promptVersion: "3.0-MultiAgent",
        category: category,
        categoryDescription: catDesc,
        civilian: civ,
        infiltrator: inf,
        timestamp: DateTime.now(),
        thoughtProcess: thoughts, // Save the full conversation
      );
      await logService.saveLogEntry(logEntry);
  }
}
