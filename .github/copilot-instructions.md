Propósito
- Fornecer instruções concisas e específicas do repositório para futuras sessões do Copilot CLI: como compilar, testar, rodar linter, onde ficam comportamentos chave e convenções que impactam automação.

Comandos de build, teste e lint
- Instalar dependências: bundle install
- Rodar a aplicação em desenvolvimento: bin/rails server
- Executar toda a suíte de testes: bin/rails test (o CI usa `bin/rails db:test:prepare test`)
- Executar um arquivo de teste específico: bin/rails test TEST=test/caminho/para/arquivo_test.rb
- Executar um teste específico por linha: bin/rails test test/caminho/para/arquivo_test.rb:42
- Executar um teste por nome (minitest): bin/rails test TEST=test/caminho/para/arquivo_test.rb -n '/nome do teste/'
- Preparar ou resetar o banco (dev/test): bin/rails db:setup e bin/rails db:test:prepare
- Lint com RuboCop: bin/rubocop (CI usa `bin/rubocop -f github`)
- Scan de segurança (estático): bin/brakeman --no-pager
- Build Docker (container): docker build -t <nome> .

Arquitetura em alto nível
- Aplicação Rails 8 com a estrutura padrão (app/, config/, db/, test/, lib/, public/).
- Usa SQLite para armazenamento local/dev/test (arquivos em storage/) e possui múltiplas roles de banco em produção (primary, cache, queue, cable) configuradas em config/database.yml; migrations para essas roles ficam em paths separados (ex.: db/cache_migrate).
- Filas/Cache/Cable são suportados por adaptadores baseados em banco de dados fornecidos pelos gems solid_* (solid_cache, solid_queue, solid_cable), em vez de serviços externos por padrão.
- Puma é o servidor web (bin/puma); thruster pode ser usado para aceleração de assets e bootsnap está habilitado para boot mais rápido.
- Deploy é automatizado com Kamal (gem kamal) e config/deploy.yml; o projeto também tem Dockerfile e configuração .kamal/ para containerização/desdobramento.
- Testes usam Minitest (gem minitest) executados pelo runner do Rails; o CI executa testes, Brakeman e RuboCop conforme .github/workflows/ci.yml.

Convenções e padrões específicos do repositório
- Use os binstubs em bin/ (bin/rails, bin/rubocop, bin/brakeman) como pontos de entrada preferenciais para garantir ambiente consistente (mesma versão do Bundler/cache usado pelo CI).
- Arquivos de banco SQLite ficam em storage/; certifique-se de que essa pasta exista antes de rodar comandos que criam/abram o DB (CI/Docker podem montar ou preparar esse diretório).
- Produção está configurada com múltiplas roles de banco (primary, cache, queue, cable); as migrations podem estar em pastas separadas e o código assume a existência dessas roles.
- Adaptadores personalizados: procure por solid_cache, solid_queue e solid_cable ao rastrear comportamento de filas, cache ou WebSockets.
- Ferramentas de lint e segurança (rubocop-rails-omakase, brakeman) estão no grupo de desenvolvimento/test e são invocadas via bin/ scripts; o CI espelha esses comandos (use `-f github` quando relevante para integração com Actions).
- Tarefas Rake personalizadas devem ficar em lib/tasks/*.rake; o Rakefile carrega as tasks da aplicação Rails por padrão.
- O CI usa o arquivo .ruby-version para configurar a versão do Ruby; reproduza esse arquivo localmente ao tentar reproduzir execuções do CI.

Arquivos para checar primeiro ao automatizar ou depurar
- README.md — notas básicas do projeto
- Gemfile / Gemfile.lock — dependências e grupos (dev/test contêm rubocop, brakeman, minitest)
- config/database.yml — roles de banco e paths de storage
- .github/workflows/ci.yml — padrões de comando do CI para replicar localmente
- config/deploy.yml e .kamal/ — configurações de deploy com Kamal
- bin/* — use estes binstubs para execução consistente de comandos

Outros arquivos de configuração de IA a considerar
- Não foram encontrados CLAUDE.md, AGENTS.md, .cursorrules ou arquivos AI-equivalentes; se adicionados, incorporar trechos relevantes neste documento.

MCP servers
- Deseja configurar algum servidor MCP relevante para este projeto Rails (por exemplo, Playwright ou um runner E2E baseado em navegador)?

Resumo
- Arquivo .github/copilot-instructions.md atualizado em Português com comandos de build/test/lint, arquitetura em alto nível e convenções do repositório. Diga se deseja ajustes ou acréscimos (por exemplo, passos de CI mais detalhados, runbooks de deploy ou exemplos adicionais de execução de testes).