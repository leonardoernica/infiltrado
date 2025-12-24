# 🕵️ O Infiltrado (The Infiltrator)

**O Infiltrado** é um jogo de dedução social mobile construído com **Flutter**, onde a inteligência artificial não é apenas um assistente, mas o "Game Master" criativo que desafia os jogadores.

O objetivo é simples: descobrir quem é o impostor (Infiltrado) entre os civis, baseando-se em uma única palavra secreta e dicas sutis.

---

## 🧠 Arquitetura de IA Multi-Agente

O coração do jogo é um sistema sofisticado de **3 Agentes de IA** que trabalham em conjunto para gerar partidas equilibradas, criativas e infinitas. Diferente de jogos com bancos de dados estáticos, *O Infiltrado* cria conteúdo novo a cada rodada.

### O Fluxo de Criação (The Pipeline):

1.  🎬 **Agente 1: O Diretor (The Director)**
    *   **Função:** Seleção de Conteúdo & Gerenciamento de Histórico.
    *   **Lógica:** Analisa o histórico da partida para evitar repetições, faz um brainstorming de conceitos populares dentro da categoria escolhida (ex: Cinema, História, Animais) e seleciona uma "Palavra Civil" (ex: "Zebra").
    *   **Objetivo:** Garantir variedade e popularidade.

2.  🎨 **Agente 2: O Designer (The Designer)**
    *   **Função:** Criação de Pistas (Lateral Thinking).
    *   **Lógica:** Recebe a palavra do Diretor e cria uma "Palavra do Infiltrado" que serve como dica. Usa estratégias avançadas como:
        *   *Polissemia:* (ex: "Banco" -> Dica "Dinheiro").
        *   *Associação Icônica:* (ex: "Zebra" -> Dica "Listras").
        *   *Cultura Pop:* (ex: "Pinguim" -> Dica "Batman").
    *   **Objetivo:** Criar uma conexão inteligente, mas não óbvia.

3.  🛡️ **Agente 3: O Guardião (The Guardian)**
    *   **Função:** Controle de Qualidade & Balanceamento.
    *   **Lógica:** Atua como um juiz rigoroso. Ele valida a sugestão do Designer contra um checklist estrito:
        *   *Check de Raiz:* "Flor" e "Floricultura" são proibidos (mesma raiz).
        *   *Check de Obviedade Reversa:* "Se eu ouvir a dica, a resposta é imediata?". (ex: Listras -> Zebra é rejeitado se for a única associação possível).
        *   *Check de Linguagem:* Rejeita anglicismos obscuros (ex: "Tuxedo") em favor de termos nativos ("Fraque").
    *   **Feedback Loop:** Se o Guardião rejeita, ele devolve um feedback preciso para o Designer tentar de novo.

---

## 🛠️ Tecnologias

*   **Frontend:** Flutter (Dart).
*   **AI Engine:** OpenRouter API (modelos Qwen/LLaMA via HTTP).
*   **State Management:** Provider / Riverpod.
*   **Architecture:** Clean Architecture (Data -> Domain -> Presentation).

## 🚀 Como Rodar

1.  Clone o repositório.
2.  Crie um arquivo `.env` na raiz (adicionado ao `.gitignore` por segurança) com sua chave:
    ```
    OPEN_ROUTER_API_KEY=sua_chave_aqui
    ```
3.  Instale as dependências:
    ```bash
    flutter pub get
    ```
4.  Execute:
    ```bash
    flutter run
    ```
