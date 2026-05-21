CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TYPE papel_usuario AS ENUM ('aluno', 'admin_escolar', 'admin_global');

CREATE TYPE status_sessao AS ENUM ('em_andamento', 'concluida');

CREATE TABLE auth_users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE perfis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID UNIQUE NOT NULL,
    nome_completo VARCHAR(255) NOT NULL,
    papel papel_usuario NOT NULL DEFAULT 'aluno',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auth_user
        FOREIGN KEY (auth_user_id)
        REFERENCES auth_users(id)
        ON DELETE CASCADE
);

CREATE TABLE escolas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(255) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    admin_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_admin
        FOREIGN KEY (admin_id)
        REFERENCES perfis(id)
);

CREATE TABLE matriculas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aluno_id UUID NOT NULL,
    escola_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_aluno
        FOREIGN KEY (aluno_id)
        REFERENCES perfis(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_escola
        FOREIGN KEY (escola_id)
        REFERENCES escolas(id)
        ON DELETE CASCADE,
    CONSTRAINT unique_matricula
        UNIQUE (aluno_id, escola_id)
);

CREATE TABLE questoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_interno INTEGER NOT NULL,
    enunciado JSONB NOT NULL,
    alternativas JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sessoes_simulado (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aluno_id UUID NOT NULL,
    status status_sessao NOT NULL DEFAULT 'em_andamento',
    iniciado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finalizado_em TIMESTAMP,
    total_questoes INTEGER DEFAULT 0,
    total_acertos INTEGER DEFAULT 0,
    CONSTRAINT fk_aluno_sessao
        FOREIGN KEY (aluno_id)
        REFERENCES perfis(id)
        ON DELETE CASCADE
);

CREATE TABLE respostas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sessao_id UUID NOT NULL,
    questao_id UUID NOT NULL,
    alternativa_escolhida INTEGER NOT NULL,
    acertou BOOLEAN NOT NULL,
    respondido_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sessao
        FOREIGN KEY (sessao_id)
        REFERENCES sessoes_simulado(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_questao
        FOREIGN KEY (questao_id)
        REFERENCES questoes(id)
        ON DELETE CASCADE,
    CONSTRAINT unique_resposta
        UNIQUE (sessao_id, questao_id)
);

CREATE INDEX ON matriculas(aluno_id);

CREATE INDEX ON matriculas(escola_id);

CREATE INDEX ON sessoes_simulado(aluno_id);

CREATE INDEX ON respostas(sessao_id);

CREATE INDEX ON respostas(questao_id);
