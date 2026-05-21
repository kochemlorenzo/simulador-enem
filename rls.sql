ALTER TABLE perfis ENABLE ROW LEVEL SECURITY;

ALTER TABLE escolas ENABLE ROW LEVEL SECURITY;

ALTER TABLE matriculas ENABLE ROW LEVEL SECURITY;

ALTER TABLE questoes ENABLE ROW LEVEL SECURITY;

ALTER TABLE sessoes_simulado ENABLE ROW LEVEL SECURITY;

ALTER TABLE respostas ENABLE ROW LEVEL SECURITY;


CREATE POLICY aluno_perfil_select
ON perfis
FOR SELECT
USING (
    auth_user_id = current_setting('app.user_id')::UUID
);

CREATE POLICY aluno_perfil_update
ON perfis
FOR UPDATE
USING (
    auth_user_id = current_setting('app.user_id')::UUID
);


CREATE POLICY aluno_matriculas_select
ON matriculas
FOR SELECT
USING (
    aluno_id IN (
        SELECT id
        FROM perfis
        WHERE auth_user_id =
        current_setting('app.user_id')::UUID
    )
);


CREATE POLICY aluno_sessoes_select
ON sessoes_simulado
FOR SELECT
USING (
    aluno_id IN (
        SELECT id
        FROM perfis
        WHERE auth_user_id =
        current_setting('app.user_id')::UUID
    )
);

CREATE POLICY aluno_sessoes_insert
ON sessoes_simulado
FOR INSERT
WITH CHECK (
    aluno_id IN (
        SELECT id
        FROM perfis
        WHERE auth_user_id =
        current_setting('app.user_id')::UUID
    )
);


CREATE POLICY aluno_respostas_select
ON respostas
FOR SELECT
USING (
    sessao_id IN (
        SELECT id
        FROM sessoes_simulado
        WHERE aluno_id IN (
            SELECT id
            FROM perfis
            WHERE auth_user_id =
            current_setting('app.user_id')::UUID
        )
    )
);

CREATE POLICY aluno_respostas_insert
ON respostas
FOR INSERT
WITH CHECK (
    sessao_id IN (
        SELECT id
        FROM sessoes_simulado
        WHERE aluno_id IN (
            SELECT id
            FROM perfis
            WHERE auth_user_id =
            current_setting('app.user_id')::UUID
        )
    )
);


CREATE POLICY admin_escola_select
ON escolas
FOR SELECT
USING (
    admin_id IN (
        SELECT id
        FROM perfis
        WHERE auth_user_id =
        current_setting('app.user_id')::UUID
    )
);


CREATE POLICY admin_matriculas_select
ON matriculas
FOR SELECT
USING (
    escola_id IN (
        SELECT id
        FROM escolas
        WHERE admin_id IN (
            SELECT id
            FROM perfis
            WHERE auth_user_id =
            current_setting('app.user_id')::UUID
        )
    )
);

CREATE POLICY admin_matriculas_insert
ON matriculas
FOR INSERT
WITH CHECK (
    escola_id IN (
        SELECT id
        FROM escolas
        WHERE admin_id IN (
            SELECT id
            FROM perfis
            WHERE auth_user_id =
            current_setting('app.user_id')::UUID
        )
    )
);


CREATE POLICY admin_sessoes_select
ON sessoes_simulado
FOR SELECT
USING (
    aluno_id IN (
        SELECT aluno_id
        FROM matriculas
        WHERE escola_id IN (
            SELECT id
            FROM escolas
            WHERE admin_id IN (
                SELECT id
                FROM perfis
                WHERE auth_user_id =
                current_setting('app.user_id')::UUID
            )
        )
    )
);


CREATE POLICY admin_respostas_select
ON respostas
FOR SELECT
USING (
    sessao_id IN (
        SELECT id
        FROM sessoes_simulado
        WHERE aluno_id IN (
            SELECT aluno_id
            FROM matriculas
            WHERE escola_id IN (
                SELECT id
                FROM escolas
                WHERE admin_id IN (
                    SELECT id
                    FROM perfis
                    WHERE auth_user_id =
                    current_setting('app.user_id')::UUID
                )
            )
        )
    )
);


CREATE POLICY questoes_read_policy
ON questoes
FOR SELECT
USING (true);

CREATE POLICY admin_matriculas_delete
ON matriculas
FOR DELETE
USING (
    escola_id IN (
        SELECT id
        FROM escolas
        WHERE admin_id IN (
            SELECT id
            FROM perfis
            WHERE auth_user_id =
            current_setting('app.user_id')::UUID
        )
    )
);

CREATE POLICY admin_escola_update
ON escolas
FOR UPDATE
USING (
    admin_id IN (
        SELECT id
        FROM perfis
        WHERE auth_user_id =
        current_setting('app.user_id')::UUID
    )
);

CREATE POLICY aluno_sessoes_update
ON sessoes_simulado
FOR UPDATE
USING (
    aluno_id IN (
        SELECT id
        FROM perfis
        WHERE auth_user_id =
        current_setting('app.user_id')::UUID
    )
);
