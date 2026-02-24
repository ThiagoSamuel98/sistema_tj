# ⚖️ Sistema TJ - Gestão Documental Pro

> **Status:** 🚀 Versão 2.0 (Clean Architecture)  
> **Desenvolvedor:** Thiago Samuel  
> **Instituição:** Tribunal de Justiça (TJ)

Este repositório contém uma aplicação **Ruby on Rails 8** de alta performance, desenvolvida para o gerenciamento eletrônico de documentos jurídicos. O projeto foca em três pilares: **Simplicidade**, **Segurança** e **Inteligência**.

---

## 🛠️ Stack Tecnológica de Elite

| Tecnologia | Versão | Papel no Projeto |
| :--- | :--- | :--- |
| **Ruby** | `3.4.4` | Linguagem base com foco em produtividade. |
| **Rails** | `8.0.4` | Framework web com arquitetura "Solid" (No-Redis). |
| **SQLite 3** | `3.x` | Banco de dados com suporte a concorrência e persistência em `storage/`. |
| **Tailwind CSS** | `3.x` | Framework utilitário para design responsivo e moderno. |
| **Brakeman** | `Latest` | Auditoria de segurança estática para prevenção de falhas. |

---

## 🏗️ Arquitetura e Diferenciais Técnicos

### 1. Solid Architecture (Rails 8)
Diferente das versões anteriores, este projeto utiliza o banco de dados para gerenciar cache e filas de processos, simplificando o deploy e mantendo a robustez necessária para o ambiente do Tribunal.

### 2. Fluxo de Trabalho Integrado com IA
O projeto utiliza diretrizes em `.github/copilot-instructions.md` para garantir que assistentes de IA (Copilot/Qwen) mantenham a consistência do código e as regras de negócio do TJ.

### 3. Segurança de Dados Jurídicos
Implementação de validações em nível de Model e limpeza de parâmetros em nível de Controller (Strong Parameters), garantindo que apenas dados autorizados cheguem ao banco.

---

## 🚀 Guia de Instalação e Execução

### Pré-requisitos
- Ruby 3.4.4
- SQLite 3
