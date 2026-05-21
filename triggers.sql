CREATE OR REPLACE FUNCTION criar_perfil_automatico()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO perfis (
        auth_user_id,
        nome_completo,
        papel
    )
    VALUES (
        NEW.id,
        'Novo Usuário',
        COALESCE(
            (NEW.raw_user_meta_data->>'papel')::papel_usuario,
            'aluno'
        )
    );

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_criar_perfil
AFTER INSERT ON auth_users
FOR EACH ROW
EXECUTE FUNCTION criar_perfil_automatico();


CREATE OR REPLACE FUNCTION validar_admin_escolar()
RETURNS TRIGGER AS $$
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM perfis
        WHERE id = NEW.admin_id
        AND papel = 'admin_escolar'
    ) THEN

        RAISE EXCEPTION
        'Usuário precisa ter papel admin_escolar para gerenciar uma escola';

    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_admin
BEFORE INSERT OR UPDATE
ON escolas
FOR EACH ROW
EXECUTE FUNCTION validar_admin_escolar();


CREATE OR REPLACE FUNCTION atualizar_contadores_sessao()
RETURNS TRIGGER AS $$
BEGIN

    UPDATE sessoes_simulado
    SET
        total_questoes = (
            SELECT COUNT(*)
            FROM respostas
            WHERE sessao_id = NEW.sessao_id
        ),

        total_acertos = (
            SELECT COUNT(*)
            FROM respostas
            WHERE sessao_id = NEW.sessao_id
            AND acertou = true
        )

    WHERE id = NEW.sessao_id;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_contadores
AFTER INSERT ON respostas
FOR EACH ROW
EXECUTE FUNCTION atualizar_contadores_sessao();
