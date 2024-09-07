CREATE TABLE IF NOT EXISTS public.cadastro --Criação da tabela de cadastros, basico e sem muita complicação
(
    id SERIAL,
    nome character varying(50) COLLATE pg_catalog."default" NOT NULL,
    documento character varying(25) COLLATE pg_catalog."default" NOT NULL,
    cep character varying(25) COLLATE pg_catalog."default" NOT NULL,
    estado character varying(25) COLLATE pg_catalog."default" NOT NULL,
    cidade character varying(25) COLLATE pg_catalog."default" NOT NULL,
    endereco character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT cadastros_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.cadastros
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public.cadastros_tags -- aqui a gente cria a tabela de relação N:N entre os cadastros e as tags
(
    cadastro_id integer,
    tag_id integer,
    CONSTRAINT cadastros_tags_cadastro_id_fkey FOREIGN KEY (cadastro_id)
        REFERENCES public.cadastros (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT cadastros_tags_tag_id_fkey FOREIGN KEY (tag_id)
        REFERENCES public.tags (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.cadastros_tags
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS public.categorias --criação das categorias
(
    id SERIAL,
    titulo character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT categorias_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;


ALTER TABLE IF EXISTS public.categorias -- Aqui é o mais complicadinho de todos, fica melhor explicar em voz pra não ficar muito sujo, então deixarei sem comentarios
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public.lancamentos
(
    id SERIAL,
    tipo character varying(10) COLLATE pg_catalog."default" NOT NULL,
    status character varying(10) COLLATE pg_catalog."default" NOT NULL,
    descricao character varying(255) COLLATE pg_catalog."default" NOT NULL,
    valor numeric(10,2) NOT NULL,
    valor_liquidado numeric(10,2) DEFAULT 0,
    vencimento date NOT NULL,
    liquidacao date,
    cadastro_id integer,
    categoria_id integer,
    CONSTRAINT lancamentos_pkey PRIMARY KEY (id),
    CONSTRAINT lancamentos_cadastro_id_fkey FOREIGN KEY (cadastro_id)
        REFERENCES public.cadastros (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT lancamentos_categoria_id_fkey FOREIGN KEY (categoria_id)
        REFERENCES public.categorias (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT lancamentos_tipo_check CHECK (tipo::text = ANY (ARRAY['pagar'::character varying::text, 'receber'::character varying::text])),
    CONSTRAINT lancamentos_status_check CHECK (status::text = ANY (ARRAY['aberto'::character varying::text, 'liquidado'::character varying::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.lancamentos
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS public.tags -- criação das tags
(
    id SERIAL,
    titulo character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT tags_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tags
    OWNER to postgres;