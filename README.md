## Sobre o Projeto - Banco de Dados: Simulador ENEM

Entrega da avaliação prática N2 da disciplina de Banco de Dados, ministrada pelo professor Martim Dietterle no curso de Engenharia de Software (3º período) da Universidade Católica de Santa Catarina — Jaraguá do Sul. O trabalho consiste na modelagem completa de um banco de dados relacional (PostgreSQL) para o Simulador ENEM, uma plataforma educacional no modelo B2B2C voltada para escolas parceiras e seus alunos, contemplando gestão de usuários, estrutura escolar, banco de questões e dinâmica de simulados.


## Integrantes

- João Eduardo Capelari 
- Jorge Luiz Horn Júnior  
- Lorenzo Foralosso Kochemborger
- Matheus Henrique Pompeu

## Decisões Técnicas

- UUIDs como chaves primárias em todas as entidades
- JSONB para enunciados e alternativas de questões, suportando fórmulas, tabelas e referências a imagens
- Trigger para criação automática de perfil ao registrar novo usuário na autenticação
- ON DELETE CASCADE em respostas ao deletar uma questão
- RLS com isolamento por papel: alunos acessam apenas seus próprios dados; admins escolares acessam apenas dados de sua instituição; banco de questões é leitura pública para autenticados

🔗 DER do Projeto:

![DER](der/DER_-__N2_Banco_de_Dados_Simulador_ENEM.png)

---
