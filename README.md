# ABAP – Relatório de Clientes / Fornecedores com Exportação TXT e ALV

Este projeto apresenta um relatório ABAP que permite consultar **clientes**, **fornecedores** ou **ambos**, aplicar filtros dinâmicos, formatar CPF/CNPJ, exibir resultados em ALV e exportar os dados para arquivo TXT.

---

## Funcionalidades

### Consultas Disponíveis
O relatório permite três modos de execução:

- Clientes (KNA1)
- Fornecedores (LFA1)
- Ambos (Clientes + Fornecedores)

### Filtros Disponíveis
- Número do cliente (KUNNR)
- Número do fornecedor (LIFNR)
- País (LAND1)
- Região (REGIO)

### Processamento de Dados
- Mescla de dados de clientes e fornecedores em uma mesma estrutura
- Identificação do tipo: **CLIENTE** ou **FORNECEDOR**
- Formatação automática de:
  - CPF → 999.999.999-99
  - CNPJ → 99.999.999/9999-99
- Preenchimento padrão quando o campo estiver vazio

### Exportação
- Exportação para arquivo **TXT**
- Seleção de diretório via `cl_gui_frontend_services=>file_save_dialog`
- Download utilizando a função `GUI_DOWNLOAD`

### Exibição ALV
Usando a classe `CL_SALV_TABLE`:

---

## Conceitos ABAP Utilizados

- Manipulação de tabelas internas
- Organização do código em FORM routines
- Uso de SELECT-OPTIONS com ativação dinâmica via `MODIF ID`
- Controle da tela com loops em `SCREEN`
- Classes:
  - `CL_SALV_TABLE`
  - `CL_GUI_FRONTEND_SERVICES`
- Exportação com `GUI_DOWNLOAD`

---

## Estrutura Geral do Programa

| Rotina        | Descrição |
|---------------|-----------|
| `SELECT_DATA` | Carrega os dados conforme o modo escolhido |
| `PROCESS_DATA` | Formata dados fiscais e monta mensagens |
| `BUILD_FILE` | Gera o arquivo TXT |
| `OUTPUT` | Exibe o ALV |

---

## Objetivo

Este projeto tem como objetivo demonstrar:

- Consultas dinâmicas em KNA1 e LFA1  
- Técnicas de formatação de CPF e CNPJ  
- Manipulação da tela de seleção com radiobuttons  
- Exibição estruturada via ALV  
- Exportação de dados para arquivos TXT  
- Boas práticas em relatórios ABAP

---

## Autor

**Murilo Valentim**
