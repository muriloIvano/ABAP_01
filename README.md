# 🧾 ABAP – Relatório de Clientes / Fornecedores com Exportação TXT e ALV
Este projeto apresenta um relatório ABAP que permite consultar clientes, fornecedores ou ambos, aplicar filtros dinâmicos, formatar CPF/CNPJ, exibir resultados em ALV e exportar os dados para arquivo TXT.

📦 Funcionalidades
🔍 Consultas Disponíveis

O relatório permite três modos de execução:

Clientes (KNA1)

Fornecedores (LFA1)

Ambos (Clientes + Fornecedores)

🎚️ Filtros Disponíveis

Número do cliente (KUNNR)

Número do fornecedor (LIFNR)

País (LAND1)

Região (REGIO)

Faixa genérica para ambos (SELECT-OPTIONS)

🏗️ Processamento de Dados

Mescla de dados de clientes e fornecedores em uma única estrutura

Classificação do tipo: CLIENTE ou FORNECEDOR

Formatação automática:

CPF → 999.999.999-99

CNPJ → 99.999.999/9999-99

Preenchimento padrão para valores vazios

📤 Exportação

Exportação para arquivo TXT

Seleção do diretório via cl_gui_frontend_services=>file_save_dialog

Download usando GUI_DOWNLOAD (modo ASCII)

📊 Exibição ALV

Utilizando a classe CL_SALV_TABLE:

Ocultação de campos técnicos

Ajuste automático de colunas

Layout zebrado

Funções padrão habilitadas

Textos de colunas personalizados no modo "Ambos"

🧱 Conceitos ABAP Utilizados

Manipulação de tabelas internas e estruturas customizadas

Organização do código em FORMs

Uso de SELECT-OPTIONS com ativação dinâmica via MODIF ID

Manipulação de SCREEN usando radiobuttons

Concatenação e formatação de strings

Classes utilizadas:

CL_SALV_TABLE (ALV)

CL_GUI_FRONTEND_SERVICES (file dialog)

Função GUI_DOWNLOAD para geração do TXT

Ordenação, contagem e mensagens dinâmicas

📁 Estrutura Geral do Programa
Rotina	Descrição
SELECT_DATA	Realiza as leituras conforme o modo selecionado
PROCESS_DATA	Formata CPF/CNPJ e monta mensagens
BUILD_FILE	Gera o arquivo TXT no diretório selecionado
OUTPUT	Exibe o ALV com layout configurado
🎯 Objetivo

Este projeto tem como objetivos principais:

Praticar consultas dinâmicas em KNA1 e LFA1

Demonstrar técnicas de manipulação e formatação de dados fiscais

Aplicar lógica condicional na tela de seleção com radiobuttons + MODIF ID

Exibir resultados via ALV com layout profissional

Realizar exportação para arquivos TXT no frontend

Consolidar boas práticas na criação de relatórios ABAP

👨‍💻 Autor

Murilo Valentim
