--
-- PostgreSQL database dump
--

\restrict YCWhXzbg9Nm4eef9ktswozSQYe0wi3sz3dY1koP1zt0smVIsCrvjaYHri2gE4F3

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

-- Started on 2026-04-27 20:32:12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 250 (class 1259 OID 16695)
-- Name: alternativas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alternativas (
    id integer NOT NULL,
    pregunta_id integer,
    texto text,
    es_correcta boolean DEFAULT false
);


ALTER TABLE public.alternativas OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16694)
-- Name: alternativas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alternativas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alternativas_id_seq OWNER TO postgres;

--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 249
-- Name: alternativas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alternativas_id_seq OWNED BY public.alternativas.id;


--
-- TOC entry 244 (class 1259 OID 16639)
-- Name: alumnos_pendientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alumnos_pendientes (
    id integer NOT NULL,
    curso_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    correo character varying(150) NOT NULL,
    estado character varying(30) DEFAULT 'pendiente'::character varying,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.alumnos_pendientes OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16638)
-- Name: alumnos_pendientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alumnos_pendientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alumnos_pendientes_id_seq OWNER TO postgres;

--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 243
-- Name: alumnos_pendientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alumnos_pendientes_id_seq OWNED BY public.alumnos_pendientes.id;


--
-- TOC entry 224 (class 1259 OID 16461)
-- Name: asignaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asignaciones (
    id integer NOT NULL,
    lectura_id integer NOT NULL,
    curso_id integer,
    alumno_id integer,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    CONSTRAINT asignaciones_check CHECK ((((curso_id IS NOT NULL) AND (alumno_id IS NULL)) OR ((curso_id IS NULL) AND (alumno_id IS NOT NULL))))
);


ALTER TABLE public.asignaciones OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16460)
-- Name: asignaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asignaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asignaciones_id_seq OWNER TO postgres;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 223
-- Name: asignaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asignaciones_id_seq OWNED BY public.asignaciones.id;


--
-- TOC entry 246 (class 1259 OID 16657)
-- Name: asignaciones_lectura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asignaciones_lectura (
    id integer NOT NULL,
    lectura_id integer NOT NULL,
    alumno_id integer NOT NULL,
    curso_id integer NOT NULL,
    fecha_asignacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(30) DEFAULT 'asignada'::character varying
);


ALTER TABLE public.asignaciones_lectura OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16656)
-- Name: asignaciones_lectura_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asignaciones_lectura_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asignaciones_lectura_id_seq OWNER TO postgres;

--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 245
-- Name: asignaciones_lectura_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asignaciones_lectura_id_seq OWNED BY public.asignaciones_lectura.id;


--
-- TOC entry 240 (class 1259 OID 16602)
-- Name: canjes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.canjes (
    id integer NOT NULL,
    alumno_id integer NOT NULL,
    recompensa_id integer NOT NULL,
    puntos_gastados integer NOT NULL,
    fecha_canje timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.canjes OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16601)
-- Name: canjes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.canjes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.canjes_id_seq OWNER TO postgres;

--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 239
-- Name: canjes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.canjes_id_seq OWNED BY public.canjes.id;


--
-- TOC entry 248 (class 1259 OID 16684)
-- Name: cuestionarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuestionarios (
    id integer NOT NULL,
    docente_id integer,
    lectura_id integer,
    titulo text,
    estado character varying(20) DEFAULT 'borrador'::character varying,
    creado_en timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cuestionarios OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 16710)
-- Name: cuestionarios_asignados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuestionarios_asignados (
    id integer NOT NULL,
    cuestionario_id integer,
    curso_id integer,
    fecha_envio timestamp without time zone DEFAULT now(),
    activo boolean DEFAULT true
);


ALTER TABLE public.cuestionarios_asignados OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16709)
-- Name: cuestionarios_asignados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuestionarios_asignados_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cuestionarios_asignados_id_seq OWNER TO postgres;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 251
-- Name: cuestionarios_asignados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuestionarios_asignados_id_seq OWNED BY public.cuestionarios_asignados.id;


--
-- TOC entry 247 (class 1259 OID 16683)
-- Name: cuestionarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuestionarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cuestionarios_id_seq OWNER TO postgres;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 247
-- Name: cuestionarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuestionarios_id_seq OWNED BY public.cuestionarios.id;


--
-- TOC entry 218 (class 1259 OID 16413)
-- Name: cursos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cursos (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    nivel character varying(20) NOT NULL,
    anio integer NOT NULL,
    docente_id integer
);


ALTER TABLE public.cursos OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16412)
-- Name: cursos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cursos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cursos_id_seq OWNER TO postgres;

--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 217
-- Name: cursos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cursos_id_seq OWNED BY public.cursos.id;


--
-- TOC entry 242 (class 1259 OID 16620)
-- Name: eventos_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventos_log (
    id integer NOT NULL,
    usuario_id integer,
    tipo_evento character varying(100) NOT NULL,
    detalle text,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.eventos_log OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16619)
-- Name: eventos_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eventos_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eventos_log_id_seq OWNER TO postgres;

--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 241
-- Name: eventos_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.eventos_log_id_seq OWNED BY public.eventos_log.id;


--
-- TOC entry 230 (class 1259 OID 16514)
-- Name: intentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.intentos (
    id integer NOT NULL,
    alumno_id integer NOT NULL,
    lectura_id integer NOT NULL,
    puntaje numeric(5,2) DEFAULT 0 NOT NULL,
    aprobado boolean DEFAULT false,
    duracion_seg integer,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cuestionario_id integer
);


ALTER TABLE public.intentos OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16513)
-- Name: intentos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.intentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.intentos_id_seq OWNER TO postgres;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 229
-- Name: intentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.intentos_id_seq OWNED BY public.intentos.id;


--
-- TOC entry 222 (class 1259 OID 16446)
-- Name: lecturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturas (
    id integer NOT NULL,
    titulo character varying(200) NOT NULL,
    autor character varying(100),
    nivel_dificultad character varying(20) NOT NULL,
    contenido text NOT NULL,
    creado_por integer,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    categoria character varying(100)
);


ALTER TABLE public.lecturas OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16445)
-- Name: lecturas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lecturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lecturas_id_seq OWNER TO postgres;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 221
-- Name: lecturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lecturas_id_seq OWNED BY public.lecturas.id;


--
-- TOC entry 220 (class 1259 OID 16425)
-- Name: matriculas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matriculas (
    id integer NOT NULL,
    alumno_id integer NOT NULL,
    curso_id integer NOT NULL,
    fecha_matricula date DEFAULT CURRENT_DATE,
    estado character varying(20) DEFAULT 'activa'::character varying
);


ALTER TABLE public.matriculas OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16424)
-- Name: matriculas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.matriculas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.matriculas_id_seq OWNER TO postgres;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 219
-- Name: matriculas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matriculas_id_seq OWNED BY public.matriculas.id;


--
-- TOC entry 228 (class 1259 OID 16499)
-- Name: opciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opciones (
    id integer NOT NULL,
    pregunta_id integer NOT NULL,
    texto text NOT NULL,
    es_correcta boolean DEFAULT false NOT NULL
);


ALTER TABLE public.opciones OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16498)
-- Name: opciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.opciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.opciones_id_seq OWNER TO postgres;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 227
-- Name: opciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.opciones_id_seq OWNED BY public.opciones.id;


--
-- TOC entry 226 (class 1259 OID 16484)
-- Name: preguntas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.preguntas (
    id integer NOT NULL,
    lectura_id integer NOT NULL,
    enunciado text NOT NULL,
    tipo character varying(20) DEFAULT 'unica'::character varying,
    orden_pregunta integer NOT NULL,
    cuestionario_id integer
);


ALTER TABLE public.preguntas OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16483)
-- Name: preguntas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.preguntas_id_seq OWNER TO postgres;

--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 225
-- Name: preguntas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.preguntas_id_seq OWNED BY public.preguntas.id;


--
-- TOC entry 234 (class 1259 OID 16556)
-- Name: progreso_lectura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progreso_lectura (
    id integer NOT NULL,
    alumno_id integer NOT NULL,
    lectura_id integer NOT NULL,
    porcentaje_avance integer DEFAULT 0 NOT NULL,
    ultima_pagina integer DEFAULT 1,
    actualizado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT progreso_lectura_porcentaje_avance_check CHECK (((porcentaje_avance >= 0) AND (porcentaje_avance <= 100)))
);


ALTER TABLE public.progreso_lectura OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16555)
-- Name: progreso_lectura_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.progreso_lectura_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.progreso_lectura_id_seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 233
-- Name: progreso_lectura_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.progreso_lectura_id_seq OWNED BY public.progreso_lectura.id;


--
-- TOC entry 238 (class 1259 OID 16589)
-- Name: puntos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.puntos (
    id integer NOT NULL,
    alumno_id integer NOT NULL,
    motivo character varying(150) NOT NULL,
    delta integer NOT NULL,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.puntos OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16588)
-- Name: puntos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.puntos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.puntos_id_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 237
-- Name: puntos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.puntos_id_seq OWNED BY public.puntos.id;


--
-- TOC entry 236 (class 1259 OID 16579)
-- Name: recompensas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recompensas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    puntos_necesarios integer NOT NULL,
    CONSTRAINT recompensas_puntos_necesarios_check CHECK ((puntos_necesarios >= 0))
);


ALTER TABLE public.recompensas OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16578)
-- Name: recompensas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recompensas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recompensas_id_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 235
-- Name: recompensas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recompensas_id_seq OWNED BY public.recompensas.id;


--
-- TOC entry 232 (class 1259 OID 16534)
-- Name: respuestas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.respuestas (
    id integer NOT NULL,
    intento_id integer NOT NULL,
    pregunta_id integer NOT NULL,
    opcion_id integer NOT NULL,
    correcta boolean NOT NULL
);


ALTER TABLE public.respuestas OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 16725)
-- Name: respuestas_alumno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.respuestas_alumno (
    id integer NOT NULL,
    alumno_id integer,
    pregunta_id integer,
    alternativa_id integer,
    es_correcta boolean,
    respondido_en timestamp without time zone DEFAULT now()
);


ALTER TABLE public.respuestas_alumno OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 16724)
-- Name: respuestas_alumno_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.respuestas_alumno_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.respuestas_alumno_id_seq OWNER TO postgres;

--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 253
-- Name: respuestas_alumno_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.respuestas_alumno_id_seq OWNED BY public.respuestas_alumno.id;


--
-- TOC entry 231 (class 1259 OID 16533)
-- Name: respuestas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.respuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.respuestas_id_seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 231
-- Name: respuestas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.respuestas_id_seq OWNED BY public.respuestas.id;


--
-- TOC entry 216 (class 1259 OID 16400)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    correo character varying(150) NOT NULL,
    password text NOT NULL,
    rol character varying(20) NOT NULL,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT false,
    verification_token text,
    asignatura character varying(100),
    curso character varying(50),
    es_profesor_jefe boolean DEFAULT false,
    CONSTRAINT usuarios_rol_check CHECK (((rol)::text = ANY ((ARRAY['alumno'::character varying, 'docente'::character varying, 'admin'::character varying])::text[])))
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16399)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 215
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 4870 (class 2604 OID 16698)
-- Name: alternativas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alternativas ALTER COLUMN id SET DEFAULT nextval('public.alternativas_id_seq'::regclass);


--
-- TOC entry 4861 (class 2604 OID 16642)
-- Name: alumnos_pendientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumnos_pendientes ALTER COLUMN id SET DEFAULT nextval('public.alumnos_pendientes_id_seq'::regclass);


--
-- TOC entry 4840 (class 2604 OID 16464)
-- Name: asignaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones ALTER COLUMN id SET DEFAULT nextval('public.asignaciones_id_seq'::regclass);


--
-- TOC entry 4864 (class 2604 OID 16660)
-- Name: asignaciones_lectura id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones_lectura ALTER COLUMN id SET DEFAULT nextval('public.asignaciones_lectura_id_seq'::regclass);


--
-- TOC entry 4857 (class 2604 OID 16605)
-- Name: canjes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canjes ALTER COLUMN id SET DEFAULT nextval('public.canjes_id_seq'::regclass);


--
-- TOC entry 4867 (class 2604 OID 16687)
-- Name: cuestionarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuestionarios ALTER COLUMN id SET DEFAULT nextval('public.cuestionarios_id_seq'::regclass);


--
-- TOC entry 4872 (class 2604 OID 16713)
-- Name: cuestionarios_asignados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuestionarios_asignados ALTER COLUMN id SET DEFAULT nextval('public.cuestionarios_asignados_id_seq'::regclass);


--
-- TOC entry 4834 (class 2604 OID 16416)
-- Name: cursos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos ALTER COLUMN id SET DEFAULT nextval('public.cursos_id_seq'::regclass);


--
-- TOC entry 4859 (class 2604 OID 16623)
-- Name: eventos_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos_log ALTER COLUMN id SET DEFAULT nextval('public.eventos_log_id_seq'::regclass);


--
-- TOC entry 4845 (class 2604 OID 16517)
-- Name: intentos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intentos ALTER COLUMN id SET DEFAULT nextval('public.intentos_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 16449)
-- Name: lecturas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturas ALTER COLUMN id SET DEFAULT nextval('public.lecturas_id_seq'::regclass);


--
-- TOC entry 4835 (class 2604 OID 16428)
-- Name: matriculas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matriculas ALTER COLUMN id SET DEFAULT nextval('public.matriculas_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 16502)
-- Name: opciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opciones ALTER COLUMN id SET DEFAULT nextval('public.opciones_id_seq'::regclass);


--
-- TOC entry 4841 (class 2604 OID 16487)
-- Name: preguntas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preguntas ALTER COLUMN id SET DEFAULT nextval('public.preguntas_id_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 16559)
-- Name: progreso_lectura id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso_lectura ALTER COLUMN id SET DEFAULT nextval('public.progreso_lectura_id_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 16592)
-- Name: puntos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntos ALTER COLUMN id SET DEFAULT nextval('public.puntos_id_seq'::regclass);


--
-- TOC entry 4854 (class 2604 OID 16582)
-- Name: recompensas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recompensas ALTER COLUMN id SET DEFAULT nextval('public.recompensas_id_seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 16537)
-- Name: respuestas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas ALTER COLUMN id SET DEFAULT nextval('public.respuestas_id_seq'::regclass);


--
-- TOC entry 4875 (class 2604 OID 16728)
-- Name: respuestas_alumno id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas_alumno ALTER COLUMN id SET DEFAULT nextval('public.respuestas_alumno_id_seq'::regclass);


--
-- TOC entry 4830 (class 2604 OID 16403)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 5138 (class 0 OID 16695)
-- Dependencies: 250
-- Data for Name: alternativas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alternativas (id, pregunta_id, texto, es_correcta) FROM stdin;
\.


--
-- TOC entry 5132 (class 0 OID 16639)
-- Dependencies: 244
-- Data for Name: alumnos_pendientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alumnos_pendientes (id, curso_id, nombre, apellido, correo, estado, creado_en) FROM stdin;
\.


--
-- TOC entry 5112 (class 0 OID 16461)
-- Dependencies: 224
-- Data for Name: asignaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asignaciones (id, lectura_id, curso_id, alumno_id, fecha_inicio, fecha_fin) FROM stdin;
1	1	\N	2	2026-03-28	2026-04-05
\.


--
-- TOC entry 5134 (class 0 OID 16657)
-- Dependencies: 246
-- Data for Name: asignaciones_lectura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asignaciones_lectura (id, lectura_id, alumno_id, curso_id, fecha_asignacion, estado) FROM stdin;
3	3	20	5	2026-04-05 17:34:55.129984	asignada
4	3	19	5	2026-04-05 17:34:55.129984	asignada
\.


--
-- TOC entry 5128 (class 0 OID 16602)
-- Dependencies: 240
-- Data for Name: canjes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.canjes (id, alumno_id, recompensa_id, puntos_gastados, fecha_canje) FROM stdin;
\.


--
-- TOC entry 5136 (class 0 OID 16684)
-- Dependencies: 248
-- Data for Name: cuestionarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuestionarios (id, docente_id, lectura_id, titulo, estado, creado_en) FROM stdin;
\.


--
-- TOC entry 5140 (class 0 OID 16710)
-- Dependencies: 252
-- Data for Name: cuestionarios_asignados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuestionarios_asignados (id, cuestionario_id, curso_id, fecha_envio, activo) FROM stdin;
\.


--
-- TOC entry 5106 (class 0 OID 16413)
-- Dependencies: 218
-- Data for Name: cursos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cursos (id, nombre, nivel, anio, docente_id) FROM stdin;
1	3° Básico A	Básica	2026	6
2	4° Básico A	Básica	2026	\N
3	4° Básico B	Básica	2026	14
4	4° Básico C	Básica	2026	15
5	5° Básico A	Básica	2026	16
\.


--
-- TOC entry 5130 (class 0 OID 16620)
-- Dependencies: 242
-- Data for Name: eventos_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eventos_log (id, usuario_id, tipo_evento, detalle, fecha_hora) FROM stdin;
1	\N	mantenimiento	Mantenimiento del sistema programado para el 15/03	2026-03-29 01:42:52.393134
2	\N	registro	Nuevo usuario registrado: María González	2026-03-29 01:42:52.393134
3	\N	seguridad	Error en el correo electrónico de restablecimiento de contraseña para usuario@ejemplo.com	2026-03-29 01:42:52.393134
6	\N	actualizacion_usuario	Administrador actualizó usuario: juana morales	2026-03-29 18:08:46.496589
7	\N	eliminacion_usuario	Administrador eliminó usuario: juana morales	2026-03-29 18:09:04.04768
8	\N	eliminacion_usuario	Administrador eliminó usuario: Juana DeArco	2026-03-29 18:13:25.86022
4	\N	registro	Nuevo usuario registrado: segundo lizama	2026-03-29 17:53:00.90718
5	\N	error_password	Error de contraseña para usuario tio@gmail.com	2026-03-29 17:53:37.924525
9	\N	eliminacion_usuario	Administrador eliminó usuario: segundo lizama	2026-03-29 18:54:03.980354
10	\N	eliminacion_usuario	Administrador eliminó usuario: sasasas sasasasass	2026-03-29 18:55:16.213685
11	\N	error_login	Intento fallido de login con correo: cony@gmail.com	2026-03-29 19:04:17.444951
12	\N	error_login	Intento fallido de login con correo: cony@gmail.com	2026-03-29 19:04:18.738638
13	\N	eliminacion_usuario	Administrador eliminó usuario: Emilio Robles	2026-03-29 19:33:42.423519
14	\N	error_login	Intento fallido de login con correo: cony@gmail.com0	2026-04-04 17:42:37.232674
15	\N	error_login	Intento fallido de login con correo: cony@gmail.com	2026-04-04 17:42:40.677302
16	\N	error_login	Intento fallido de login con correo: cony@gmail.com	2026-04-04 17:42:41.996021
17	\N	error_login	Intento fallido de login con correo: cony@gmail.com	2026-04-04 17:42:43.502158
18	\N	error_login	Intento fallido de login con correo: cony@gmail.com	2026-04-04 17:42:44.852692
19	6	actualizacion_usuario	Administrador actualizó usuario: Manuel Garcia	2026-04-04 19:43:02.144638
20	6	actualizacion_usuario	Administrador actualizó usuario: Manuel Garcia	2026-04-04 20:10:56.563551
21	9	actualizacion_usuario	Administrador actualizó usuario: Lady Pino	2026-04-04 23:25:06.221423
22	14	registro	Nuevo usuario registrado: Adrian Morales	2026-04-05 00:02:29.485679
23	15	registro	Nuevo usuario registrado: Andres Mendez	2026-04-05 00:07:53.71378
24	14	actualizacion_usuario	Administrador actualizó usuario: Adrian Morales	2026-04-05 00:16:26.544103
25	15	actualizacion_usuario	Administrador actualizó usuario: Andres Mendez	2026-04-05 00:17:54.739664
26	16	registro	Nuevo usuario registrado: Juanita Perez	2026-04-05 00:19:05.999396
27	16	actualizacion_usuario	Administrador actualizó usuario: Juanita Perez	2026-04-05 00:19:51.249844
28	16	registro_alumno_pendiente	Docente agregó alumno pendiente Mario Meneses al curso 5° Básico A	2026-04-05 01:37:57.852189
29	17	registro	Nuevo usuario registrado: Mario Meneses	2026-04-05 01:38:46.572325
30	17	actualizacion_usuario	Administrador actualizó usuario: Mario Meneses	2026-04-05 01:40:40.095566
31	16	registro_alumno_pendiente	Docente agregó alumno pendiente Francisco Lizama al curso 5° Básico A	2026-04-05 01:47:29.745973
32	18	registro	Nuevo usuario registrado: Francisco Lizama	2026-04-05 01:47:59.611131
33	16	registro_alumno_pendiente	Docente agregó alumno pendiente Francisco Lizama al curso 5° Básico A	2026-04-05 01:48:57.417663
34	16	registro_alumno_pendiente	Docente agregó alumno pendiente Mario Huechumil al curso 5° Básico A	2026-04-05 01:57:38.064942
35	16	registro_alumno_pendiente	Docente agregó alumno pendiente Lady Pino al curso 5° Básico A	2026-04-05 01:58:09.293023
36	19	registro	Nuevo usuario registrado: Lady Pino	2026-04-05 01:58:26.684598
37	16	actualizacion_alumno_curso	Docente actualizó alumno Lady Natalie Pino Ramirez del curso 5° Básico A	2026-04-05 02:16:50.008078
38	16	eliminacion_alumno_pendiente	Docente eliminó alumno pendiente 4 del curso 5° Básico A	2026-04-05 02:16:56.711261
39	16	eliminacion_alumno_pendiente	Docente eliminó alumno pendiente 2 del curso 5° Básico A	2026-04-05 02:16:58.677825
40	16	eliminacion_alumno_pendiente	Docente eliminó alumno pendiente 3 del curso 5° Básico A	2026-04-05 02:17:00.82964
41	16	eliminacion_alumno_pendiente	Docente eliminó alumno pendiente 1 del curso 5° Básico A	2026-04-05 02:17:03.125343
42	16	registro_alumno_pendiente	Docente agregó alumno pendiente Elsa Del Carmen Lopez al curso 5° Básico A	2026-04-05 02:18:01.37339
43	20	registro	Nuevo usuario registrado: Elsa Del Carmen Lopez	2026-04-05 02:21:31.563944
44	16	registro_alumno_pendiente	Docente agregó alumno pendiente Mario Meneses al curso 5° Básico A	2026-04-05 02:41:30.057263
45	16	actualizacion_alumno_pendiente	Docente actualizó alumno pendiente Mario Meneses del curso 5° Básico A	2026-04-05 02:49:33.581923
46	16	actualizacion_alumno_pendiente	Docente actualizó alumno pendiente Mario Meneses del curso 5° Básico A	2026-04-05 02:49:38.987422
47	16	eliminacion_alumno_pendiente	Docente eliminó alumno pendiente 7 del curso 5° Básico A	2026-04-05 02:49:49.427211
48	16	actualizacion_alumno_curso	Docente actualizó alumno Elsa Del Carmen Lopez Lizama del curso 5° Básico A	2026-04-05 02:50:03.302576
49	16	creacion_lectura_curso	Docente creó la lectura "Las aventuras de Pinocho" y la asignó al curso 5° Básico A	2026-04-05 17:27:47.400063
50	16	actualizacion_lectura	Docente actualizó la lectura "Las aventuras de Pinocho"	2026-04-05 17:30:38.198809
51	16	actualizacion_lectura	Docente actualizó la lectura "Las aventuras de Pinocho"	2026-04-05 17:30:49.692301
52	16	actualizacion_lectura	Docente actualizó la lectura "Las aventuras de Pinocho"	2026-04-05 17:33:34.994808
53	16	eliminacion_lectura	Docente eliminó la lectura "Las aventuras de Pinocho"	2026-04-05 17:34:45.746798
54	16	creacion_lectura_curso	Docente creó la lectura "Las aventuras de Pinocho" y la asignó al curso 5° Básico A	2026-04-05 17:34:55.129984
55	16	actualizacion_lectura	Docente actualizó la lectura "Las aventuras de Pinocho"	2026-04-05 19:43:17.691531
56	16	actualizacion_usuario	Administrador actualizó usuario: Juanita Perez	2026-04-05 20:21:02.042672
57	\N	error_login	Intento fallido de login con correo: c@gmail.com	2026-04-05 20:21:23.406876
58	\N	error_login	Intento fallido de login con correo: c@gmail.com	2026-04-05 22:42:35.877316
59	\N	error_login	Intento fallido de login con correo: c@gmail.com	2026-04-05 22:42:40.754356
\.


--
-- TOC entry 5118 (class 0 OID 16514)
-- Dependencies: 230
-- Data for Name: intentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intentos (id, alumno_id, lectura_id, puntaje, aprobado, duracion_seg, creado_en, cuestionario_id) FROM stdin;
3	2	1	100.00	t	\N	2026-03-28 16:59:05.35043	\N
4	2	1	100.00	t	\N	2026-03-28 17:28:00.555714	\N
5	3	1	100.00	t	\N	2026-03-28 17:51:49.487694	\N
7	3	1	100.00	t	\N	2026-03-28 21:58:10.462006	\N
8	3	1	100.00	t	\N	2026-03-28 22:02:44.381616	\N
9	3	1	100.00	t	\N	2026-03-28 22:05:25.444274	\N
10	10	1	100.00	t	\N	2026-03-29 00:33:51.02574	\N
11	3	1	100.00	t	\N	2026-04-05 16:36:04.44557	\N
12	19	3	100.00	t	\N	2026-04-05 20:18:46.070933	\N
\.


--
-- TOC entry 5110 (class 0 OID 16446)
-- Dependencies: 222
-- Data for Name: lecturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lecturas (id, titulo, autor, nivel_dificultad, contenido, creado_por, creado_en, categoria) FROM stdin;
1	El Principito	Antoine de Saint-Exupéry	bajo	Texto de prueba...	2	2026-03-28 16:47:06.483564	\N
3	Las aventuras de Pinocho	Carlo Collodi (Escritor), Enrico Mazzanti (Ilustrador), José Sánchez López (Traductor)	Fácil	LAS AVENTURAS\nDE PINOCHO\nHistoria de una marioneta\nCarlo Collodi\nTRADUCCIÓN DE\nFREDY ORDÓÑEZ\nACIÓN\nCIRCULA\nlibro al\nviento\nGRATUITA\nlibro al\nviento\nUNA CAMPAÑA DE FOMENTO\nA LA LECTURA DE LA SECRETARÍA\nDE CULTURA RECREACIÓN Y DEPORTE\nY EL INSTITUTO DISTRITAL\nDE LAS ARTES - IDARTES\nCIRCULACIÓN\nlibro al\nviento\nGRATUITA\nLAS AVENTURAS\nDE PINOCHO\nHistoria de una marioneta\nCarlo Collodi\nTRADUCCIÓN DE\nFREDY OrDóÑezZ\nALCALDÍA MAYOR DE BOGOTÁ\nGUSTAVO PETRO URREGO, Alcalde Mayor de Bogotá\nSECRETARÍA DISTRITAL DE CULTURA, RECREACIÓN Y DEPORTE\nClarisa Ruiz Correal, Secretaria de Cultura, Recreación y Deporte\nINSTITUTO DISTRITAL DE LAS ARTES – IDARTES\nSantiago Trujillo Escobar, Director General\nBertha Quintero Medina, Subdirectora de Artes\nJulián David Correa Restrepo, Gerente (e) del Área de Literatura\nValentín Ortiz Díaz, Asesor\nPaola Cárdenas Jaramillo, Coordinadora de Programas de Lectura\nJavier Rojas Forero, Asesor administrativo\nLaura Acero Polanía, Asistente de dimensión\nSECRETARÍA DE EDUCACIÓN DEL DISTRITO\nÓSCAR SÁNCHEZ JARAMILLO, Secretario de Educación\nNOHORA PATRICIA BURITICÁ CÉSPEDES, Subsecretaria de Calidad y Pertinencia\nJOSÉ MIGUEL VILLARREAL BARÓN, Director de Educación Preescolar y Básica\nSARA CLEMENCIA HERNÁNDEZ JIMÉNEZ, LUZ ÁNGELA CAMPOS VARGAS, CARMEN CECILIA GONZÁLEZ CRISTANCHO, Equipo de Lectura,\nEscritura y Oralidad\nTítulo original: Le avventure di Pinocchio, Carlo Collodi\nPrimera edición: Bogotá, noviembre de 2012\n© de esta edición Instituto Distrital de las Artes – IDARTES\n© Fredy Ordónez, por la traducción, 2012\nIlustraciones: Enrico Mazzanti, Florencia, 1883; Carlo Chiostri, Florencia, 1902.\nTodos los derechos reservados. Esta obra no puede ser reproducida, parcial o totalmente, por ningún medio de reproducción,\nsin consentimiento escrito del editor.\nwww.institutodelasartes.gov.co\nISBN 978-958-57317-9-0\nEdición: ANTONIO GARCÍA ÁNGEL\nDiseño gráfico: ÓSCAR PINTO SIABATTO\nArmada eBook: ELIBROS EDITORIAL\nCONTENIDO\nCUBIERTA\nLIBRO AL VIENTO\nPORTADA\nCRÉDITOS\nUN TAL PINOCHO\nAntonio García Ángel\nLAS AVENTURAS DE PINOCHO\nCAPÍTULO I\nCómo fue que el maestro Cereza, carpintero, encontró un pedazo de\nmadera que lloraba y reía como un niño.\nCAPÍTULO II\nEl maestro Cereza le regala el pedazo de madera a su amigo Geppetto,\nque lo acepta para fabricarse una marioneta maravillosa que sabe\nbailar, hacer esgrima y dar saltos mortales.\nCAPÍTULO III\nAl volver a casa, Geppetto comenzó de inmediato a fabricar la\nmarioneta y la llamó Pinocho. Primeras travesuras de la marioneta.\nCAPÍTULO IV\nLa historia de Pinocho con el Grillo parlante, en la que se ve cómo a\nlos niños malos les fastidia ser corregidos por quien sabe más que\nellos.\nCAPÍTULO V\nPinocho tiene hambre y busca un huevo para hacerse una tortilla, pero\nen el mejor momento la tortilla sale volando por la ventana.\nCAPÍTULO VI\nPinocho se queda dormido con los pies sobre el caldero y la mañana\nsiguiente se despierta con los pies completamente quemados.\nCAPÍTULO VII\nGeppetto vuelve a casa, rehace los pies de la marioneta y le da el\ndesayuno que el pobre hombre había traído para él.\nCAPÍTULO VIII\nGeppetto le rehace los pies a Pinocho y vende su propio abrigo para\ncomprarle una cartilla.\nCAPÍTULO IX\nPinocho vende la cartilla para ir al teatro de marionetas.\nCAPÍTULO X\nLas marionetas reconocen a su hermano Pinocho y le hacen una gran\nfiesta. En el mejor momento sale la marioneta Comefuego y Pinocho\ncorre el peligro de salir mal librado.\nCAPÍTULO XI\nEl Comefuego estornuda y perdona a Pinocho, que luego salva de la\nmuerte a su amigo Arlequín.\nCAPÍTULO XII\nEl titiritero Comefuego le regala cinco monedas de oro a Pinocho,\npara que se las lleve a su padre Geppetto, y Pinocho se las deja birlar\ndela Zorra y el Gato y se va con ellos.\nCAPÍTULO XIII\nLa Hostería del Cangrejo Rojo.\nCAPÍTULO XIV\nPinocho, por no hacer caso a los buenos consejos del Grillo parlante,\nse topa con los asesinos.\nCAPÍTULO XV\nLos asesinos persiguen a Pinocho y, después de haberlo alcanzado, lo\ncuelgan en la rama de un roble gigante.\nCAPÍTULO XVI\nLa bella Niña del pelo turquesa hace recoger a la marioneta, la mete y\nmanda llamar a tres médicos para saber si está viva o muerta.\nCAPÍTULO XVII\nPinocho come azúcar, pero no quiere purgarse. Cuando ve los\nsepultureros que vienen a llevárselo, entonces resuelve purgarse.\nLuego dice una mentira y, de castigo, le crece la nariz.\nCAPÍTULO XVIII\nPinocho se encuentra de nuevo con la Zorra y el Gato y va con ellos a\nsembrar las cuatro monedas de oro en el Campo de los Milagros.\nCAPÍTULO XIX\nA Pinocho le roban sus cuatro monedas de oro y, de castigo, resulta\ncuatro meses en prisión.\nCAPÍTULO XX\nLiberado de la prisión, toma el camino de regreso a la casa del Hada.\nPero, a lo largo del camino, se encuentra con una serpiente horrible y\nluego cae en una trampa.\nCAPÍTULO XXI\nPinocho es atrapado por un campesino, que lo obliga a trabajar de\nperro guardián en un gallinero.\nCAPÍTULO XXII\nPinocho descubre a los ladrones y, en recompensa por su fidelidad, es\npuesto en libertad.\nCAPÍTULO XXIII\nPinocho llora la muerte de la hermosa Niña del pelo turquesa, luego\nencuentra un palomo que lo lleva hasta la orilla del mar y se arroja al\nagua para auxiliar a su padre Geppetto.\nCAPÍTULO XXIV\nPinocho arriba a la Isla de las Abejas Industriosas y se reencuentra\ncon el Hada.\nCAPÍTULO XXV\nPinocho promete al Hada volverse bueno y ponerse a estudiar, porque\nestá cansado de ser una marioneta y quiere convertirse en un niño de\nbien.\nCAPÍTULO XXVI\nPinocho va con sus compañeros de escuela a la orilla del mar para\nver al terrible tiburón.\nCAPÍTULO XXVII\nHay un gran combate entre Pinocho y sus compañeros, uno de los\ncuales resulta herido, razón por la que Pinocho es arrestado por los\ncarabineros.\nCAPÍTULO XXVIII\nPinocho corre el peligro de que lo friten en una sartén como un\npescado.\nCAPÍTULO XXIX\nVuelve a la casa del Hada, que le promete que a partir del día\nsiguiente dejará de ser una marioneta y se convertirá en un niño. Gran\ndesayuno para festejar este gran acontecimiento.\nCAPÍTULO XXX\nPinocho, en vez de convertirse en un niño, se escapa a escondidas con\nsu amigo hacia el País de los Juguetes.\nCAPÍTULO XXXI\nPinocho, en vez de convertirse en un niño, se va con su amigo Pabilo\nal País de los Juguetes.\nCAPÍTULO XXXII\nA Pinocho le salen orejas de burro y entonces se convierte en un burro\nde verdad y comienza a rebuznar.\nCAPÍTULO XXXIII\nConvertido en un burro de verdad, lo llevan a una venta donde lo\ncompra el director de una compañía de payasos, el cual quiere\nenseñarle a bailar y a saltar obstáculos. Pero una noche empieza a\ncojear y entonces lo compra otro para hacer con su piel un tambor.\nCAPÍTULO XXXIV\nPinocho, arrojado al mar, es devorado por los peces y vuelve a ser una\nmarioneta como antes. Pero mientras nada para salvarse, es tragado\npor un terrible tiburón.\nCAPÍTULO XXXV\nPinocho se encuentra en el cuerpo del Tiburón a… ¿A quién se\nencuentra? Lee este capítulo y lo sabrás.\nCAPÍTULO XXXVI\nFinalmente Pinocho deja de ser una marioneta y se convierte en un\nniño.\nUN TAL PINOCHO\nPinocho comparte con Sherlock Holmes, Drácula y James Bond la paradoja\nde ser conocido por todos pero leído por muy pocos. Es sin duda la\nmarioneta más famosa de la historia, pero esto se debe más a incontables\nediciones abreviadas y la película de Walt Disney que al libro original. En\nesta oportunidad, los lectores de Libro al Viento tienen en sus manos Las\naventuras de Pinocho en traducción exclusiva y texto íntegro. Estas páginas\ncontienen un relato insospechado, con resonancias absurdas y tintes del más\ndescarnado realismo, episodios de redención y crueles hundimientos,\ninestables tránsitos entre lo risueño y lo macabro, concesiones y\ntransgresiones al cuento de hadas, ambigüedades morales que caracterizan a\nPinocho y los demás personajes. Por ese filo transita la buena, la verdadera\nliteratura, aquella que describe Robert Browning en su Apología del obispo\nBlougram y que utilizó Pamuk como epígrafe de una novela: «Nos interesa\nel límite peligroso de las cosas. / El ladrón honesto, el asesino sensible, / el\nateo supersticioso».\n1. Y CON USTEDES, CARLO COLLODI\nEn ese límite peligroso también fluyó la vida de Carlo Collodi, el creador\nde Pinocho, Carlo Lorenzo Filippo Giovanni Lorenzini nació el 24 de\nnoviembre de 1826 en Florencia, Italia. Su madre era camarera y su padre\ncocinero en la casa de los Duques Ginori. La pareja tuvo nueve hijos, de los\ncuales sobrevivieron tres: el mayor, Carlo, el tercero, Paolo, nacido en\n1829, y el último, Ippolito, en 1842.\nDe niño, Carlo estudió en una de las Escuelas Pías, fundadas en 1597\npara dar una educación basada en la fe y las letras a los niños pobres y\nabandonados. A los once años ingresa en el seminario de Colle Val d’Elsa.\nA los dieciséis se sale del seminario y pasa a estudiar Retórica y Filosofía\ncon los clérigos escolapios. Un año después encuentra trabajo en la librería\nPiatti, dirigida por el paleógrafo Giuseppe Aiazzi, quien le encarga la\nredacción de un boletín bibliográfico. Con este motivo, consigue licencia\neclesiástica para leer libros prohibidos por la Iglesia y el duque Leopoldo II.\nCarlo alcanza la adultez en el decennio di preparazione, la década de\n1850 a 1860, cuando Italia se movía hacia la unificación y en contra del\ncontrol austríaco. Como tantos de su generación, en 1848 se enlista como\nvoluntario en la primera y fallida guerra de independencia. Ese mismo año\nregresa a Florencia y funda el diario satírico Il lampione, publicación de\ntendencia nacionalista cuya intención es «iluminar a quien anda en\ntinieblas». Será prohibido por el gobierno y no volverá a ver la luz hasta\n1860. En ese decenio de preparación para la independencia definitiva de\nItalia lleva una intensa actividad periodística en diferentes publicaciones,\nhaciendo crónicas teatrales, literarias y musicales, escribiendo artículos bajo\ndiferentes nombres, así como cuatro comedias y un par de libros\nhumorísticos. Se sabe también que lleva una vida sumamente desordenada;\nes un jugador furioso y desafortunado, se llena de deudas y se entrega al\nalcohol.\nEn 1859, cuando estalla la segunda guerra de independencia, se enrola de\nnuevo como voluntario, esta vez en el Regimiento de Caballería de Novara.\nA su vuelta a Florencia, luego de la paz de Villafranca, el secretario del\ngobierno provisional toscano le encarga controvertir a un tal Eugenio\nAlbèri, quien ha lanzado un escrito invitando a los toscanos a desconfiar del\nprograma unitario. Carlo Lorenzini emplea su aguda pluma en responder\ncon un opúsculo titulado ¡El señor Albèri tiene razón! Diálogo apologético,\ny en él firma con el apellido Collodi, pueblo de la Toscana donde nació su\nmadre. Desde entonces consagra el pseudónimo de Carlo Collodi, que había\nempleado por primera vez en un artículo de 1856.\nLa unificación italiana y el cambio de política le otorgan a Collodi\nnuevos y contradictorios oficios. En 1860 forma parte de la Comisión de\ncensura teatral y resucita Il lampione, que había sido censurado hacía once\naños. En el 62 figura como director escénico del teatro La Pergola. En el 64\nsu hermano Paolo, que tiene un buen puesto en la administración de la casa\nGinori, consigue que lo nombren secretario de segunda clase en la\nprefectura de Florencia. Finalmente tiene un sueldo discreto, pero eso no\nevita que siga acosado por las deudas. En 1868, cuando cuenta con 42 años,\nCollodi forma parte del grupo que debe compilar el Diccionario de la\nLengua Italiana. Allí conoce al filólogo y lexicógrafo Giuseppe Rigutini,\nquien le aconsejará dedicarse a la literatura para la infancia.\nEn 1875, Collodi traduce los cuentos de Perrault y los publica en un\nvolumen titulado Racconti delle fate. Además recibe el encargo de revisar el\nGiannetto, un libro didáctico que se utilizaba en las escuelas, escrito por\nAlessandro Luigi Parravincini cuarenta años atrás. La literatura para niños\nera una innovación del siglo xix en Italia (y en cualquier otro lugar). Para\nentonces no había distinciones estrictas entre libros para jóvenes o adultos,\npero en ese entonces el país estaba formándose como nación, encontraba\nuna identidad que requería formar valores comunes. Tras la unificación\npolítica era necesaria la unificación cultural, pues como bien dijo Leopardi:\n«Ya hicimos a Italia, ahora debemos hacer a los italianos». De ese impulso\nsaldrá Il Viaggio per l’Italia di Giannettino, algo así como El viaje por\nItalia de Juanito, que buscaba «darle a los niños una idea de su nuevo y\nglorioso país». Collodi también escribiría un texto de matemáticas y una\ngramática de Giannettino, libros que le dieron cierta fama en el ámbito de la\neducación pública. El éxito de la serie Giannettino generó otro personaje,\nprotagonista de un libro homónimo: Minuzzolo, un niño que todo el tiempo\nse burla de los intentos por enseñarle a ser bueno. Así, Giannettino es un\nantecedente del viaje como motivo central de Las aventuras de Pinocho —\nal País de los muertos, al País de los Gaznápiros, al País de las Abejas\nIndustriosas, allende el mar—, mientras Minuzzolo anticipa la\ndesobediencia, la burla a la autoridad.\nEn 1880, Ferdinando Martini, quien había trabajado junto a Collodi en la\nelaboración del diccionario de la lengua, funda el Giornale per i bambini,\npara aprovechar el nuevo mercado editorial. Martini llama a Collodi y le\npide una colaboración. El 7 de julio de 1881 sale a la calle el número 1 del\nGiornale, con los primeros capítulos de Pinocho en la página 3. En 1883 se\npublica el último capítulo. Poco después será editado en forma de libro. En\n1886 muere su madre. En ese mismo año Martini le cede la dirección del\nGiornale per i bambini. Collodi seguirá publicando recopilaciones de sus\nartículos, unos recuerdos de infancia y aún escribió La linterna mágica de\nGiannettino. Fue su último trabajo. El 26 de octubre de 1890, en la puerta\nde su casa, cayó fulminado por un aneurisma. Le faltaba un mes para\ncumplir 64 años.\n2. UNA NIÑERÍA BIEN PAGA\nLas aventuras de Pinocho fueron escritas a regañadientes. Collodi tenía ya\nel primer capítulo unos ocho o nueve meses antes de que lo contactara el\nGiornale per i bambini. Lo envió con una carta al administrador, Guido\nBiagi, que decía «Ahí te mando esta niñería, haz con ella lo que te parezca.\nPero si la publicas, págame bien, para que me den ganas de continuarla».\nBiagi la publicó y se la pagó bien, pero Collodi remoloneaba hasta la\nexasperación. En el Giornale publicaban cartas excusándose con los\npequeños lectores cada vez que salía una edición sin las aventuras de\nPinocho. Collodi escribía sin releer los capítulos anteriores, indolente ante\nlos errores argumentales o de continuidad, con evidente dejadez. Con afán\nde librarse de este libro que lo aburría, el autor concibió una estructura\ntrágica: en el capítulo final, que iba a ser el número xv, el muñeco de\nmadera muere ejecutado como castigo a sus travesuras. La Zorra y el Gato\nle amarran los brazos y lo ahorcan colgándolo del Gran Roble. Luego lo\nabandonan a su suerte « Y no tuvo aliento para decir más. Cerró los ojos,\nabrió la boca, estiró la pata y, dando una grande sacudida, se quedó como\ntieso». Al Giornale per i bambini llegan airadas cartas de protesta. Muchos\nlectores ansiosos por saber más y muchos cabos sueltos por atar. A Biagi y\nMartini les toma cuatro meses convencer a Collodi de continuar su historia.\nMás adelante el autor se tomará un respiro de seis meses sin escribir. Al\nigual que Geppetto, Collodi creó algo que había cobrado vida propia.\nCollodi, como Kafka, tenía muy poca confianza en la trascendencia de su\nobra, pero Pinocho ha sido traducido a cientos de lenguas, incluida una\nmuerta como el latín. Tolstoi escribió una versión rusa llamada Las\naventuras de Buratino. De él se han ocupado Benedetto Croce, Julián\nMarías, Italo Calvino, Alberto Manguel y Paul Auster. Las adaptaciones\ncinematográficas se cuentan por decenas, entre ellas la de Walt Disney y la\nde Roberto Begnini, además de rarezas como La venganza de Pinocho y\nPinocho en el espacio sideral, para no mencionar la deuda que tienen el\nEdward Scissorhands de Tim Burton y la Inteligencia Artificial de\nSpielberg-Kubrick con esta marioneta viviente. Por si fuera poco, Pinocho\nha propiciado una avalancha iconográfica y de mercadeo que incluye\nafiches, postales, calendarios, muñecos de todos los materiales,\ncomposiciones musicales, obras de teatro, rompecabezas, juegos de mesa,\nun parque temático y algunas obras de arte moderno. «En la historia de las\nreligiones pop», dice Umberto Eco, «creo que tan solo el Ratón Mickey ha\nsobrepasado este éxito».\nPese al poco afecto que prodigó Collodi a su creatura y la pereza que\ntenía de escribirla, el resultado va más allá de la fábula ejemplar y el simple\ncuento de hadas. Las primeras líneas ya plantean la transgresión a las leyes\ndel género, pues comienza con la típica frase «Había una vez…» pero a\ncontinuación el narrador aclara que no se trata de un rey sino de un pedazo\nde madera parlante. A propósito, entre las muchas preguntas que desata\nPinocho es si su personalidad se forma a medida que Geppetto trabaja la\nmadera y la convierte en marioneta. Ese mismo trozo de madera pudo\ndesarrollar otra psiquis al tallarlo como un animal o un santo.\nAunque pretende dar un mensaje moralizante, Las aventuras de Pinocho\nno pueden escapar de las contradicciones: Geppetto es un tierno viejecito,\npero sus vecinos dicen que «es un verdadero tirano con los niños»; el\ntitiritero Comefuego se apiada de Pinocho y, generoso, le entrega cinco\nmonedas de oro, pero a cambio decide quemar en la hoguera al Arlequín; el\nHada del pelo turquesa es buena, pero tortura a Pinocho haciéndole creer\nque ella ha muerto por su culpa; en el País de los Gaznápiros lo encierran en\nla cárcel por bueno e ingenuo. El mismo protagonista es tachado de\n«bobalicón», «pequeño granuja», «malvado», «travieso», «bribón»,\n«bribonzuelo», «asquiento», «melindroso», «pillo», «pilluelo»,\n«sinvergüenza», «vagabundo» y «marioneta bellaca»; su deseo es\nconvertirse en un niño de carne y hueso, pero no es tan claro qué beneficio\ntraiga ello cuando todos los niños que aparecen en el cuento son\ntraicioneros, imbéciles, desobedientes, avaros y sucios.\nRebbeca West, en el epílogo a la edición de New York Review of Books\ndice que el libro trata del «enfrentamiento entre la conformidad colectiva y\nla creatividad individual». Una y otra vez, Pinocho se dejará llevar por sus\ninstintos y terminará recibiendo duras reprimendas. El personaje no sólo es\nahorcado sino robado, apuñalado, secuestrado, azotado con látigo, golpeado\nen la cabeza, encadenado como un perro; además en una ocasión sus\npiernas se queman y en otra por poco termina frito en una sartén. Cabe\nrecalcar que Pinocho, por su parte, mata al grillo parlante cuando éste lo\nestá sermoneando, le arranca una zarpa al Gato de un mordisco y ve\nagonizar a su amigo Pabilo. El libro de Collodi está en las antípodas de la\nedulcorada y sosa versión que en 1940 hizo Disney, con una marioneta\ningenua y despistada, personaje amigable que no despierta ningún recelo ni\nse enfrenta a los calvarios del original. Ni mata a Pepegrillo. Frente al\nPinocho de Disney sólo queda maravillarse ante los recursos técnicos y la\npuesta en escena, pero el de Collodi esconde múltiples interpretaciones,\ndesde la alegoría bíblica hasta las reflexiones sobre la post-humanidad,\ndesde las lecturas psicoanalíticas hasta los enfoques políticos y\nantropológicos. Incluso existe un estudio de lógica sobre la Paradoja de\nPinocho: si Pinocho dijera «Mi nariz está creciendo» sería falso, y por tanto\nle crecería la nariz, pero si le crece dejaría de ser falso, entonces dejaría de\ncrecerle, pero al no crecerle volvería a ser falso el enunciado, y así, ad\ninfinitum.\nDespués de tanta prosa gótica sobre Pinocho, se hace necesario recordar\nque el texto está salpicado de humor negro, juegos de palabras, diálogos\nabsurdos —«¿Qué lo trae por acá?», «Las piernas»— y escenas\nmemorables, como los cuatro conejos de las pompas fúnebres, el caracol\ngigante que se demora nueve horas en bajar cuatro pisos, la serpiente que\nliteralmente se muere de risa, la transformación en burro, el pescador que\nen vez de pelo tiene hierba en la cabeza y el tiburón gigante, para enumerar\nalgunos ejemplos de esa imaginería que emparenta al libro de Collodi con\nlos paisajes y escenas de Lewis Carroll, y también con la Commedia\ndell’arte y la novela de aventuras.\nEsa niñería que Collodi no quería escribir ya tiene 130 años, sus\nmisterios aún no han sido revelados por completo y su encanto prevalece\nentre los lectores de todas las edades.\nNos complace inaugurar nuestra colección Inicial de Libro al Viento,\ndirigida al público infantil, con este clásico de todos los tiempos. Así como\nla extensión de Pinocho no fue un obstáculo para los niños de su época,\nesperamos que tampoco lo sea en los tiempos que corren. Pensamos que los\npadres podrán leer cada día una parte de este libro a sus hijos, y así\nreproducir el mismo esquema de literatura por entregas con el que fue\nconcebido. Tendrán la oportunidad de pasar buenos ratos enfrente de estas\npáginas. La diversión, sin duda, está garantizada.\nANTONIO GARCÍA ÁNGEL\nLAS AVENTURAS\nDE PINOCHO\nHistoria de una marioneta\nCarlo Collodi\nhpFirenze\nI\nCómo fue que el maestro Cereza, carpintero, encontró un pedazo de madera que\nlloraba y reía como un niño.\nHabía una vez…\n—¡Un rey! —dirán de inmediato mis pequeños lectores.\nNo, niños, están equivocados. Había una vez un pedazo de madera.\nNo era una madera de lujo, sino un simple pedazo de leña, de esos que\ndurante el invierno se meten en las estufas y en las chimeneas para encender\nel fuego y calentar las habitaciones.\nNo sé cómo sucedió, pero el hecho fue que un buen día este pedazo de\nmadera apareció en la tienda de un viejo carpintero cuyo nombre era\nAntonio, pero a quien todos llamaban maestro Cereza, porque la punta de\nsu nariz siempre estaba lustrosa y rojiza como una cereza madura.\nApenas el maestro Cereza vio ese pedazo de leño, se emocionó y,\nfrotándose las manos de la felicidad, murmuró a media voz:\n—Este pedazo de madera apareció justo a tiempo: quiero hacer con él la\npata de una mesa.\nDicho esto, tomó entre sus manos un hacha afilada y comenzó a pulirlo y\na desbastarlo; pero en el momento en que iba a dar el primer hachazo, se\nquedó con el hacha suspendida en el aire, porque oyó el hilo de una voz que\nle rogaba:\n—¡No me vaya a golpear muy fuerte!\nAnte esta petición, imagínense cómo quedó el buen hombre del maestro\nCereza.\nRepasó con la mirada toda la habitación tratando de descubrir de dónde\nhabía salido esa voz, y no vio a nadie; buscó debajo de la silla, y nada;\nbuscó dentro del armario que siempre estaba cerrado, y nada; buscó entre la\nviruta y el serrín, y nada; abrió la puerta de la tienda para echar una mirada\na la calle, y nada. ¿Será que…?\n—¡Claro! —dijo entonces riendo y rascándose la peluca—. Me he\nimaginado la voz. Retomemos el trabajo.\nVolvió a blandir el hacha y encajó un poderosísimo golpe sobre el pedazo\nde madera.\n—¡Ay, me has hecho daño! —gritó lamentándose la misma vocecita.\nEsta vez el maestro Cereza se quedó de una pieza, con los ojos\ndesorbitados por el miedo, la boca abierta y la lengua que le colgaba hasta\nel mentón, como el mascarón de una fuente.\nApenas pudo volver a hablar, y temblando del miedo, balbuceó:\n—¿Pero de dónde habrá salido esta vocecita que ha dicho ay?… Aquí no\nhay ningún alma. ¿Será acaso que este pedazo de madera aprendió a llorar y\na quejarse como un niño? No lo puedo creer. Este leño acá… es un pedazo\nde leña para la chimenea, como todos los demás, capaz de calentar, si se\narroja al fuego, una olla de fríjoles… ¿O será que…? ¿Hay alguien\nescondido dentro? Si hay alguien escondido, tanto peor por él. ¡Ya lo pongo\nen su lugar!\nY diciendo así tomó firmemente entre sus manos este pobre pedazo de\nleño y comenzó a golpear con él las paredes de la habitación.\nLuego se puso a escuchar, a ver si oía alguna vocecita lamentarse. Espero\ndos minutos, y nada; cinco minutos, y nada; diez minutos, y nada.\n—Ya entiendo —dijo entonces esforzándose por reír y acomodándose la\npeluca—. Esa vocecita que ha dicho ay me la he inventado yo. ¡Volvamos\nal trabajo!\nY como había experimentado un gran miedo, intentó ponerse a canturrear\npara darse un poco de ánimo.\nPor el momento, dejó el hacha a un lado, cogió el cepillo para pulir el\npedazo de madera y, a medida que pulía de arriba abajo, oyó la misma\nvocecita que le decía riendo:\n—¡Déjame! ¡Me haces cosquillas por todo el cuerpo!\nEsta vez el pobre maestro Cereza cayó como fulminado. Cuando volvió a\nabrir los ojos, estaba sentado sobre el piso.\nParecía trastornado e incluso la punta de la nariz, que era tan rojiza\nsiempre, se le puso blanca del susto tan terrible.\nII\nEl maestro Cereza le regala el pedazo de madera a su amigo Geppetto, que lo\nacepta para fabricarse una marioneta maravillosa que sabe bailar, hacer\nesgrima y dar saltos mortales.\nEn ese momento alguien tocó a la puerta.\n—Pase, pase —dijo el carpintero, aún sin fuerzas para ponerse en pie.\nEntonces entró en la tienda un viejo vivaz cuyo nombre era Geppetto;\npero los muchachos del barrio, porque les gustaba verlo rabiar, lo llamaban\ncon el apodo de Papillita, pues su peluca amarilla guardaba una gran\nsemejanza a una papilla de maíz.\nGeppetto estaba furiosísimo. ¡Ay del que lo llamara Papillita! Se volvía\nuna fiera y no había modo de calmarlo.\n—Buen día, maestro Antonio —dijo Geppetto—. ¿Qué hace ahí tirado en\nel piso?\n—Les enseño a las hormigas a contar.\n—Que le aproveche.\n—¿Y qué lo ha traído hasta acá?\n—¡Las piernas!… Usted sabe, maestro Antonio, que he venido a pedirle\nun favor.\n—Aquí estoy, para servirle —respondió el carpintero levantándose.\n—Esta mañana se me ha ocurrido una idea.\n—¿Cuál sería?\n—He pensado en fabricarme una linda marioneta de madera, pero una\nmarioneta maravillosa, que sepa bailar, hacer esgrima y dar saltos mortales.\nCon esta marioneta quiero darle la vuelta al mundo, y ganarme así un\npedazo de pan y un vaso de vino. ¿Qué le parece?\n—¡Felicitaciones, Papillita! —gritó la misma vocecita, desde quién sabe\ndónde.\nAl oír que lo llamaban Papillita, el compadre Geppetto se puso rojo como\nun pimentón de la rabia y, dándose vuelta hacia el carpintero, le dijo\nenfurecido:\n—¿Por qué me ofende?\n—¿Quién lo ofendió?\n—Me acaba de llamar Papillita.\n—¿Yo? Yo no he dicho nada.\n—¡Entonces fui yo!… Claro que fue usted.\n—¡No!\n—¡Sí!\n—¡No!\n—¡Sí!\nY calentándose cada vez más, pasaron de las palabras a los hechos y,\nagarrándose, se mordieron y se zarandearon el uno al otro.\nCuando dejaron de pelear, el maestro Antonio tenía en sus manos la\npeluca amarilla de Geppetto y Geppetto la peluca entrecana del carpintero.\n—¡Devuélveme mi peluca! —gritó el maestro Antonio.\n—Y tú devuélveme la mía y hagamos las paces.\nLos dos viejitos, después de haber recuperado cada uno su peluca, se\nestrecharon las manos y juraron ser buenos amigos toda la vida.\n—Entonces, compadre Geppetto —dijo el carpintero en señal de paz—,\n¿cuál es el favor que me venía a pedir?\n—Quisiera un poco de madera para fabricar mi marioneta. ¿Me la puede\ndar?\nEl maestro Antonio, todo contento, fue de inmediato a tomar del\nmostrador ese pedazo de madera que le había causado tanto pavor. Pero\ncuando fue allí para entregárselo a su amigo, el palo se sacudió y,\nescapándosele bruscamente de las manos, fue a estrellarse con fuerza contra\nlas frágiles tibias del pobre Geppetto.\n—¡Ah! ¿Pero es con estos modales, maestro Antonio, que usted regala\nsus cosas? ¡Casi me deja cojo!\n—¡Le juro que no fui yo!\n—¡Entonces habré sido yo!\n—Toda la culpa es de este palo.\n—Claro que sé que es de este palo: pero fue usted el que me lo tiró sobre\nlas piernas.\n—¡Yo no se lo tiré!\n—¡Mentiroso!\n—Geppetto, no me ofenda; si no, lo llamo Papillita.\n—¡Asno!\n—¡Papillita!\n—¡Burro!\n—¡Papillita!\n—¡Bestia horrible!\n—¡Papillita!\nAl oír que lo llamaban Papillita por tercera vez, Geppetto perdió la\ncompostura, se lanzó sobre el carpintero y se dieron una tremenda paliza.\nCuando se acabó la batalla, el maestro Antonio tenía dos arañazos en la\nnariz y el otro, dos botones menos en el chaleco. Empatadas las cuentas, se\nestrecharon las manos y juraron ser amigos para toda la vida.\nGeppetto tomó entonces su gran pedazo de madera y, tras agradecerle al\nmaestro Antonio, se volvió cojeando a su casa.\nIII\nAl volver a casa, Geppetto comenzó de inmediato a fabricar la marioneta y la\nllamó Pinocho. Primeras travesuras de la marioneta.\nLa casa de Geppetto era un cuartico en un primer piso, debajo de una\nescalera, al que le llegaba poca luz. El mobiliario no podía ser más austero:\nuna burda silla, una cama regular y una mesita a punto de caerse. En la\npared del fondo se veía una chimenea con el fuego encendido; pero el fuego\nestaba pintado y, junto al fuego, había dibujada una olla que hervía\nalegremente y arrojaba una nube de humo que parecía humo de verdad.\nApenas entró a la casa, Geppetto tomó sus herramientas y se puso a tallar\ny a hacer su marioneta.\n«¿Qué nombre le pondré? —se preguntó—. Quiero llamarla Pinocho.\nEste nombre le traerá fortuna. Conocí una familia entera de Pinochos:\nPinocho el padre, la madre y los hijos, y todos la pasaban bien. El más rico\nde ellos vivía de pedir limosna».\nCuando encontró el nombre de su marioneta, comenzó a trabajar en\nforma y le hizo el pelo, luego la frente y finalmente los ojos.\nImagínense su sorpresa cuando, luego de concluir los ojos, se dio cuenta\nde que se movían y lo miraban fijamente.\nGeppetto, viendo cómo lo veían esos dos ojos de madera, casi se lo toma\na mal y dijo con tono desapacible:\n—Ojos de madera, ¿por qué miran así?\nNadie respondió.\nLuego de los ojos, hizo la nariz; pero la nariz, apenas hecha, comenzó a\ncrecer, y creció y creció, hasta convertirse en poco tiempo en una narizota\nde nunca acabar.\nEl pobre Geppetto se esforzaba en recortarla, pero cuanto más la\nrecortaba y reducía, más larga se volvía esa nariz impertinente.\nDespués de la nariz hizo la boca.\nNo había acabado de hacer la nariz, y ya comenzaba a reírse y a burlarse.\n—¡Deja de reírte! —dijo Geppetto molesto; pero fue como hablar con\nuna pared—. ¡Deja de reírte, te repito! —le gritó amenazante.\nEntonces la boca dejó de reírse, pero sacó toda la lengua.\nGeppetto, para no arruinar lo que había hecho, fingió no haberse dado\ncuenta y siguió trabajando. Después de la boca, le hizo el mentón, luego el\ncuello, la espalda, la barriga, los brazos y las manos.\nApenas terminó las manos, Geppetto sintió que desaparecía su peluca.\nMiró hacia arriba y… ¿qué vio? Vio la peluca amarilla en la mano de la\nmarioneta.\n—¡Pinocho!… Dame ya mi peluca.\nY Pinocho, en vez de devolverle la peluca, se la puso en la cabeza, lo que\nlo hizo sentir un poco ahogado.\nLuego de ese insolente gesto, Geppetto se puso triste y melancólico como\nnunca había estado en la vida y, volviéndose hacia Pinocho, le dijo:\n—¡Pequeño granuja, no te he acabado de fabricar aún y ya le comienzas\na faltar el respeto a tu padre! ¡Mal, jovencito, muy mal!\nY se secó una lágrima.\nFaltaban por hacer las piernas y los pies.\nCuando Geppetto terminó de hacer los pies, sintió una patada en la punta\nde la nariz.\n«Me la merezco —dijo entonces para sí—. Debí pensarlo antes; ahora es\ntarde».\nTomó entonces a la marioneta bajo el brazo y la puso sobre el suelo de la\nhabitación, para que caminara.\nPinocho tenía las piernas entumecidas y no sabía moverse y Geppetto lo\nllevaba de la mano para enseñarle a dar un paso tras otro.\nCuando las piernas se le desentumecieron, Pinocho comenzó a caminar\npor sí mismo y a correr por la habitación; hasta que, tras enfilar hacia la\npuerta de la casa, saltó a la calle y escapó.\nY el pobre Geppetto se puso a correr detrás de él sin poderlo alcanzar,\nporque el travieso de Pinocho andaba a saltos como una liebre y, golpeando\nsus pies de madera sobre el empedrado de la calle, hacía un escándalo como\nde veinte pares de zuecos campesinos.\n—¡Agárrenlo, agárrenlo! —gritaba Geppetto, pero la gente que iba por la\ncalle, viendo que corría como un bárbaro, se detenía encantada a mirarlo y\nse reía a más no poder.\nAl final, y por suerte, apareció un carabinero, que, oyendo todo ese\nalboroto y creyendo que se trataba de un potro que se hubiera rebelado\ncontra su dueño, se plantó valientemente en mitad de la calle, con el firme\npropósito de detenerlo y de impedir mayores desgracias.\nPero Pinocho, cuando avistó a lo lejos al carabinero que le impedía el\npaso, se le ocurrió pasar entre las piernas, pero fracasó.\nEl carabinero, sin moverse un ápice, lo agarró de la nariz (era una nariz\ndesproporcionada, que parecía hecha aposta para ser agarrada por\ncarabineros) y se lo devolvió a Geppetto en las manos, quien, con el\npropósito de corregirlo, quiso darle un buen jalón de orejas. Pero\nimagínense cómo quedó cuando, al buscar las orejas, no las pudo encontrar.\n¿Y saben por qué? Porque, en el afán de tallarlo, se había olvidado de\nhacerlas.\nEntonces lo tomó por el pescuezo y, mientras lo llevaba de vuelta, le dijo\namenazadoramente poniéndole un dedo en la cabeza:\n—Vamos rápido a casa. ¡En cuanto lleguemos, vamos a arreglar cuentas!\nPinocho, tras esta cantilena, se tiró al suelo y no quiso caminar más.\nEntre tanto, los curiosos y los vagos comenzaron a rodearlos y a hacer\ncorrillo.\nUnos y otros murmuraban.\n—Pobre marioneta —decían algunos—, tiene razón de no volver a casa.\n¡Quién sabe cómo lo maltratará ese tipejo de Geppetto!\nY los demás asentían maliciosamente.\n—Ese Geppetto parece un caballero, pero es un verdadero tirano con los\nniños. Si le dejamos esa pobre marioneta entre las manos, es capaz de\nhacerla pedazos.\nEn resumen, tanto dijeron y tanto hicieron, que el carabinero puso en\nlibertad a Pinocho y condujo a la cárcel al pobre de Geppetto. Este, no\nteniendo palabras para defenderse, lloraba como un ternerito y, camino de la\nprisión, balbuceaba sollozando:\n—¡Malvado hijo! ¡Y pensar que he penado tanto por hacerlo una\nmarioneta de bien! Pero es mi culpa: debí pensarlo antes.\nLo que sucedió después fue una historia de no creer y se las contaré en\nlos siguientes capítulos.\nIV\nLa historia de Pinocho con el Grillo parlante, en la que se ve cómo a los niños\nmalos les fastidia ser corregidos por quien sabe más que ellos.\nLes diré, entonces, niños, que mientras el inocente Geppetto era conducido\na la prisión, aquel travieso de Pinocho, al quedar libre por el carabinero, se\nfue a zancadas por entre los campos, para llegar más pronto a casa. Y era\ntanto su afán que saltaba arbustos altísimos, setos de ciruelas y fosos llenos\nde agua, tal cual como lo haría un cabrito o una liebre perseguida por unos\ncazadores.\nAl llegar al frente de la casa, encontró la puerta entreabierta. La empujó,\nentró y, apenas pudo poner cerrojo, se echó en el suelo, dejando escapar un\ngran suspiro de satisfacción.\nPero la dicha le duró poco, porque oyó en la habitación a alguien que\nhizo:\n—Cri-cri-cri.\n—¿Quién me llama? —dijo Pinocho asustado.\n—Yo.\nPinocho se volteó y vio un enorme Grillo que subía lentamente por el\nmuro.\n—Dime, Grillo, ¿y tú quién eres?\n—Yo soy el Grillo parlante y vivo en esta habitación hace más de cien\naños.\n—Pero esta habitación me pertenece —dijo la marioneta— y, si me\npuedes hacer el favor, quiero que te vayas inmediatamente.\n—No me voy a ir de acá —respondió el Grillo— antes de decirte una\nverdad.\n—Vete, esfúmate.\n—¡Ay de esos muchachos que se rebelan contra sus padres y abandonan\ncaprichosamente la casa paterna. Así nunca les irá bien en este mundo y,\ntarde o temprano, se arrepentirán por esto amargamente.\n—Di lo que quieras, Grillo mío, haz lo que te plazca. Pero yo mañana\ntemprano me voy de aquí, porque, si me quedo, me sucederá lo que les\nsucede a todos los niños, y me mandarán a la escuela y, a las buenas o a las\nmalas, me tocará estudiar. Y yo, para ser sincero, de estudiar no tengo\nganas. Me divierte más correr detrás de las mariposas y subir a los árboles a\ntomar los nidos de los pájaros.\n—¡Pobre bribonzuelo! ¿Es que no sabes que, actuando así, de grande te\nconvertirás en un soberano burro y que todos se burlarán de ti?\n—¡Quítate, Grillo de mal augurio! —gritó Pinocho.\nPero el Grillo, que era paciente y filósofo, en vez de tomarse a mal esta\nimpertinencia, siguió con el mismo tono de voz:\n—Y si no te da la gana de ir a la escuela, ¿por qué no aprendes al menos\nun oficio, para ganarte honradamente un pedazo de pan?\n—¿Quieres que te lo diga? —replicó Pinocho, que comenzaba a perder la\npaciencia—. Entre todos los oficios del mundo, solo hay uno que de verdad\nme gusta.\n—¿Y cuál es?\n—El de comer, beber, dormir, divertirme y vagabundear de la mañana a\nla noche.\n—Para tu información —dijo el Grillo parlante con su habitual calma—,\ntodos los que se dedican a hacer eso casi siempre terminan en un hospital o\nuna prisión.\n—Cuidado, Grillo de mal augurio… Hazme enojar, y te va a ir mal.\n—Pobre Pinocho, me das lástima.\n—¿Por qué te doy lástima?\n—Porque eres una marioneta y, sea lo que sea, tienes la cabeza de palo.\nDichas estas últimas palabras, Pinocho saltó enfurecido y, agarrando del\nmostrador un martillo de madera, lo lanzó contra el Grillo parlante.\nQuizás no contaba con darle, pero desgraciadamente le dio, y por la\ncabeza, tanto que el pobre Grillo apenas tuvo el aliento para decir cri-cri-cri\ny quedar estampado contra la pared.\nV\nPinocho tiene hambre y busca un huevo para hacerse una tortilla, pero en el\nmejor momento la tortilla sale volando por la ventana.\nEn cuanto comenzó a anochecer, Pinocho, recordando que no había comido\nnada, sintió un retortijón de tripas, que se parecía mucho al apetito.\nPero el apetito en los niños va a gran velocidad y, de hecho, después de\npocos minutos, el apetito se volvió hambre y el hambre, en un abrir y cerrar\nde ojos, se volvió en un hambre de lobos, un hambre incontrolable.\nEl pobre Pinocho corrió hasta el fogón donde había una olla que hervía y\ntuvo la intención de destaparla para ver qué había dentro. Pero la olla estaba\npintada sobre la pared. Imagínense cómo quedó. Su nariz, que ya estaba\nlarga, se le hizo más larga por lo menos cuatro dedos más.\nEntonces se puso a correr por la habitación y a hurgar en todos los\ncajones y todas las alacenas en busca de un pan, al menos un pedazo de pan\nduro, un hueso roído por un perro, una polenta mohosa, la espina de un pez,\nuna cereza, en suma, cualquier cosa para masticar. Pero no encontró nada,\nnada, absolutamente nada.\nY mientras tanto el hambre aumentaba cada vez más y el pobre Pinocho\nno le quedaba aliento más que para bostezar, y daba unos bostezos tan\ngrandes que a veces le llegaban hasta las orejas. Y después de haber\nbostezado, escupía, y sentía salírsele el estómago.\nEntonces, llorando y desesperándose, decía:\n—El Grillo parlante tenía razón. He hecho mal rebelándome contra mi\npadre y huyendo de casa… Si mi padre estuviera acá, ahora no me\nencontraría muriendo a punta de bostezos. ¡Oh, qué horrible enfermedad es\nel hambre!\nY en ese momento le pareció ver arriba de la basura algo redondo y\nblanco que parecía un huevo de gallina. En un segundo dio un brinco y le\ncayó encima. Era un huevo de verdad.\nLa alegría de la marioneta es imposible de describir: es necesario\nimaginársela. Casi creyendo que era un sueño, jugaba con el huevo entre las\nmanos, lo tocaba, lo besaba, y besándolo decía:\n—¿Y ahora cómo voy a cocinarlo? Me haré una tortilla… No, es mejor\ncocinarlo en una cazuela… ¿Y no será más sabroso si lo frito en una sartén?\n¿Y si lo cocino en agua?… No, la manera más rápida es hacerlo en una\ncazuela: tengo muchas ganas de comérmelo.\nDicho y hecho, puso una cazuela sobre un caldero lleno de brasas\nardientes, y puso en la cazuela, en vez de aceite o mantequilla, un poco de\nagua y, cuando el agua comenzó a hervir, ¡tac!… Rompió la cáscara del\nhuevo e hizo el gesto para verterlo adentro.\nPero, en vez de la clara y la yema, se escapó un pollito muy alegre y\nceremonioso que, haciendo una gran reverencia, dijo:\n—Muchas gracias, señor Pinocho, por haberme ahorrado el trabajo de\nromper la cáscara. Hasta luego, que esté bien y saludes a todos.\nDicho esto, extendió las alas y, enfilando hacia la ventana, que estaba\nabierta, voló hasta perderse de vista.\nLa pobre marioneta se quedó ahí como hechizada, con los ojos fijos, la\nboca abierta y los pedazos de cáscara en la mano. Apenas se repuso de la\nsorpresa, comenzó a llorar, a gritar, a golpear el suelo con los pies de la\ndesesperación, y llorando decía:\n—El Grillo parlante tenía razón. Si no me hubiese escapado de casa,\nahora no estaría a punto de morir de hambre. ¡Oh, qué horrible enfermedad\nes el hambre!\nY como el cuerpo le gruñía más que nunca, y no sabía cómo acallarlo,\npensó en salir de casa y darse una vuelta por el pueblo vecino, con la\nesperanza de encontrar alguna persona caritativa que le diera una limosna\npara comprar un pedazo de pan.\nVI\nPinocho se queda dormido con los pies sobre el caldero y la mañana siguiente se\ndespierta con los pies completamente quemados.\nEra una noche de invierno. Tronaba muy fuerte y relampagueaba como si el\ncielo se fuera a encender y un viento frío y lacerante, silbando rabiosamente\ny levantando una inmensa nube de polvo, hacía crujir y estremecer todos los\nárboles del campo.\nPinocho sentía un gran miedo de los truenos y los rayos; solo que el\nhambre era más fuerte, motivo por el cual entornó la puerta de la casa y\nemprendió la carrera: en cien saltos llegó hasta el pueblo, con la lengua\nafuera y agitado como un perro de caza.\nEncontró todo oscuro y desierto. Las tiendas estaban cerradas, las puertas\nde la casa cerradas, las ventanas cerradas y en las calles ni siquiera un\nperro. Parecía el país de los muertos.\nEntonces Pinocho, presa de la desesperación y del hambre, se pegó a la\ncampanilla de una casa y la hizo sonar prolongadamente, diciéndose:\n«Alguno tendrá que aparecer».\nEn efecto, se asomó un vecino, que tenía puesto el gorro de dormir, y le\ngritó enfurecido:\n—¿Qué quiere a esta hora?\n—¿Me podría hacer el favor de darme un poco de pan?\n—Espérame ahí que ya vuelvo —respondió el viejo, que creía estar\ntratando con alguno de esos muchachos atolondrados que se divierten\nhaciendo sonar los timbres de las casas por la noche, para molestar a la\ngente de bien que duerme tranquilamente.\nDespués de medio minuto, la ventana se volvió a abrir y la misma voz del\nvecino llegó hasta Pinocho:\n—Hazte debajo y pon el sombrero.\nPinocho alzó su sombrerito, pero, mientras lo hacía, sintió que le caía\nagua de una enorme palangana que lo emparamó de la cabeza a los pies,\ncomo si fuera el florero de un geranio marchito.\nVolvió a casa bañado como un pollito y agotado por el cansancio y el\nhambre. Y como no tenía fuerzas para pararse derecho, se quedó sentado y\napoyó los pies, encharcados y enlodados, sobre un caldero lleno de brasas\nardientes.\nY ahí se durmió. Y mientras dormía a los pies, que eran de madera, se les\nprendió el fuego y poco a poco se le carbonizaron hasta volverse cenizas.\nSin embargo Pinocho seguía durmiendo y roncando, como si los pies no\nfueran suyos. Finalmente, al alba se despertó, porque alguien tocó la puerta.\n—¿Quién es? —preguntó bostezando y restregándose los ojos.\n—Soy yo —respondió una voz.\nEra la voz de Geppetto.\nVII\nGeppetto vuelve a casa, rehace los pies de la marioneta y le da el desayuno que\nel pobre hombre había traído para él.\nEl pobre Pinocho, que aún tenía los ojos abotargados, no se había percatado\nde que tenía los pies chamuscados, por lo cual, apenas oyó la voz de su\npadre, saltó del taburete para quitar el cerrojo, pero, tambaleándose, se fue\ncontra el suelo y ahí quedó tendido cuan largo era.\nY al darse contra el piso hizo el mismo ruido que habría hecho un saco de\ncucharas arrojadas desde un quinto piso.\n—¡Ábreme! —gritaba Geppetto desde la calle.\n—Padre mío, no puedo —respondía la marioneta llorando y\narrastrándose por el suelo.\n—¿Por qué no puedes?\n—Porque me comieron los pies.\n—¿Y quién te los comió?\n—El gato —dijo Pinocho, viendo el gato que con las patas delanteras se\nentretenía jugando con unos trozos de madera.\n—¡Ábreme, te digo! —repitió Geppetto—, ¡si no, cuando entre, el gato\nvoy a ser yo!\n—No puedo pararme, créeme. Oh, pobre de mí, pobre de mí, que me\ntocará ir de rodillas toda la vida…\nGeppetto, creyendo que todos estos lloriqueos eran otra travesura de la\nmarioneta, pensó en resolver todo este asunto y, trepándose al muro, se\nmetió a la casa por la ventana.\nYa quería comenzar a reprenderlo, pero entonces, cuando vio a su\nPinocho echado en el suelo y de verdad sin pies, se enterneció y, tomándolo\ndel cuello, se puso a darle besos, a consentirlo y a hacerle mil monerías y,\ncon los lagrimones que se le caían por las mejillas, le dijo sollozando:\n—Pinochito mío, ¿cómo fue que te quemaste los pies?\n—No lo sé, padre, pero créeme que ha sido una noche de pesadilla, de la\nque nunca me voy a olvidar. Tronaba, relampagueaba y yo tenía mucha\nhambre y entonces el Grillo parlante me dijo: «Está bien: como eres un niño\nmalo, te lo mereces», y yo le dije: «¡Cuidado, Grillo!», y él me dijo: «Tú\neres una marioneta y tienes la cabeza de madera», y yo le tiré el mango de\nun martillo y murió, pero fue su culpa, porque yo no quería matarlo, prueba\nde eso es que puso una cazuela sobre las brasas encendidas del caldero,\npero el pollito se escapó y dijo: «Hasta luego, saludos por casa», y el\nhambre era cada vez más grande, razón por la cual ese viejito con gorro,\nasomándose por la ventana, me dijo: «Hazte debajo y pon el sombrero», y\nyo, con ese chorro de agua encima (porque pedir un poco de pan no es\nvergüenza, ¿cierto?), me regresé rápido a la casa y, como seguía con mucha\nhambre, puse los pies en el caldero para secarme, y tú volviste y ya estaban\ncompletamente quemados, aunque el hambre seguía y ya no tengo pies…\nY el pobre Pinocho comenzó a llorar y gritar tan fuerte, que podía\nescucharse a cinco kilómetros de distancia.\nGeppetto, que de todo ese discurso inconexo había entendido solo una\ncosa —que la marioneta se estaba muriendo del hambre—, sacó del bolsillo\ntres peras y extendiéndoselas le dijo:\n—Estas tres peras eran para mi desayuno, pero te las doy con gusto.\nCómetelas; ¡buen provecho!\n—Si quieres que me las coma, hazme el favor de pelarlas.\n—¿Pelarlas? —exclamó Geppetto sorprendido—. Jamás hubiera\npensado, hijo mío, que eras tan asquiento y tan melindroso para comer.\n¡Qué mal! En este mundo, desde pequeños es necesario acostumbrarse a\ncomer de todo, porque nunca se sabe qué nos puede pasar. ¡Suceden tantas\ncosas!\n—Tienes razón —sollozó Pinocho—, pero nunca comeré una fruta que\nno esté pelada. No soporto las cáscaras.\nY el buen hombre de Geppetto, sacando su cuchillo y armándose de santa\npaciencia, peló las tres peras, y puso las cáscaras en una esquina sobre la\nmesa.\nLuego de que Pinocho en dos bocados se comió la primera pera, tuvo el\ngesto de arrojar el corazón, pero Geppetto se lo impidió diciéndole:\n—No lo botes: todo en este mundo puede ser útil.\n—Pero el corazón no me lo voy a comer —gritó la marioneta,\nvolviéndose como una víbora.\n—¡Quién sabe! ¡Suceden tantas cosas! —repitió Geppetto sin alterarse.\nY entonces los tres corazones de pera, en vez de ser arrojados por la\nventana, fueron puestos en una esquina de la mesa junto con las cáscaras.\nTras ser comidas o, para decirlo mejor, devoradas las tres peras, Pinocho\nbostezó exageradamente y dijo lloriqueando:\n—¡Sigo teniendo hambre!\n—Pero, niño mío, no tengo nada más para darte.\n—¿Nada nada?\n—Si acaso estas cáscaras y estos corazones de pera.\n—¡Está bien! —dijo Pinocho—, si no hay nada más, comeré un pedazo\nde cáscara.\nY comenzó a masticar. Al principio torció un poco la boca, pero luego,\nuna tras otra, devoró en un suspiro todas las cáscaras, y después de las\ncáscaras los corazones; y cuando acabó con todo, se sacudió las manos feliz\ny dijo regocijándose:\n—¡Ya por fin estoy satisfecho!\n—Ves, entonces —observó Geppetto—, que tenía razón cuando te decía\nque era necesario no ser muy sofisticado ni muy refinado del paladar.\nQuerido mío, no se sabe nunca qué puede pasar en este mundo. ¡Suceden\ntantas cosas!\nVIII\nGeppetto le rehace los pies a Pinocho y vende su propio abrigo para comprarle\nuna cartilla.\nLa marioneta, apenas dejó de tener hambre, comenzó de inmediato a\nquejarse y a llorar, porque quería un par de pies nuevos.\nPero Geppetto, para castigarlo por sus travesuras, lo dejó llorar y\ndesgañitarse medio día; luego le dijo:\n—¿Y por qué debería rehacerte los pies? ¿Para ver que escapas de nuevo\nde la casa?\n—Te lo juro —dijo la marioneta—: de hoy en adelante seré bueno.\n—Todos los niños —replicó Geppetto—, cuando quieren obtener algo,\nhablan así.\n—Te juro que iré a la escuela, estudiaré y me graduaré con honores.\n—Todos los niños, cuando quieren obtener algo, repiten la misma\nhistoria.\n—¡Pero yo no soy como los otros niños! Yo soy mejor que los otros y\nsiempre digo la verdad. Te prometo, papá, que aprenderé un arte y que seré\nel consuelo y el soporte de tu vejez.\nGeppetto que, a pesar de su cara de tirano tenía los ojos llenos de\nlágrimas y el corazón ensanchado por el amor que le inspiraba su pobre\nPinocho en ese estado lastimoso, no respondió nada. Pero, tomando sus\nherramientas de trabajo y dos pedazos de leña seca, se puso a trabajar con\ngran dedicación.\nY, en menos de una hora, los pies quedaron hechos: dos piecitos esbeltos,\nacabados, perfectos, como si hubieran sido modelados por un artista genial.\nEntonces Geppetto le dijo a la marioneta:\n—Cierra los ojos y duerme.\nY Pinocho cerró los ojos y fingió dormir. Y mientras se hacía el dormido,\nGeppetto, con un poco de pegamento disuelto en cáscara de huevo, encajó\nlos dos pies en su lugar, y los pegó tan bien, que ni siquiera se veían las\njunturas.\nApenas la marioneta se dio cuenta de que tenía pies, saltó de la mesa\ndonde estaba acostado y comenzó a hacer mil piruetas y mil maromas,\ncomo si hubiera enloquecido de la felicidad.\n—Para recompensarte por todo lo que has hecho por mí —dijo Pinocho a\nsu padre—, quiero ir ya a la escuela.\n—¡Felicitaciones, mi niño!\n—Pero para ir a la escuela me hace falta algo con que vestirme.\nGeppetto, que era pobre y no tenía en el bolsillo ni un centavo, le hizo\nentonces un trajecito con un papel de flores, un par de zapatos con la\ncorteza de un árbol y un gorro con miga de pan.\nPinocho corrió a verse en el reflejo de una palangana llena de agua y\nquedó tan contento, que dijo pavoneándose:\n—¡Parezco todo un señor!\n—Es verdad —le dijo Geppetto—, porque, tenlo siempre presente, no es\nel traje el que hace al señor, sino la limpieza del traje.\n—A propósito —añadió la marioneta—, para ir a la escuela me falta otra\ncosa; de hecho, me falta lo más importante y lo mejor.\n—¿De qué hablas?\n—Me falta la cartilla.\n—Tienes razón; ¿pero cómo hacer para que tengas una?\n—Muy fácil: ve donde un librero y la compras.\n—¿Y el dinero?\n—Yo no tengo.\n—Yo tampoco —añadió el buen hombre poniéndose súbitamente triste.\nPinocho, si bien era un niño alegre, se puso triste también él: porque la\nmiseria, cuando es de verdad miserable, la entienden todos, incluso los\nniños.\n—¡No hay problema! —gritó Geppetto de repente poniéndose de pie y,\nagarrando el viejo abrigo de fustán todo remendado, salió corriendo de casa.\nPoco después regresó. Y cuando volvió tenía en la mano la cartilla para\nsu hijo, pero no el abrigo. El pobre hombre estaba en mangas de camisa. Y\nafuera nevaba.\n—¿Y el abrigo, papá?\n—Lo vendí.\n—¿Por qué lo vendiste?\n—Porque me acaloraba.\nPinocho entendió la respuesta al vuelo y, no pudiendo frenar el ímpetu de\nsu buen corazón, saltó al cuello de Geppetto y comenzó a besarlo por toda\nla cara.\nIX\nPinocho vende la cartilla para ir al teatro de marionetas.\nCuando dejó de nevar, Pinocho, con su maravillosa cartilla nueva debajo del\nbrazo, tomó la calle que lo llevaba a la escuela y, en el camino, especulaba\ncon mil razonamientos y mil castillos en el aire, cada uno más fabuloso que\nel anterior.\nY pensando así se decía:\n«Hoy en la escuela quiero ya aprender a leer, mañana aprenderé a escribir\ny pasado mañana aprenderé a contar. Luego, con mi habilidad, ahorraré\nmucho dinero que guardaré en el bolsillo, pues quiero darle a mi padre un\nbonito abrigo de paño. Pero, ¡qué digo! Se lo haré todo de plata y oro con\nbotones de brillantes. Ese pobre hombre se lo merece de verdad, porque, en\nsuma, por comprarme los libros, se quedó en mangas de camisa… ¡y con\neste frío! Solo los padres son capaces de tales sacrificios».\nMientras así, conmovido, decía esto, le pareció oír a lo lejos una música\nde pífanos y tambores: pi-pi-pi, pi-pi-pi, zum-zum-zum.\nSe paró y se puso a escuchar. Esos sonidos sonaban a lo lejos de una\nlarguísima calle que conducía a un pueblecito levantado en una playa al\nlado del mar.\n—¿Qué es esta música? Lástima que deba ir a la escuela, pues si no…\nY se quedó ahí confundido. De cualquier modo, era necesario tomar una\ndecisión: o a la escuela o a escuchar los pífanos.\n—Hoy iré a escuchar los pífanos, y mañana iré a la escuela: para ir a la\nescuela siempre hay tiempo —dijo finalmente este pilluelo, alzando los\nhombros.\nDicho y hecho, enfiló por la calle y se puso a correr dando grandes\nzancadas. Cuanto más se acercaba, más nítido oía el sonido de los pífanos y\nlos golpes a los bombos: pi-pi-pi, pi-pi-pi, pi-pi-pi, zum, zum, zum, zum.\nAl cabo se encontró en medio de una plaza llena de gente, la cual se\napiñaba en torno a una enorme caseta de madera, cubierta por una tela\npintada de mil colores.\n—¿Qué hay en esa caseta? —preguntó Pinocho, volviéndose a un\nmuchachito del lugar.\n—Lee el cartel y lo sabrás.\n—Lo leería con gusto, pero justamente hoy no sé leer.\n—¡Felicitaciones! Entonces te lo leeré yo. En ese cartel de letras rojas\ncomo el fuego está escrito: gran teatro de las marionetas.\n—¿Y hace mucho que comenzó la función?\n—Ya va a comenzar.\n—¿Y cuánto cuesta la entrada?\n—Cuatro pesos.\nPinocho, que era presa de la fiebre de la curiosidad, perdió cualquier\nreserva y le dijo sin pena al jovenzuelo con el que hablaba:\n—¿Me prestarías cuatro pesos y te los devuelvo mañana?\n—Te los daría con gusto —le respondió el otro en tono de burla—, pero\njustamente hoy no te los puedo dar.\n—Te vendo mi chaqueta por cuatro pesos —le dijo entonces la\nmarioneta.\n—¿Y qué quieres que haga con una chaqueta de papel florido? Si llueve,\nno hay manera de quitársela de encima.\n—¿Quieres entonces comprarme mis zapatos?\n—Solo me servirían para encender el fuego.\n—¿Y cuánto me das por mi gorro?\n—¡Sería una gran adquisición! ¡Un gorro de miga de pan! Los ratones\npodrían venir a comerse mi cabeza.\nPinocho estaba decidido. Iba a hacer su última oferta, pero le faltaba\nvalor: dudaba, vacilaba, sufría. Al final dijo:\n—¿Quieres darme cuatro pesos por esta cartilla nueva?\n—Yo soy un niño y no compro nada de niños —le respondió su pequeño\ninterlocutor que tenía mucho más juicio que él.\n—Por cuatro pesos yo compro la cartilla —gritó un revendedor de paños\nusados que presenciaba la conversación.\nY el libro fue vendido sin más trámite. ¡Y pensar que el buen hombre de\nGeppetto se había quedado en casa temblando del frío en mangas de camisa\npara poder comprarle la cartilla a su hijito!\nX\nLas marionetas reconocen a su hermano Pinocho y le hacen una gran fiesta. En\nel mejor momento sale la marioneta Comefuego y Pinocho corre el peligro de\nsalir mal librado.\nCuando Pinocho entró en el teatrino de marionetas, sucedió algo que casi\ndesencadena una revolución.\nEs necesario saber que el telón estaba arriba y la función ya había\ncomenzado.\nSobre el escenario se veían a Arlequín y a Polichinela que discutían entre\nellos y, como era su costumbre, se amenazaban con darse bofetones y\nbastonazos.\nEl público, todo atento, soltaba grandes carcajadas al presenciar la\ndisputa de estas dos marionetas que actuaban y se insultaban con tanta\npropiedad, como si fueran dos animales racionales y dos personas de este\nmundo.\nEn cierto momento, de repente, Arlequín dejó de recitar y, volviéndose al\npúblico y señalando con la mano a alguien al fondo de la platea, comenzó a\ngritar en tono dramático:\n—¡Dioses del firmamento! ¿Sueño o estoy despierto? ¿No es acaso\nPinocho ese que está allá?\n—Es el mismísimo Pinocho —gritó Polichinela.\n—El mismo —aulló la señora Rosaura, que hacía de flor en la parte de\natrás del escenario.\n—¡Es Pinocho, es Pinocho! —gritaron en coro todas las marionetas,\nsaliendo de los bastidores—. ¡Es Pinocho! ¡Nuestro hermano Pinocho!\n¡Viva Pinocho!\n—¡Pinocho, ven acá conmigo! —clamó Arlequín—. ¡Ven a que te\nabracen tus hermanos de palo!\nAnte esta afectuosa invitación, Pinocho dio un brinco y pasó del fondo de\nla platea hacia delante, a los puestos de lujo. Luego, con otro salto, de los\npuestos de lujo se montó en la cabeza del director de orquesta, y de allí se\nlanzó al tablado.\nEs imposible imaginarse los abrazos, los estrujones, los pellizcos de\namistad y los cabezazos de verdadera y sincera hermandad que Pinocho\nrecibió, en medio de la confusión, de los actores y actrices de aquella\ncompañía dramático-vegetal.\nEste espectáculo fue conmovedor, sobra decirlo. Pero el público de la\nplatea, viendo que la función no proseguía, se impacientó y se puso a gritar:\n—¡Que siga la función, que siga la función!\nEl esfuerzo fue en vano, porque las marionetas, en vez de continuar la\nrepresentación, redoblaron el escándalo y la bulla y, montando a Pinocho\nsobre sus espaldas, lo llevaron victorioso hacia las luces del teatro.\nEntonces salió el titiritero, un hombre tan feo que asustaba con solo\nmirarlo. Tenía una barba negra como un garabato de tinta y era tan larga\nque le llegaba hasta el suelo: basta decir que, cuando caminaba, se la pisaba\ncon los pies. Su boca era enorme como un horno, sus ojos parecían dos\nlámparas de vidrio rojo encendidas y con sus manos hacía chasquear un\nlátigo hecho de serpientes y colas de zorro.\nLa súbita aparición del titiritero los enmudeció a todos: nadie volvió a\nrespirar. Se hubiera podido oír el vuelo de una mosca. Esas pobres\nmarionetas, hombres y mujeres, temblaban como hojas.\n—¿Por qué viniste a alborotar mi teatro? —preguntó el titiritero a\nPinocho, con el vozarrón de un orco con gripa.\n—Créame, ilustrísimo, que la culpa no es mía.\n—¡Cállate! Esta noche arreglaremos cuentas.\nDe hecho, al final de la función, el titiritero fue a la cocina, donde se le\npreparaba, para la cena, un gran cordero, que giraba ensartado en el asador.\nY como faltaba leña para terminarlo de cocinar, llamó a Arlequín y a\nPolichinela y les dijo:\n—Tráiganme acá esa marioneta que se encontraron… Parece una\nmarioneta hecha de una madera bastante seca y estoy seguro de que, si lo\nboto al fuego, aportará al fuego del asado con una bonita llamarada.\nArlequín y Polichinela al principio titubearon. Pero aterrorizados por las\nmiradas de su dueño, obedecieron y al rato volvieron a la cocina, cargando\nen los brazos al pobre Pinocho, que, sacudiéndose como una anguila fuera\ndel agua, gritaba desesperadamente:\n—¡Padre mío, sálvame! No quiero morir, no quiero morir.\nXI\nEl Comefuego estornuda y perdona a Pinocho, que luego salva de la muerte a su\namigo Arlequín.\nEl titiritero Comefuego (este era su nombre) parecía un hombre pavoroso,\nno digo que no, sobre todo por esa barba negra que, como un mandil, le\ncubría todo el pecho y todas las piernas; pero en el fondo no era un hombre\nmalvado. Una prueba de esto era que, cuando tuvo en frente al pobre\nPinocho que trataba de zafarse de mil maneras gritando: «No quiero morir,\nno quiero morir», comenzó a conmoverse y apiadarse; y después de haber\nresistido un buen rato, al final no pudo más y dejó escapar un sonorísimo\nestornudo.\nTras este estornudo Arlequín, que hasta ese momento se había sentido\ntriste y se había deshecho como un sauce llorón, se le iluminó la cara y,\narrimándose a Pinocho, le susurró:\n—¡Buenas noticias, hermano! El titiritero estornudó y esto es señal de\nque se ha compadecido por ti y entonces te has salvado.\nPorque es necesario saber que, mientras todos los hombres, cuando\nalguien los conmueve, lloran o, por lo menos hacen el amague de secarse\nlas lágrimas, Comefuego, al contrario, cada vez que se enternecía de verdad\ntenía el vicio de estornudar. Era un modo como cualquier otro de dar a\nconocer a los demás la sensibilidad de su corazón.\nDespués de haber estornudado, el titiritero, haciéndose el gruñón, le gritó\na Pinocho:\n—¡Deja ya de llorar! Tus lamentos me han abierto un hueco en el\nestómago… siento un ansia que casi, casi… —y estornudó dos veces más.\n—¡Salud! —dijo Pinocho.\n—Gracias. ¿Y tu padre y tu madre aún están vivos? —le preguntó\nComefuego.\n—Mi padre, sí; a mí madre nunca la conocí.\n—¡Quién sabe qué disgusto sería para tu viejo padre si decidiera echarte\nahora mismo entre estos carbones ardientes! ¡Pobre viejo, lo\ncompadezco!… —y estornudó tres veces más.\n—¡Salud!\n—¡Gracias! Por lo demás, es necesario que me compadezcan también a\nmí, porque, como ves, no tengo\nmás leña para asar ese cordero asado, y tú, para decirte la verdad, en este\ncaso me hubieras hecho un gran favor. Pero me apiadé y solo me queda\narmarme de paciencia. En vez de ti, pondré a quemar en el asador a alguna\nmarioneta de mi compañía. ¡Gendarmes!\nA esta orden, aparecieron de inmediato dos gendarmes de madera, largos\nlargos, secos secos, con el pelo de la cabeza iluminado y un sable\ndesenfundado en la mano.\nEntonces el titiritero les dijo con voz agónica:\n—Agarren a Arlequín, amárrenlo bien y luego arrójenlo al fuego. Quiero\nque mi cordero quede bien asado.\n¡Imagínense al pobre Arlequín! Fue tanto su pavor, que las piernas se le\ndoblaron y cayó de bruces en el suelo.\nPinocho, ante este desgarrador espectáculo, fue a lanzarse a los pies del\ntitiritero y, llorando desconsolado y bañando en lágrimas todos los pelos de\nla larguísima barba, comenzó a decir con voz suplicante:\n—¡Piedad, señor Comefuego!\n—Aquí no hay señores —replicó duramente el titiritero.\n—¡Piedad, señor caballero!\n—Aquí no hay caballeros.\n—¡Piedad, señor comendador!\n—Aquí no hay comendadores.\n—¡Piedad, su excelencia!\nAl oírse llamar excelencia, el titiritero de inmediato estiró la boca y, de\nrepente más humano y cordial, dijo a Pinocho:\n—Bueno, ¿qué quieres de mí?\n—Te pido que le concedas el indulto al pobre Arlequín.\n—Ya no más indultos. Si te he perdonado la vida a ti, debo echarlo al\nfuego a él, porque quiero que mi cordero se dore bien.\n—En este caso —gritó fieramente Pinocho, irguiéndose y botando su\ngorro de miga de pan—, en este caso sé cuál es mi deber. ¡Adelante, señores\ngendarmes! Átenme y arrójenme entre las llamas. No, no es justo que el\npobre Arlequín, mi verdadero amigo, deba morir por mí.\nEstas palabras, pronunciadas en voz alta y con acento heroico, hicieron\nllorar a todas las marionetas que estaban presentes en el escenario. Los\nmismos gendarmes, aunque eran de palo, lloraban como dos corderitos\nrecién nacidos.\nComefuego al principio se mantuvo impertérrito como un pedazo de\nhielo, pero luego poco a poco comenzó él también a conmoverse y a\nestornudar. Y tras cuatro o cinco estornudos, abrió afectuosamente los\nbrazos y le dijo a Pinocho:\n—Eres un gran muchacho: ven acá y me das un beso.\nPinocho corrió y, trepándose como una ardilla por la barba del titiritero,\nfue a darle un cariñosísimo beso en la punta de la nariz.\n—¿Entonces me salvé? —preguntó el pobre Arlequín, con un hilo de voz\nque apenas se escuchaba.\n—Te salvaste —respondió Comefuego, y luego añadió suspirando y\nmeneando la cabeza:\n—¡Está bien! Por esta noche me resignaré a comerme el cordero medio\ncrudo, pero, la próxima vez, ¡ay del que le toque!\nCon la noticia del perdón obtenido, las marionetas corrieron sobre el\nescenario y, prendidas las luces y las lámparas como en una velada de gala,\ncomenzaron a saltar y a bailar. Cuando llegó el alba, seguían bailando.\nXII\nEl titiritero Comefuego le regala cinco monedas de oro a Pinocho, para que se\nlas lleve a su padre Geppetto, y Pinocho se las deja birlar de la Zorra y el Gato y\nse va con ellos.\nAl día siguiente Comefuego llamó aparte a Pinocho y le preguntó:\n—¿Cómo se llama tu padre?\n—Geppetto.\n—¿Y qué hace para ganarse la vida?\n—Ser pobre.\n—¿Y gana mucho?\n—Gana lo suficiente para no tener nunca un centavo en el bolsillo.\nImagínese que, para comprarme la cartilla de la escuela, debió vender el\núnico abrigo que tenía: un abrigo que, con parches y remiendos, era un\ndesastre.\n—Pobre diablo, me da pesar. Ten estas cinco monedas de oro. Ve y se las\nllevas y salúdalo de parte mía.\nPinocho, como era de suponer, agradeció mil veces al titiritero, abrazó\nuna a una a todas las marionetas de la compañía y, fuera de sí de la alegría,\nemprendió su camino de regreso a casa.\nPero no había alcanzado a hacer medio kilómetro, cuando se encontró en\nel camino a una Zorra coja de un pie y un Gato ciego de los dos ojos, que\niban por ahí, ayudándose entre ellos como buenos compañeros de\ninfortunio. La Zorra, que era coja, caminaba apoyándose en el Gato, y el\nGato, que era ciego, se dejaba guiar por la Zorra.\n—Buen día, Pinocho —le dijo la Zorra, saludándolo amablemente.\n—¿Cómo es que sabes mi nombre? —preguntó la marioneta.\n—Conozco bien a tu padre.\n—¿Dónde lo viste?\n—Lo vi ayer en la puerta de su casa.\n—¿Y qué hacía?\n—Estaba en mangas de camisa y temblaba del frío.\n—¡Pobre padre! Pero, si Dios quiere, de hoy en adelante no volverá a\nsentir frío.\n—¿Por qué?\n—Porque me he vuelto un gran señor.\n—¿Un gran señor tú? —dijo la Zorra y comenzó a reírse grosera y\nburlonamente; y el Gato también se reía, pero para disimular se peinaba los\nbigotes con las patas delanteras.\n—No hay nada de qué reírse —vociferó Pinocho resentido—. Lamento\naguarles la fiesta, pero estas que ven aquí son cinco preciosas monedas de\noro.\nY mostró las monedas que le había regalado Comefuego.\nAl simpático sonido de estas monedas, la Zorra, involuntariamente, estiró\nla pata que parecía como encogida y el Gato entornó los dos ojos que\nparecían dos linternas verdes. Pero luego los cerró de repente, de modo que\nPinocho no alcanzó a darse cuenta de nada.\n—Y ahora —le preguntó la Zorra—, ¿qué quieres hacer con esas\nmonedas?\n—Antes que nada —respondió la marioneta—, quiero comprarle a mi\npadre un bonito abrigo nuevo, de oro y plata, con botones de brillantes. Y\nluego quiero comprar una cartilla para mí.\n—¿Para ti?\n—Sí, porque quiero ir a la escuela y ponerme a estudiar de verdad.\n—¡Mírame a mí! —dijo la Zorra—. Por el estúpido afán de estudiar,\nperdí una pierna.\n—¡Mírame a mí! —dijo el Gato—. Por el estúpido afán de estudiar, perdí\nla vista en cada uno de mis ojos.\nEn ese momento, un Mirlo blanco, que estaba apostado en la acera de la\ncalle, dijo a su vez:\n—Pinocho, no les hagas caso a tus malos compañeros; si lo haces, ¡te\narrepentirás!\nPobre Mirlo, ¡mejor no hubiera hablado! El Gato, dando un gran salto, se\nle fue encima y, sin darle tiempo a musitar una palabra, se lo zampó de un\nbocado, con plumas y todo.\nLuego de comérselo y de haberse limpiado la boca, cerró los ojos y\nvolvió a hacerse el ciego como antes.\n—Pobre Mirlo —dijo Pinocho al Gato—, ¿por qué lo has tratado tan\nmal?\n—Fue para darle una lección. Para que aprenda que, la próxima vez, no\ndebe inmiscuirse en los asuntos de los demás.\nYa habían llegado a mitad de la calle, cuando la Zorra, deteniéndose de\nrepente, dijo a la marioneta:\n—¿Quieres multiplicar tus monedas de oro?\n—¿Cómo así?\n—¿Quieres convertir tus cinco miserables monedas de oro en cien, o mil,\no dos mil?\n—¡Por supuesto! ¿Qué hay que hacer?\n—Muy fácil. En vez de regresar a tu casa, deberías venir con nosotros.\n—¿A dónde?\n—Al País de los Gaznápiros.\nPinocho lo pensó un momento y luego dijo resueltamente:\n—No, no quiero ir. Estoy cerca de casa y ya quiero llegar a ver a mi\npadre, que me espera. Quién sabe cuánto ha suspirado ayer al no verme\nregresar. Por desgracia, he sido un mal hijo y el Grillo parlante tenía razón\ncuando decía: «A los niños desobedientes no les va bien en este mundo». Y\nyo lo he comprobado a mi pesar, porque han ocurrido muchas desgracias, e\nincluso ayer por la noche en la casa del Comefuego he corrido peligro…\n¡Brrr! Me dan escalofríos de solo acordarme.\n—Entonces —dijo la Zorra—, ¿quieres irte a tu casa? Ve, tanto peor para\nti.\n—¡Tanto peor para ti! —repitió el Gato.\n—Piénsalo bien, Pinocho, porque le estás dando una patada a la suerte.\n—¡A la suerte! —repitió el Gato.\n—Tus cinco monedas de oro se convertirían, de un día para otro, en dos\nmil.\n—¡Dos mil! —repitió el Gato.\n—¿Pero cómo es posible que se vuelvan tantas? —preguntó Pinocho, con\nla boca abierta del asombro.\n—Te lo explico de inmediato —dijo la Zorra—. Es necesario saber que\nen el País de los Gaznápiros hay un terreno bendito, al que todos llaman el\nCampo de los Milagros. Tú haces en este terreno un pequeño hueco y metes\nadentro, por ejemplo, una moneda de oro. Luego vuelves a llenar el hueco\ncon tierra, lo riegas con dos cubetas de agua de la fuente, echas una pizca de\nsal y a la noche te vas tranquilamente a dormir. Mientras tanto, la moneda\ngermina y florece, y a la mañana siguiente, al volver al campo, ¿con qué te\nencuentras? Con un árbol cargado con tantas monedas de oro como granos\npuede haber en una espiga en el mes de junio.\n—Entonces —dijo Pinocho cada vez más asombrado—, ¿si yo entierro\nen este terreno mis cinco monedas de oro, a la mañana siguiente cuántas\nmonedas encontraré?\n—Es un cálculo facilísimo —respondió la Zorra—, un cálculo que\npuedes hacer con los dedos de la mano. Pon que cada moneda te reporte\nquinientas monedas: multiplica quinientos por cinco, y a la mañana\nsiguiente tendrás en tu bolsillo dos mil quinientas monedas, contantes y\nsonantes.\n—¡Oh, qué maravilla! —gritó Pinocho, bailando de la alegría—. Apenas\nrecoja esa cantidad de monedas, cogeré dos mil para mí y los otros\nquinientos se los daré a ustedes dos de regalo.\n—¿Un regalo para nosotros? —exclamó la Zorra, con un gesto de desdén\ny casi ofendida—. ¡Dios nos libre!\n—¡Dios nos libre! —repitió el Gato.\n—Nosotros —retomó la Zorra— no trabajamos por intereses mezquinos:\nnosotros trabajamos únicamente para enriquecer a los demás.\n—¡A los demás! —repitió el Gato.\n«Qué gente valiosa», pensó para sí Pinocho. Y, olvidándose ahí mismo de\nsu padre, de su abrigo nuevo, de la cartilla y de todos sus buenos propósitos,\ndijo entonces a la Zorra y al Gato:\n—Vamos entonces: voy con ustedes.\nXIII\nLa Hostería del Cangrejo Rojo.\nTras caminar y caminar y caminar, cuando la tarde ya iba a morir, llegaron\nmuertos del cansancio a la Hostería del Cangrejo Rojo.\n—Detengámonos acá —dijo la Zorra—. Comamos un poco y reposemos\nunas horas. A medianoche reemprenderemos el viaje, para lograr llegar\nmañana al alba al Campo de los Milagros.\nEntraron a la Hostería y se sentaron los tres en una mesa, pero ninguno\nde ellos tenía apetito.\nEl pobre Gato, sintiéndose gravemente indispuesto del estómago, no\npudo comer otra cosa que treinta y cinco salmonetes con salsa de tomate y\ncuatro porciones de tripas a la parmesana, y como la tripa no le parecía\nsuficientemente aliñada, tres veces pidió mantequilla y queso rallado.\nLa Zorra también habría devorado con gusto cualquier cosa, pero como\nel médico le había ordenado una dieta rigurosísima, se debió contentar\napenas con un liebre de sabor dulzón, acompañada de pollos y gallos\ntiernos. Después de la liebre se hizo llevar, para completar, un guiso de\nperdiz, conejo, rana, lagarto y uva del paraíso. Y luego no quiso nada más.\nLa comida le había producido tantas náuseas, decía ella, que no podía\nacercarse nada a la boca.\nEl que menos comió fue Pinocho. Pidió un montoncito de nueces y un\npedazo de pan, y dejó en el plato las dos cosas. El pobre, con el\npensamiento fijo en el Campo de los Milagros, se había indigestado\nanticipadamente con las monedas de oro.\nCuando terminaron de cenar, la Zorra dijo al hostelero:\n—Danos dos buenas habitaciones, una para el señor Pinocho y otra para\nmí y mi compañero. Antes de proseguir el viaje nos echaremos una siesta.\nSin embargo recuerda que, a medianoche, queremos que nos despierten para\ncontinuar nuestro viaje.\n—Sí, señores —respondió el hostelero, y picó el ojo a la Zorra y al Gato\ncomo diciendo: «Ya entendí. Estoy con ustedes».\nApenas Pinocho se metió a la cama, se durmió y comenzó a soñar. Y\nsoñaba que estaba en mitad de un campo, y que este campo estaba lleno de\nárboles cargados de racimos, y que estos racimos estaban llenos de monedas\nde oro, que, al balancearse por el viento, hacían zin, zin, zin, como\nqueriendo decir: «quien quiera venga a tomarnos». Pero cuando Pinocho\nestaba en la mejor parte, cuando extendió la mano para coger una manotada\nde estas monedas y metérselas al bolsillo, se despertó de repente por tres\nviolentísimos golpes en la puerta de su habitación.\nEra el hostelero que venía a decirle que ya era medianoche.\n—¿Y mis compañeros ya están listos? —le preguntó la marioneta.\n—Más que listos. Partieron hace dos horas.\n—¿Y por qué tanta prisa?\n—Porque el Gato recibió una embajada en la que se le informaba que el\ngato mayor, enfermo de sabañones en los pies, estaba en peligro de muerte.\n—¿Y pagaron la cena?\n—¡Cómo se le ocurre! Son personas muy educadas para haberlo\ninjuriado de esa manera.\n—¡Lástima! Me hubiera gustado ser víctima de esa afrenta —dijo\nPinocho, rascándose la cabeza. Entonces preguntó:\n—¿Y dónde dijeron que me iban a esperar?\n—En el Campo de los Milagros, mañana al despuntar el alba.\nPinocho pagó una moneda de oro por su cena y por la de sus compañeros,\ny luego partió.\nPero se puede decir que se marchó a tientas, porque afuera de la Hostería\nera tal la oscuridad que no se podía ver más allá de la punta de la nariz. Y\nen el campo no se oía el aleteo de una hoja. Solamente algunos pájaros\nnocturnos, que atravesaban la calle de una acera a la otra, venían a batir sus\nalas en la nariz de Pinocho, que, saltando hacia atrás del miedo, gritaba:\n«¿Quién está ahí?», y el eco de las colinas alrededor repetía desde lejos:\n«¿Quién está ahí?¿Quién está ahí?¿Quién está ahí?».\nMientras caminaba, vio en el tronco de un árbol un animalito que titilaba\ncon una luz pálida y opaca, como una veladora dentro de una lámpara de\nporcelana transparente.\n—¿Quién eres? —le preguntó Pinocho.\n—Soy la sombra del Grillo parlante —respondió el animalito, con una\nvocecita débil que parecía venir del más allá.\n—¿Qué quieres de mí? —dijo la marioneta.\n—Quiero darte un consejo. Regresa y lleva las cuatro monedas que te\nquedan a tu pobre padre que llora y se desespera por no verte.\n—Mañana mi padre será un gran señor, porque estas cuatro monedas se\nvolverán dos mil.\n—No te confíes de quienes prometen hacerte rico de la noche a la\nmañana. Por lo general, o están locos o son embaucadores. Hazme caso,\nvuelve a casa.\n—Yo en cambio quiero seguir adelante.\n—Ya es tarde…\n—Quiero seguir adelante.\n—La noche es oscura…\n—Quiero seguir adelante.\n—El camino es traicionero…\n—Quiero seguir adelante.\n—Recuerda que los niños que quieren actuar según su capricho, tarde o\ntemprano se arrepienten.\n—Otra vez las mismas historias. Buenas noche, Grillo.\n—Buenas noche, Pinocho, y que el cielo te salve de los chaparrones y de\nlos asesinos.\nApenas dijo estas últimas palabras, el Grillo parlante se apagó de repente\ncomo se apaga una vela al soplarla, y el camino se hizo más oscuro que\nantes.\nXIV\nPinocho, por no hacer caso a los buenos consejos del Grillo parlante, se topa\ncon los asesinos.\n«De verdad —se dijo la marioneta reanudando el viaje—, ¡cómo somos de\ninfortunados nosotros los niños! Todos nos gritan, todos nos reprenden,\ntodos nos dan consejos. Si se lo permitiéramos, todos se volverían nuestros\npadres y nuestros maestros: todos, incluso los Grillos parlantes. Miren:\ncomo no he querido hacer caso de ese fastidioso Grillo, quién sabe cuántas\ndesgracias, según él, me deberían ocurrir. Debería incluso encontrarme con\nasesinos. Menos mal no creo en\nasesinos, ni he creído nunca en ellos. Para mí, los asesinos fueron\ninventados aposta por los papás para asustar a los niños que quieren salir\npor la noche. Y aunque me los encontrara en la calle, ¿me darían miedo? Ni\nen sueños. Me les enfrentaría gritando: “Señores asesinos, ¿qué quieren de\nmí? Les recuerdo que conmigo no se juega. Vayan calladitos a ocuparse de\nsus cosas”. Gracias a mi locuacidad, esos pobres asesinos, ya me parece\nverlos, huirían como el viento. Y en caso de que fueran tan maleducados\npara no huir, entonces huiría yo y zanjaría el asunto…».\nPero Pinocho no pudo concluir su razonamiento, porque en este punto le\npareció oír detrás suyo un ligerísimo crujir de hojas.\nSe volvió para mirar, y vio en la oscuridad dos siluetas negras, como\nenvueltas en dos sacos de carbón, las cuales corrían detrás de él a saltos y\nen las puntas de los pies, como si fueran fantasmas.\n«De verdad están acá», dijo para sí y, sin saber dónde esconder sus cuatro\nmonedas de oro, las escondió en la boca, justo debajo de la lengua.\nLuego intentó escapar. Pero no había dado el primer paso, cuando se\nsintió sujeto por los brazos y oyó dos voces horribles y cavernosas que le\ndijeron:\n—¡La bolsa o la vida!\nPinocho, al no poder responder pues tenía las monedas en la boca, hizo\nmil muecas y pantomimas, para dar a entender al par de encapuchados —de\nlos que solo se les veían los ojos por dos rotos en los sacos— que él solo era\nuna pobre marioneta y que ni siquiera tenía en el bolsillo un centavo de\nmentiras.\n—¡Vamos, vamos, menos charla y más dinero! —gritaron\namenazadoramente los dos maleantes.\nY la marioneta hizo con las manos y con la cabeza el gesto de que no\ntenía nada.\n—Saca el dinero o morirás —dijo el asesino de mayor estatura.\n—¡Morirás! —repitió el otro.\n—Y después de matarte a ti, mataremos a tu padre.\n—¡No, no, no, a mi padre no! —gritó Pinocho desesperado, pero al gritar\nasí, las monedas le sonaron en la boca.\n—¡Ah, bribón! Con que escondiste el dinero debajo de la lengua…\n¡Escúpelo ya!\nY Pinocho, quieto.\n—Ah, ¿te haces el sordo? Espérate que te lo haremos escupir.\nDe hecho uno de ellos aferró a la marioneta por la punta de la nariz y el\notro lo agarró por la barbilla, y comenzaron a sacudirlo violentamente, cada\nuno hacia un lado distinto, a ver si lograban abrirle la boca. Pero no hubo\nmanera. La boca de la marioneta parecía clavada y remachada.\nEntonces el asesino más bajo de estatura sacó un cuchillo y, a modo de\npalanca, se lo fue poniendo entre los labios, pero Pinocho, ágil como un\nrelámpago, le mordió la mano con los dientes y, después de habérsela\narrancado de un mordisco, la escupió. E imagínense su asombro cuando, en\nvez de una mano, se dio cuenta de que había escupido la zarpa de un gato.\nEnvalentonado con esta primera victoria, forcejeó y se liberó de las\ngarras de los asesinos y, saltando sobre los setos al lado del camino,\ncomenzó a huir por el campo, y los asesinos a correr detrás de él como\nperros persiguiendo una liebre. Y el que había perdido su zarpa corría, sin\nsaberse cómo, con una sola pierna.\nDespués de correr quince kilómetros, Pinocho no pudo más. Entonces,\nviéndose perdido, se trepó a un pino altísimo y se sentó en la rama más alta.\nLos asesinos intentaron montarse también ellos, pero, al llegar a la mitad\ndel tronco, se resbalaron y, al precipitarse contra el suelo, se rasparon las\nmanos y los pies.\nPero no por esto se dieron por vencidos. Recogieron un montón de leña\nseca, la pusieron al pie del pino e iniciaron un fuego. Y en menos de lo que\ncanta un gallo el pino comenzó a encenderse y a arder. Pinocho, viendo que\nlas llamas subían cada vez más, y dado que no quería terminar como un\npollo asado, dio un gran salto desde la punta del árbol, y siguió corriendo a\ntravés del campo y los viñedos. Y los asesinos detrás, siempre detrás, sin\ncansarse nunca.\nMientras comenzaba a apagarse el día y no dejaban de perseguirlo,\nPinocho de repente no pudo continuar, pues se encontró ante un foso\nenorme, profundísimo, lleno de agua sucia, color café, lechosa. ¿Qué hacer?\n«¡Uno, dos, tres!», gritó la marioneta y, lanzándose después de tomar un\ngran impulso, saltó al otro lado. Y los asesinos también se lanzaron, pero\ncomo no habían hecho bien el cálculo… rataplán, cayeron en medio del\nfoso. Pinocho, al oír el ruido sordo con el que caían al agua, gritó riendo y\nsin dejar de correr:\n—Buen baño, señores asesinos.\nY cuando ya se los imaginaba bien ahogados, se volteó a mirar y se\npercató de que seguían corriendo detrás de él, siempre envueltos en sus\nsacos y chorreando agua como dos canastos desfondados.\nXV\nLos asesinos persiguen a Pinocho y, después de haberlo alcanzado, lo cuelgan\nen la rama de un roble gigante.\nEntonces la marioneta, perdiendo el ánimo, estuvo a punto de lanzarse a la\ntierra y darse por vencido, cuando, al mirar en torno, vio en medio del\noscuro verde de los árboles, a lo lejos, el blanco destello de una casita\ncándida como la nieve.\n«Si tuviese el aliento de llegar hasta esa casa, quizás pueda salvarme», se\ndijo.\nY sin dudarlo un instante, reemprendió la carrera a toda velocidad en\nmedio del bosque. Y los asesinos siempre detrás.\nY después de una correr por casi dos horas, jadeante, llegó a la puerta de\nla casita y tocó.\nNadie respondió.\nVolvió a tocar con más fuerza, porque sentía cada vez más cerca el rumor\nde los pasos y la respiración pesada y afanosa de sus perseguidores. El\nmismo silencio.\nNotando que tocar no lo iba a llevar a nada, comenzó desesperado a darle\npatadas y puños a la puerta. Entonces se asomó a la ventana una hermosa\nniña, con el pelo turquesa y la cara blanca como una imagen de cera, los\nojos cerrados y las manos cruzadas sobre el pecho que, sin mover los labios,\ndijo con una vocecita que parecía venir del otro mundo:\n—En esta casa no hay nadie. Todos están muertos.\n—Ábreme entonces tú —gritó Pinocho llorando e implorando.\n—Yo también estoy muerta.\n—¿Muerta? ¿Y entonces qué haces ahí en esa ventana?\n—Espero el ataúd que me va a llevar.\nApenas dijo esto, la Niña desapareció y la ventana se cerró sin hacer\nruido.\n—Oh, hermosa Niña del pelo turquesa—gritaba Pinocho—, ábreme por\nfavor. Ten piedad de este pobre niño perseguido por los asesis…\nPero no pudo terminar la palabra, porque se sintió agarrado del cuello. Y\nlas mismas dos voces que gruñían amenazadoramente le dijeron:\n—Ya no te vas a escapar.\nLa marioneta, viendo tan cerca la muerte, tembló tan fuertemente, que al\nsacudirse le sonaban las junturas de sus piernas de palo y las cuatro\nmonedas de oro que tenía escondidas debajo de la lengua.\n—¿Entonces? —le preguntaron los asesinos—, ¿quieres abrir la boca, sí\no no? ¿No contestas?… Deja no más, que esta vez te la abriremos nosotros.\nY sacaron dos cuchillos largos y afilados como navajas y le asestaron dos\ngolpes en medio de los riñones.\nPero la marioneta, para su fortuna, estaba hecha de una madera durísima,\nmotivo por el cual las hojas, rompiéndose, se deshicieron en mil partes y los\nasesinos se quedaron con el mango de los cuchillos en la mano.\n—Ya entendí —dijo uno de ellos—: es necesario colgarlo.\n¡Colguémoslo!\n—¡Colguémoslo! —repitió el otro.\nDicho y hecho: le ataron las manos detrás de la espalda y, haciendo un\nnudo corredizo en el cuello, lo amarraron y lo dejaron colgando de un ramo\nde una gran planta, denominada el Gran Roble.\nLuego se quedaron ahí, sentados sobre la hierba, esperando a que la\nmarioneta pataleara por última vez. Pero la marioneta, después de tres\nhoras, seguía con los ojos abiertos, la boca cerrada y pataleaba más que\nnunca.\nAl fin, aburridos de esperar, se volvieron hacia Pinocho y le dijeron\nsarcásticamente:\n—Hasta mañana. Cuando volvamos mañana aquí, esperamos que tengas\nla decencia de encontrarte bien muerto y con la boca abierta.\nY se fueron.\nEntre tanto, se había levantado un viento impetuoso de más allá de los\nmontes que soplaba y rugía con rabia, zarandeando al pobre ahorcado,\nmeciéndolo violentamente como el badajo de una campana que estuviera de\nfiesta. Y ese balanceo le provocaba agudísimos dolores y el nudo corredizo,\napretándose cada vez más al cuello, le quitaba la respiración.\nPoco a poco sus ojos se empañaron. Y si bien sentía acercarse la muerte,\ntambién esperaba a que, de un momento a otro, apareciera un alma\ncaritativa que lo ayudara. Pero cuando, tras esperar y esperar, vio que nadie\naparecía, absolutamente nadie, lo asaltó el recuerdo de su pobre padre… y\nbalbució casi moribundo:\n—¡Oh, padre mío! ¡Si tú estuvieras acá!…\nY no tuvo aliento para decir más. Cerró los ojos, abrió la boca, estiró la\npata y, dando una grande sacudida, se quedó como tieso.\nXVI\nLa bella Niña del pelo turquesa hace recoger a la marioneta, la mete y manda\nllamar a tres médicos para saber si está viva o muerta.\nEn ese momento en que el pobre Pinocho, colgado por los asesinos en una\nrama del Gran Roble, parecía más muerto que vivo, la bella Niña del pelo\nturquesa se asomó por la ventana y, compadecida ante la vista de aquel\ninfeliz que, ahorcado, iba y venía al capricho del viento tramontano, batió\ntres veces las manos y dio tres pequeños golpes.\nA esta señal, se sintió un gran ruido de alas que volaban con vertiginosa\nfogosidad, y un gran Halcón fue a posarse en el alféizar de la ventana.\n—¿Qué quieres ordenar, mi preciosa Hada? —dijo el Halcón bajando el\npico en señal de reverencia (porque es necesario saber que la Niña de pelo\nturquesa era a fin de cuentas una bondadosísima hada que desde hacía más\nde mil años vivía en la vecindad de ese bosque).\n—¿Ves tú aquella marioneta que pende de la rama del Gran Roble?\n—La veo.\n—Pues vuela hacia ella, rompe con tu poderosísimo pico el nudo que la\nsostiene en el aire y, con delicadeza, déjala tendida sobre la hierba al lado\ndel Roble.\nEl Halcón tomó vuelo y después de dos minutos volvió diciendo:\n—Lo que me ordenaste ya está hecho.\n—Y cómo la encontraste, ¿viva o muerta?\n—Al verla, parecía muerta, pero aún no debe de estar muerta, porque\napenas deshice el nudo corredizo que le apretaba el cuello dejó escapar un\nsuspiro y balbució a media voz: «Ahora me siento mejor».\nEntonces el Hada, batiendo las manos y dando dos pequeños golpes, hizo\naparecer un magnífico Perro callejero, que caminaba orondo sobre las patas\ntraseras, tal cual como si fuera un hombre.\nEl Perro callejero estaba vestido de cochero, con una elegante librea.\nTenía en la cabeza un sombrero de tres puntas galoneado de oro, una peluca\nblanca con rizos que le llegaban hasta el cuello, una chaqueta color\nchocolate con botones brillantes y con dos grandes bolsillos para guardar\nlos huesos que le regalaba su dueña, unos pantalones cortos de terciopelo\ncarmesí, medias de seda, escarpines recortados y, por detrás, una suerte de\nfunda de raso azul para meter dentro la cola, en los momentos de lluvia.\n—¡Ven acá, Medoro! —dijo el Hada al Perro callejero—. Ven rápido y\nengancha la más hermosa carroza de mi escudería y toma el camino del\nbosque. Cuando llegues al Gran Roble, encontrarás tendida sobre el pasto\nuna pobre marioneta medio muerta. Recógela con cuidado, acomódala\ndespacio sobre los cojines de la carroza y tráemela aquí. ¿Entendiste?\nEl Perro callejero, para mostrar que había entendido, agitó tres o cuatro\nveces la funda de raso azul que tenía detrás y partió como un caballo\nbereber.\nEn poco tiempo se le vio salir en una hermosa carroza color aire, toda\nadornada con plumas de canario y forrada adentro con nata batida y pasteles\nsaboyanos. Cien parejas de ratones tiraban de la carroza, y el Perro\ncallejero, sentado en el pescante, hacía chasquear la fusta a izquierda y\nderecha, como un chofer que tiene el temor de llegar tarde.\nNo había pasado siquiera un cuarto de hora, cuando la carroza volvió y el\nHada, que estaba esperando sobre el vano de la casa, tomó del cuello a la\npobre marioneta, la llevó a un cuarto que tenía las paredes de madreperla y\nmandó a llamar de inmediato a los médicos más famosos de los alrededores.\nY los médicos fueron llegando uno tras otro: primero un Cuervo, más\ntarde una Cigarra y al final un Grillo parlante.\n—Señores, quisiera saber de ustedes —dijo el Hada, dirigiéndose a los\ntres médicos reunidos en torno al lecho de Pinocho—, quisiera saber si esta\ndesventurada marioneta está viva o está muerta.\nAnte esta invitación el Cuervo, adelantándose a todos, midió el pulso a\nPinocho, luego le tocó la nariz, el dedo meñique del pie y, cuando hubo\npalpado bien, pronunció solemnemente estas palabras:\n—Según mi parecer, la marioneta está bien muerta, pero si por desgracia\nno lo estuviera, entonces esto sería indicio de que está bien viva.\n—Lo lamento —dijo la Cigarra—, pero debo contradecir al Cuervo, mi\nilustre amigo y colega: para mí, por el contrario, la marioneta está bien\nviva; si por desgracia no lo estuviera, esto sería señal de que de verdad está\nmuerta.\n—¿Y usted no dice nada? —preguntó el Hada al Grillo parlante.\n—Yo digo que el médico prudente, cuando no sabe lo que dice, lo mejor\nque puede hacer es quedarse callado. Por lo demás, a esta marioneta la\nconozco desde hace ya un tiempo.\nPinocho, que desde entonces había estado inmóvil como un verdadero\npedazo de madera, tuvo una especie de espasmo que lo hizo sacudirse en el\nlecho.\n—Esta marioneta —continuó diciendo el Grillo parlante— es un\nredomado bribón.\nPinocho abrió los ojos y los volvió a cerrar de nuevo.\n—Es un pillo, un sinvergüenza, un vagabundo…\nPinocho escondió la cara debajo de las sábanas.\n—Esta marioneta es un hijo desobediente que matará de un infarto a su\npobre padre.\nEn este punto se oyó en la habitación un sonido sofocado de llantos y\nsollozos. Imagínense cómo quedaron todos cuando, al levantar un poco las\nsábanas, se dieron cuenta de que quien lloraba y sollozaba era Pinocho.\n—Cuando el muerto llora, es señal de que se va a curar—dijo\nsolemnemente el Cuervo.\n—Me duele contradecirlo, mi ilustre amigo y colega —añadió la Cigarra\n—, pero, según mi opinión, cuando el muerto llora, es señal de que no\nquiere morir.\nXVII\nPinocho come azúcar, pero no quiere purgarse. Cuando ve los sepultureros que\nvienen a llevárselo, entonces resuelve purgarse. Luego dice una mentira y, de\ncastigo, le crece la nariz.\nApenas los tres médicos salieron de la habitación, el Hada se acercó a\nPinocho y, después de tocarle la frente, se dio cuenta de que era presa de\nuna fiebre brutal.\nEntonces dejó caer un polvito blanco en medio vaso de agua y,\nofreciéndoselo a la marioneta, le dijo amorosamente:\n—Bébelo, y en pocos días estarás curado.\nPinocho vio el vaso, torció la boca y luego preguntó con voz melindrosa:\n—¿Es dulce o amargo?\n—Es amargo, pero te hará bien.\n—Si es amargo, no lo quiero.\n—Hazme caso: bébelo.\n—A mí lo amargo no me gusta.\n—Bébelo y, cuando la bebas, te daré una bolita de azúcar para quitarte el\nsabor de la boca.\n—¿Dónde está la bolita de azúcar?\n—Aquí —dijo el Hada, sacándola de una azucarera de oro.\n—Quiero primero la bolita de azúcar y luego beberé ese menjunje\namargo.\n—¿Me lo prometes?\n—Sí.\nEl Hada le dio la bolita y Pinocho, después de haberla mordisqueado y\ntragado en un instante, dijo relamiéndose los labios:\n—¡Sería muy bueno que el azúcar fuera una medicina! Me purgaría todos\nlos días.\n—Ahora mantén la promesa y bébete estas gotas de aguas, que te\ndevolverán la salud.\nPinocho tomó de mala gana el vaso en la mano y metió dentro la punta de\nla nariz, luego se lo acercó a la boca, volvió a meter la punta de la nariz y\nfinalmente dijo:\n—¡Está muy amargo, está muy amargo! No lo puedo beber.\n—¿Cómo lo puedes decir si ni siquiera lo has probado?\n—¡Me lo imagino! Alcanzo a sentir el olor. Antes quiero otra bolita de\nazúcar… y luego lo beberé.\nEntonces el Hada, con la paciencia infinita de una buena madre, le puso\nen la boca otra bolita de azúcar y luego le puso enfrente el vaso.\n—Así no lo puedo beber —dijo la marioneta, haciendo mil muecas.\n—¿Por qué?\n—Porque me incomoda la almohada que tengo debajo de los pies.\nEl Hada le quitó el almohadón.\n—¡Es inútil! Tampoco así lo puedo beber.\n—¿Qué más te molesta?\n—Me molesta que la puerta de la habitación esté entreabierta.\nEl Hada fue y cerró la puerta.\n—En suma —gritó Pinocho, a punto de llorar—, ¡no quiero beber este\nbrebaje amargo, no, no, no!\n—Hijo mío, te arrepentirás.\n—No me importa.\n—Tu enfermedad es grave.\n—No me importa.\n—La fiebre te llevará en pocas horas al otro mundo.\n—No me importa.\n—¿No tienes miedo de la muerte?\n—Nada de miedo… Prefiero morir a beber ese feo remedio.\nEn este punto, la puerta de la habitación de abrió de par en par y entraron\ncuatro conejos negros como la tinta que llevaban sobre la espalda un\npequeño ataúd.\n—¿Qué quieren de mí? —gritó Pinocho, enderezándose y aterrorizado\nsentándose en el lecho.\n—Hemos venido a llevarte —respondió el conejo más grande.\n—¿A llevarme?… Pero aún no estoy muerto.\n—Todavía no, pero te quedan pocos minutos de vida, tras rechazar la\nbebida que te hubiera curado de la fiebre.\n—¡Oh, Hada mía, Hadita mía! —comenzó a chillar la marioneta—,\npásame rápido el vaso aquel. Apúrate, por favor, no quiero morir, no, no\nquiero morir.\nY tomó el vaso con las dos manos y se lo bebió de un sorbo.\n—Está bien —dijeron los conejos—. Por esta vez hemos hecho el viaje\nen balde. —Y echándose de nuevo el ataúd sobre la espalda, salieron de la\nhabitación gruñendo y murmurando entre dientes.\nEl hecho es que a los pocos minutos Pinocho saltó del lecho\ncompletamente sano; porque hace falta saber que las marionetas de madera\ntienen el privilegio de enfermarse en raras ocasiones y de curarse muy\nrápidamente.\nY el Hada, viéndolo correr y saltando por la habitación tan despierto y\nalegre como un tierno gallito, le dijo:\n—¿Entonces mi medicina te hizo bien?\n—Más que bien. ¡Me volvió a la vida!\n—¿Y entonces por qué te hiciste tanto de rogar para tomártela?\n—Lo que sucede es que los niños somos todos así. Nos da más miedo la\nmedicina que el mal.\n—¡Qué vergüenza! Los niños deberían saber que una buena medicina\ntomada a tiempo puede salvarlos de una enfermedad grave e incluso de la\nmuerte.\n—La próxima vez no me haré de rogar tanto. Me acordaré de esos\nconejos negros con el ataúd sobre sus espaldas… y entonces tomaré de\ninmediato el vaso en la mano, y de inmediato lo beberé.\n—Ahora acércate un momento y cuéntame cómo fue que te encontraste\nen las manos de esos asesinos.\n—Pasó que el titiritero Comefuego me dio algunas monedas de oro y me\ndijo: «Toma, llévaselas a tu padre», y yo, al andar por la calle, me encontré\ncon la Zorra y el Gato, dos personas de bien que me dijeron: «¿Quieres que\nesas cinco monedas se conviertan en mil o en dos mil? Ven con nosotros y\nte conduciremos al Campo de los Milagros». Y yo les dije: «Vamos», y\nellos dijeron: «Detengámonos aquí en la Hostería del Cangrejo Rojo, y\ndespués de la medianoche reemprenderemos el viaje». Y, cuando me\ndesperté, ya se habían ido. Entonces comencé a caminar de noche, en medio\nde la más impenetrable oscuridad, en la que me topé a los dos asesinos\ndentro de dos sacos de carbón que me dijeron: «Saca las monedas que\ntengas», y yo dije: «No tengo», porque las cuatro monedas de oro las tenía\nescondidas debajo de la boca, y uno de los asesinos intentó meterme las\nmanos a la boca, y yo con un mordisco le arranqué la mano y la escupí,\npero en vez de una mano escupí una zarpa de gato. Y los asesinos se\npusieron a perseguirme, y yo corra que corra, hasta que me alcanzaron y me\ncolgaron en un árbol de este bosque y me dijeron: «Mañana volveremos\nacá, y entonces estarás muerto y con la boca abierta, y así nos podremos\nllevar las monedas de oro que escondes bajo la lengua».\n—¿Y dónde tienes ahora esas cuatro monedas?\n—le preguntó el Hada.\n—Las he perdido —respondió Pinocho, pero dijo una mentira, porque las\ntenía en el bolsillo.\nApenas dijo la mentira, su nariz, que ya era larga, le creció dos dedos\nmás.\n—¿Y dónde las perdiste?\n—En el bosque aquí cerca.\nTras esta segunda mentira, la nariz siguió creciendo.\n—Si las perdiste en el bosque —dijo el Hada—, las buscaremos y las\nencontraremos: porque todo lo que se pierde en el bosque vuelve a aparecer.\n—Ah, ya me acuerdo bien —agregó la marioneta enredándose—, no\nperdí las cuatro monedas de oro, sino que, sin darme cuenta, me las tragué\nal beberme la medicina.\nAnte esta tercera mentira, la nariz se le alargó de un modo tan\nextraordinario que el pobre Pinocho no podía girarse hacia ningún lado. Si\nse daba vuelta, golpeaba la nariz contra la cama o contra los vidrios de la\nventana; y si se daba vuelta hacia el otro lado, golpeaba las paredes o la\npuerta de la habitación, y si alzaba un poco la cabeza, corría el riesgo de\npicarle un ojo al Hada.\nY el Hada lo miraba y reía.\n—¿Por qué te ríes? —le preguntó la marioneta, confusa y pensativa\nrespecto de la nariz que crecía ante sus ojos.\n—Río de las mentiras que dices.\n—¿Por qué sabes que miento?\n—Las mentiras, hijo mío, se reconocen fácilmente, porque hay de dos\nespecies: están las mentiras de patas cortas y las mentiras de nariz larga. Las\ntuyas, por cierto, son de nariz larga.\nPinocho, no sabiendo dónde esconderse de la vergüenza, intentó huir de\nla habitación. Pero no lo logró. Su nariz había crecido tanto, que no podía ir\nmás allá de la puerta.\nXVIII\nPinocho se encuentra de nuevo con la Zorra y el Gato y va con ellos a sembrar\nlas cuatro monedas de oro en el Campo de los Milagros.\nComo se pueden imaginar, el Hada dejó que la marioneta llorara y gritara\nuna buena media hora, pues su nariz no pasaba de la puerta de la habitación.\nY lo hizo para darle una lección y para corregirle el feo vicio de decir\nmentiras, el más feo vicio que pueda tener un niño. Pero cuando lo vio\ntransformado y con los ojos desorbitados de la desesperación, movida por la\npiedad batió las manos y, a esta señal, entraron a la habitación por la\nventana un millar de enormes pájaros llamados Carpinteros, los cuales,\nposados todos sobre la nariz de Pinocho, comenzaron a picotearlo una y\notra vez, y en pocos minutos esa nariz enorme y desproporcionada se redujo\na su tamaño natural.\n—¡Cuán buena eres, Hada mía —dijo la marioneta secándose los ojos—,\ny cuánto te quiero!\n—Yo también te quiero —replicó el Hada— y si quieres permanecer\nconmigo, serás mi hermanito y yo seré tu hermanita.\n—Me quedaría con gusto… ¿pero mi pobre\npadre?\n—He pensado en todo. Tu padre ya fue avisado y, antes de que se haga de\nnoche, estará aquí.\n—¿De verdad? —gritó Pinocho saltando de la alegría—. Entonces,\nHadita mía, si estás de acuerdo, quiero ir a su encuentro. No veo la hora de\npoder darle un beso a ese pobre viejo que ha sufrido tanto por mí.\n—Ve entonces, pero intenta no perderte. Toma el camino del bosque y así\nseguro te lo encontrarás.\nPinocho partió y, apenas entró en el bosque, comenzó a correr como un\ncervatillo. Pero cuando llegó a cierto punto, casi enfrente del Gran Roble, se\ndetuvo, porque le pareció haber oído gente entre los matorrales. De hecho\nvio aparecer en el camino, ¿adivinen a quién?… A la Zorra y al Gato, es\ndecir a los dos compañeros de viaje con los cuales había cenado en la\nHostería del Cangrejo Rojo.\n—¡Mira a nuestro querido Pinocho!—gritó la Zorra abrazándolo y\nbesándolo—. ¿Qué te trae por acá?\n—¿Qué te trae por acá? —repitió el Gato.\n—Es una larga historia —dijo la marioneta— y se la contaré con calma.\nSepan que la otra noche, cuando me dejaron solo en la hostería, me topé\ncon unos asesinos por el camino.\n—¿Unos asesinos?… Oh, pobre amigo. ¿Y qué querían?\n—Me querían robar las monedas de oro.\n—¡Infames! —dijo la Zorra.\n—¡Infamísimos! —repitió el Gato.\n—Pero salí corriendo —continuó diciendo la marioneta— y ellos siempre\nestaban detrás persiguiéndome, hasta que me alcanzaron y me colgaron de\nuna rama de aquel roble.\nY Pinocho señaló el Gran Roble que estaba ahí a dos pasos.\n—¿Se puede oír una historia más horrible? —dijo la Zorra—. ¡En qué\nmundo estamos condenados a vivir! ¿Dónde encontraremos refugio seguro\nnosotros los hombres de bien?\nMientras hablaban así, Pinocho se dio cuenta de que el Gato estaba\nmanco de la pata derecha de adelante, pues le faltaba toda la zarpa con sus\ngarfas. Por lo cual le preguntó:\n—¿Qué le ha sucedido a tu zarpa?\nEl Gato quería responder alguna cosa, pero se hizo un lío. Entonces la\nZorra respondió aprisa:\n—Mi amigo es muy modesto, y por eso no responde. Yo respondo por él.\nMira que hace una hora nos hemos encontrado por el camino con un viejo\nlobo, casi muerto del hambre, que nos ha pedido limosna. Como solo\nteníamos para darle la espina de un pescado, ¿qué ha hecho mi amigo, que\ntiene un corazón de oro? Se ha arrancado con los dientes una zarpa de sus\npatas delanteras y la ha lanzado a esta pobre bestia, para que pudiera\ndesayunarse.\nY la Zorra, diciendo así, se secó una lágrima.\nPinocho, conmovido también él, se aproximó al Gato susurrándole al\noído:\n—¡Si todos los gatos se te parecieran, qué afortunados los ratones!\n—¿Y qué haces tú por estos lares? —preguntó la Zorra a la marioneta.\n—Espero a mi padre, que debe llegar de un momento a otro.\n—¿Y tus monedas de oro?\n—Las tengo siempre en el bolsillo, menos una que la gasté en la Hostería\ndel Cangrejo Rojo.\n—Y pensar que, en vez de cuatro monedas, ¡podrías tener mil o dos mil!\n¿Por qué no haces caso a mi consejo? ¿Por qué no vas a sembrarlas en el\nCampo de los Milagros!\n—Hoy es imposible: iré otro día.\n—Otro día ya será tarde —dijo la Zorra.\n—¿Por qué?\n—Porque ese terreno fue comprado por un gran señor y, a partir de\nmañana, no se le permitirá a nadie sembrar allí su dinero.\n—¿Y a cuánto estamos del Campo de los Milagros?\n—Apenas a dos kilómetros. ¿Quieres venir con nosotros? En media hora\nestarás ahí: siembras las cuatro monedas, después de pocos minutos recoges\ndos mil y esta noche vuelves con los bolsillos repletos. ¿Quieres venir con\nnosotros?\nPinocho dudó un poco al responder, porque se le vino a la mente la buena\nHada, el viejo Geppetto y las advertencias del Grillo parlante. Pero terminó\nhaciendo lo que hacen todos los niños, sin ningún juicio y sin corazón; es\ndecir, alzó un poco los hombros y les dijo a la Zorra y al Gato:\n—Vamos entonces: voy con ustedes.\nY partieron.\nDespués de haber caminado medio día llegaron a una ciudad que tenía\npor nombre Atrapamentecatos. Apenas entraron en la ciudad, Pinocho vio\ntodas las calles pobladas de perros pelados que bostezaban del hambre, de\novejas trasquiladas que temblaban del frío, de gallinas sin cresta y sin\nbarbilla que pedían un grano de maíz de limosna, de enormes mariposas\nincapaces de volar porque habían vendido sus bellísimas alas de colores, de\npavos sin cola que les daba vergüenza dejarse ver y de faisanes que\npateaban en silencio, añorando sus refulgentes plumas de oro y plata\nperdidas para siempre.\nEn medio de esta multitud de mendigos y pobres vergonzantes, pasaban\nde tanto en tanto algunas carrozas señoriles con alguna zorra, alguna urraca\nladrona y algún pajarraco de rapiña.\n—¿Y el Campo de los Milagros dónde está? —preguntó Pinocho.\n—Está aquí muy cerca.\nDicho y hecho, atravesaron la ciudad y, al salir de los murallas que la\nrodeaban, se detuvieron en un campo que, por donde se le mirara, era\nsemejante a cualquier otro campo.\n—Hemos llegado —dijo la Zorra a la marioneta—. Ahora agáchate, haz\nun hueco con las manos y mete ahí adentro las monedas de oro.\nPinocho obedeció: cavó el hueco, puso ahí las cuatro monedas que aún le\nquedaban y después volvió a cubrir el hueco con un poco de tierra.\n—Ahora —dijo la Zorra—, ve a esa acequia vecina, toma un balde de\nagua y riega el terreno donde las sembraste.\nPinocho fue a la acequia y, como no había por ningún lado un balde, se\nsacó una zapatilla y, llenándola de agua, regó la tierra que cubría el hueco.\nLuego preguntó:\n—¿Hay algo más que hacer?\n—Nada más —respondió la Zorra—. Ahora podemos irnos. Vuelve en\nveinte minutos y encontrarás el árbol ya despuntando del suelo, con las\nramas cargadas de monedas.\nLa pobre marioneta, fuera de sí de la alegría, les agradeció mil veces a la\nZorra y al Gato, y les prometió un hermosísimo regalo.\n—Nosotros no queremos regalos —respondieron los dos malandrines—.\nA nosotros nos basta con haberte enseñado el modo de enriquecerte sin\ntrabajar tanto y más contentos que unas pascuas.\nDicho esto, se despidieron de Pinocho y, deseándole una buena cosecha,\nse fueron a hacer sus cosas.\nXIX\nA Pinocho le roban sus cuatro monedas de oro y, de castigo, resulta cuatro meses\nen prisión.\nLa marioneta, al volver a la ciudad, comenzó a contar los minutos uno a\nuno y, cuando le pareció que ya era el momento, retomó el camino que\nllevaba al Campo de los Milagros.\nY mientras caminaba a paso apurado, el corazón le latía fuerte y hacía\ntic-tac, tic-tac, como un reloj de sala cuando funciona de verdad. Y\npensaba:\n«¿Y si, en vez de mil monedas, me encontrase en las ramas del árbol con\ndos mil?¿Y si en vez de dos mil me encontrase con cinco mil? ¿Y si fueran\nmás bien cien mil? ¡Oh, qué gran señor en el que me convertiría! Quisiera\ntener un gran palacio, mil caballitos de madera y mil escuderías para\ndivertirme, una bodega llena de rosoli y alquermes, y alacenas repletas de\nconfites, tortas, caramelos de almendra y barquillos rellenos de crema».\nAsí, fantaseando, se fue aproximando al campo, y ahí se detuvo a ver si\nhabía algún árbol con las ramas cargadas de monedas, pero no vio nada.\nDio cien pasos más, y nada. Entró en el campo y fue derecho al lugar donde\nhabía cavado el hueco y enterrado sus monedas, y nada. Entonces se puso\nmeditabundo y, olvidando las reglas de la urbanidad y la buena crianza,\nsacó una mano del bolsillo y se rascó largamente la cabeza.\nEn ese momento le zumbó en los oídos una gran carcajada y, al volverse,\nvio sobre un árbol un gran Papagallo, que se despiojaba las pocas plumas\nque tenía.\n—¿Por qué te ríes? —le preguntó Pinocho con voz alterada.\n—Río, porque al despiojarme me he hecho cosquillas bajo de las alas.\nLa marioneta no respondió. Fue a la acequia y, llenando con agua la\nmisma zapatilla, se puso de nuevo a regar la tierra con la que había\nrecubierto las monedas de oro.\nPero la misma risa, aun más fastidiosa que antes, se hizo sentir en la\nsoledad silenciosa de aquel campo.\n—Al fin —gritó Pinocho enojándose—, ¿se puede saber, Papagallo\nmaleducado, de qué te ríes?\n—Río de esos gaznápiros que creen en todas las tonterías y que se dejan\nentrampar por quien es más vivo que ellos.\n—¿Acaso hablas de mí?\n—Sí, hablo de ti, pobre Pinocho, de ti que eres tan ingenuo que crees que\nel dinero se puede sembrar y cosechar en los campos, como si se tratara de\nsembrar fríjoles y calabazas. También yo lo creí un día y hoy no tengo\nplumas. Hoy (¡pero muy tarde!) me he convencido de que, para ganar\nhonestamente algún dinero, es necesario saberlo ganar o con el trabajo de\nlas propias manos o con la inteligencia de la cabeza.\n—No te entiendo —dijo la marioneta que ya comenzaba a temblar del\nsusto.\n—¡Está bien! Me explicaré mejor —añadió el Papagallo—. Debes saber\nentonces que, mientras estabas en la ciudad, la Zorra y el Gato volvieron a\neste campo, tomaron las monedas de oro enterradas y luego huyeron como\nel viento. ¡Y valiente el que sea capaz de alcanzarlos!\nPinocho se quedó con la boca abierta y, sin querer dar fe a las palabras\ndel Papagallo, comenzó con las manos y las uñas a excavar el terreno que\nhabía regado. Cavó y cavó y cavó y terminó haciendo un hueco tan\nprofundo que habría podido caber entero un haz de heno. Pero las monedas\nno estaban ahí.\nPreso de la desesperación, volvió corriendo a la ciudad y se fue derecho a\nlos tribunales, para denunciar ante el Juez a los dos malandrines que lo\nhabían robado.\nEl Juez era un simio de la familia de los gorilas, un viejo simio respetable\npor su avanzada edad, su barba blanca y, sobre todo, sus gafas de oro, sin\nlentes, que estaba obligado a llevar siempre por una inflamación en un ojo\nque lo atormentaba desde hacía tiempo.\nPinocho, ante la presencia del Juez, contó con pelos y señales el vil\nengaño del que había sido víctima, dio el nombre, el apellido y la\ndescripción de los malandrines, y remató pidiendo justicia.\nEl Juez lo escuchó magnánimo, se interesó vivamente por el relato, se\nenterneció, se conmovió y, cuando la marioneta no tenía más que decir,\nalargó la mano e hizo sonar una campanilla.\nA esta campanada, aparecieron de repente dos mastines vestidos de\ngendarmes.\nEntonces el Juez, señalándoles a Pinocho, les dijo:\n—A este pobre diablo le han robado cuatro monedas de oro: agárrenlo y\nmétanlo sin demora en una prisión.\nLa marioneta, oyendo esta sentencia, quedó tan sorprendida que no logró\nmusitar palabra para protestar. Y los gendarmes, para no perder tiempo, le\ntaparon la boca y lo condujeron a una celda.\nY allí estuvo cuatro meses, cuatro larguísimos meses. Y pudo haber\nestado más tiempo, si no hubiera\nsido por un afortunado acontecimiento. Porque es necesario saber que el\njoven Emperador que reinaba en la ciudad de los Atrapamentecatos, tras\nuna victoria sobre sus enemigos, mandó organizar grandes fiestas públicas,\nespectáculos de fuegos artificiales, carreras de caballos y ciclistas y, como\nmuestra de su total regocijo, quiso que fueran abiertas las cárceles y dejaran\nsalir a todos los malandrines.\n—Si los demás salen de prisión, yo también quiero salir —dijo Pinocho\nal carcelero.\n—Tú, no —respondió el carcelero—, porque no eres como los demás.\n—¿Perdón? —replicó Pinocho—. Yo también soy un malandrín.\n—En este caso tienes toda la razón —dijo el carcelero y, levantándose la\ngorra, abrió la puerta de la prisión y lo dejó salir.\nXX\nLiberado de la prisión, toma el camino de regreso a la casa del Hada. Pero, a lo\nlargo del camino, se encuentra con una serpiente horrible y luego cae en una\ntrampa.\nImagínense la dicha de Pinocho al sentirse libre. Sin pensarlo un instante,\nsalió rápido de la ciudad y enfiló por el camino que debía llevarlo a la casita\ndel Hada.\nComo era temporada de lluvias, el camino estaba empantanado y el lodo\nle llegaba hasta las rodillas. Pero la marioneta no se daba por enterada.\nAnsioso por volver a ver a su padre y a su hermanita de pelo turquesa,\ncorría y daba saltos como un perro lebrel, y al correr le llegaba el barro\nhasta la coronilla. Entre tanto, se decía a sí mismo:\n«¡Cuántas desgracias me han ocurrido!… Y me las merezco, porque soy\nuna marioneta testaruda y quisquillosa… y quiero hacer siempre lo que se\nme da la gana, sin hacer caso a aquellos que me quieren y que tienen un\njuicio mil veces mejor que el mío… Pero me he propuesto, de aquí en\nadelante, cambiar de vida y volverme un niño juicioso y obediente. Sí, ya\nme di cuenta de que a los niños desobedientes no les sale nada bien y no\ndan pie con bola… ¿Mi padre me habrá esperado? ¿Me lo encontraré en la\ncasa del Hada? Hace tanto tiempo que no lo veo, que me muero por\nconsentirlo y llenarlo de besos… ¿Y el Hada me perdonará mis malas\nacciones?… Y pensar que he recibido de ella tantas atenciones y cuidados\ntan amorosos… Y pensar que, si hoy estoy vivo, es gracias a ella… ¿Es\nposible un niño más desagradecido y sin corazón que yo?».\nMientras decía esto, se detuvo de repente asustado y se devolvió unos\npasos.\n¿Qué fue lo que vio?\nHabía visto un gran Serpiente que se estiraba a lo largo del camino; tenía\nla piel verde, los ojos de fuego y la cola puntuda que humeaba como una\nchimenea.\nImposible imaginarse el miedo de la marioneta, que, tras alejarse más de\nmedio kilómetro, se sentó sobre un montón de piedras, esperando a que la\nSerpiente se fuera de una buena vez y dejara libre el camino.\nEsperó una hora, dos horas, tres horas, pero la Serpiente seguía ahí, e\nincluso de lejos se veía el llamear de sus ojos y la columna de humo que le\nbrotaba de la cola.\nEntonces Pinocho, armándose de valor, se acercó a pocos pasos de\ndistancia y, con una dulce vocecita, insinuante y sutil, dijo a la Serpiente:\n—Disculpe, señora Serpiente, ¿me podría hacer el favor de hacerse un\npoco a un lado, para que yo pueda pasar?\nFue como hablarle a una pared: nada se movió.\nEntonces, con la misma vocecita dijo:\n—Debe saber, señora Serpiente, que voy a mi casa, donde me está\nesperando mi padre, a quien hace mucho tiempo no veo… ¿Me permite\nproseguir mi camino?\nEsperó una señal en respuesta a esta petición, pero no hubo ninguna; al\ncontrario, la Serpiente, que hasta entonces parecía llena de vida, se quedó\ninmóvil y casi completamente rígida.\n—¿Será que se murió? —dijo Pinocho, frotándose las manos de la\nfelicidad; y sin perder tiempo, tuvo el gesto de saltarle por encima para\npasar a la otra parte del camino. Pero no había acabado de alzar una pierna,\ncuando la Serpiente se irguió súbitamente como un resorte, y la marioneta,\nal echarse aterrada para atrás, se tropezó y cayó en el suelo.\nY se precipitó de tan mala manera, que se le quedó la cabeza atrapada en\nel fango del camino y las piernas tiesas en el aire.\nAnte el espectáculo de esta marioneta que pataleaba frenética para\npoderse zafar, la Serpiente le dio tal ataque de risa que, de tanto reír, del\nesfuerzo que hizo de reírse tan soberanamente, se le reventó una vena del\npecho: y esta vez sí murió de verdad.\nEntonces Pinocho reanudó su carrera para llegar a la casa del Hada antes\nde que oscureciera. Pero al rato, no pudiendo soportar las punzadas del\nhambre, se coló en un campo con la intención de coger unos pocos racimos\nde uva moscatel. ¡Ojalá nunca se le hubiera ocurrido!\nApenas se aproximó a las viñas, crac… sintió que le atenazaban las\npiernas dos hierros filudos que le hicieron ver todas las estrellas del cielo.\nLa pobre marioneta había quedado presa de una trampa, puesta ahí por\nunos campesinos, para atrapar las grandes garduñas que eran el flagelo de\ntodos los pollos del lugar.\nXXI\nPinocho es atrapado por un campesino, que lo obliga a trabajar de perro\nguardián en un gallinero.\nPinocho, como se pueden imaginar, se puso a llorar, a chillar, a suplicar:\npero eran llantos y gritos inútiles, por no se veía ninguna casa alrededor y\npor el camino no se veía un alma.\nY se hizo de noche.\nUn poco por el dolor que le producía el cepo en el que estaban atrapadas\nsus piernas y un poco por el temor de encontrarse solo y en medio de la\noscuridad del campo, la marioneta sintió que se desmayaba, cuando, de\nrepente, vio pasar una Luciérnaga sobre su cabeza; la llamó y le dijo:\n—Oh, Luciernaguita, ¿me harías el favor de liberarme de este suplicio?\n—¡Pobre niño! —respondió la Luciérnaga, deteniéndose compadecida a\nmirarlo—. ¿Cómo fue que quedaste con las piernas atrapadas entre esos\nhierros afilados?\n—Me metí en el campo a coger un par de racimos de estas uvas y…\n—¿Pero las uvas eran tuyas?\n—No…\n—¿Y entonces quién te enseñó a tomar las cosas que no te pertenecen?\n—Tenía hambre…\n—El hambre, querido mío, no es una buena razón para apoderarse de las\ncosas que no nos pertenecen.\n—¡Es verdad, es verdad! —gritó Pinocho llorando—, no lo volveré a\nhacer.\nEn este punto el diálogo se interrumpió por un muy sutil ruido de pasos\nque se aproximaban. Era el dueño del campo que venía en puntas de pie a\nver si alguna de esas garduñas que vienen por la noche a comerse las\ngallinas había caído en la trampa.\nY fue grandísima su sorpresa cuando, al sacar la linterna de debajo del\nabrigo, se dio cuenta de que, en vez de una garduña, lo que había era un\nniño.\n—¡Ah, ladronzuelo! —dijo el campesino enfurecido—. ¿Con que eras tú\nel que te llevabas mis gallinas?\n—No, yo no —gritó Pinocho, sollozando—. Yo solo entré al campo a\ncoger un par de racimos de uva.\n—Quien se roba las uvas es muy capaz de robarse también las gallinas.\nYa verás, te daré una lección que nunca se te va a olvidar.\nY al abrir la trampa, aferró a la marioneta por el pescuezo y la cargó\nhasta la casa como si fuera un corderito recién nacido.\nAl llegar a la era al frente de la casa, la arrojó al suelo y, poniéndole un\npie en el cuello, le dijo:\n—Ya es tarde y quiero irme a dormir. Arreglaremos cuentas mañana.\nMientras tanto, y como hoy se me murió el perro que cuidaba de noche, tú\ntomarás su lugar. Por hoy serás el perro guardián.\nDicho y hecho: le puso en el cuello un enorme collar cubierto de puntas\nde latón y se lo ajustó de modo que no pudiera sacar la cabeza. El collar\nestaba unido a una larga cadena de hierro, y la cadena estaba fija en la\npared.\n—Si esta noche —prosiguió el campesino— comienza a llover, puedes ir\na echarte en esa caseta de madera, donde está la paja que siempre sirvió de\nlecho a mi pobre perro durante cuatro años. Y si por desgracia vienen los\nladrones, acuérdate de parar las orejas y ponerte ladrar.\nDespués de esta última advertencia, el campesino entró en la casa, cerró\nla puerta y puso seguro y el pobre Pinocho se quedó acurrucado sobre la era\nmás muerto que vivo, a causa del frío, el hambre y el temor. Y cada tanto,\nmetiéndose rabiosamente las manos en el collar que le apretaba el cuello,\ndecía gimiendo:\n—¡Me lo merezco, claro que me lo merezco! He querido hacerme el\nvivo, he sido un vago; he hecho caso a mis malvados compañeros, y por\nesto la mala suerte no me deja en paz. Si hubiera sido un niño de bien, si\nhubiese tenido ganas de estudiar y esforzarme, si me hubiera quedado en la\ncasa con mi padre, a esta hora no me encontraría acá, en medio del campo,\nhaciendo de perro guardián en la casa de un campesino. ¡Oh, si pudiera\nvolver a nacer!… Pero ya es tarde, hay que tener paciencia.\nTras este pequeño desahogo que le brotaba del corazón, entró en la casita\ny dormido se quedó.\nXXII\nPinocho descubre a los ladrones y, en recompensa por su fidelidad, es puesto en\nlibertad.\nLlevaba dormido plácidamente más de dos horas, cuando cerca de la\nmedianoche fue despertado por un cuchicheo de voces extrañas que\nparecían provenir de la era. Asomó la punta de la nariz y vio reunidas\ncuatro bestias de pelaje oscuro, que parecían gatos. Pero no eran gatos: eran\ngarduñas, animalejos carnívoros a los que les fascinan los huevos y los\npollos tiernos. Una de estas garduñas, alejándose de sus compañeras, fue a\nla casita y dijo en voz baja:\n—Buenas noches, Melampo.\n—Yo no me llamo Melampo —respondió la marioneta.\n—¿Y entonces quién eres?\n—Yo soy Pinocho.\n—¿Y qué haces ahí?\n—Soy el perro guardián.\n—¿Y Melampo dónde está?, ¿dónde está el perro que vivía en esta\ncasita?\n—Murió esta mañana.\n—¿Muerto? ¡Pobre bestia! ¡Era tan bueno!… Pero, a juzgar por tu\napariencia, tú también pareces un perro noble.\n—Discúlpeme, pero yo no soy un perro.\n—¿Qué eres entonces?\n—Soy una marioneta.\n—¿Y trabajas de perro guardián?\n—Por desgracia: es un castigo.\n—Pues bien, te propongo el mismo trato que tenía con el difunto\nMelampo. ¿Quieres?\n—¿Y cuál era ese trato?\n—Vendremos una vez a la semana, como antes, a visitar de noche este\ngallinero y nos llevaremos ocho gallinas. De estas gallinas, nos comeremos\nsiete y te daremos una a ti, con la condición, por supuesto, que finjas dormir\ny no se te cruce por la cabeza ladrar ni despertar al campesino.\n—¿Y Melampo hacía esto? —preguntó Pinocho.\n—Lo hacía y entre él y nosotros siempre estábamos de acuerdo. Entonces\nduerme tranquilamente y ten la seguridad que, antes de irnos, te dejaremos\nal lado de tu casa una gallina bien desplumada para que desayunes mañana.\n¿Entendiste bien?\n—Demasiado bien —respondió Pinocho, y meneó la cabeza de un modo\namenazante, como si hubiera querido decir: «¡Ya verás!».\nCuando las cuatro garduñas se sintieron tranquilas, se fueron\ndirectamente al gallinero que estaba justo cerca de la caseta del perro y\nabrieron con los dientes y las uñas la puerta de madera y se deslizaron\nadentro una por una. Pero no habían acabado de entrar, cuando sintieron la\npuertecita cerrarse violentamente.\nEl que la cerró fue Pinocho, que, no contento con haberla cerrado, puso\nenfrente, para mayor seguridad, una enorme piedra a modo de tranca.\nY luego comenzó a ladrar y, ladrando como si fuera de verdad un perro\nguardián, hacía con la voz: bu-bu-bu.\nCon los ladridos el campesino saltó de la cama y, luego de tomar el fusil\ny asomarse por la ventana, preguntó:\n—¿Qué pasó?\n—Hay ladrones —respondió Pinocho.\n—¿Dónde están?\n—En el gallinero.\n—Ya bajo.\nEn efecto, en menos de lo que canta un gallo, el campesino bajó y entró\ncorriendo al gallinero y, después de haber atrapado y encerrado en una bolsa\na las cuatro garduñas, les dijo con genuina alegría:\n—¡Al fin las tengo en mis manos! Podría castigarlas, pero así de malo no\nsoy. Me contentaré con llevarlas mañana al hostelero del pueblo vecino, que\nlas pelará y las cocinará como si fueran liebres. Es un honor que no\nmerecen, pero los hombres generosos como yo no les damos importancia a\nestas minucias.\nLuego, acercándose a Pinocho, comenzó a consentirlo y, entre otras\ncosas, le preguntó:\n—¿Cómo hiciste para descubrir la confabulación de estas cuadro\nladronzuelas? Y saber que Melampo, mi fiel Melampo, ¡nunca se dio cuenta\nde nada!\nLa marioneta pudo haber contado todo lo que sabía; es decir, habría\npodido contar los vergonzosos pactos que había entre el perro y las\ngarduñas, pero, acordándose de que el perro estaba muerto, pensó rápido\npara sí: «¿De qué sirve acusar a los muertos? Los muertos muertos están, y\nlo mejor que se puede hacer con ellos es dejarlos en paz».\n—Cuando llegaron las garduñas, ¿estabas dormido o despierto? —\ncontinuó preguntando el campesino.\n—Dormía —respondió Pinocho—, pero las garduñas me despertaron con\nsus chismorreos, y una vino hasta acá a decirme: «Si prometes no ladrar y\nno despertar al dueño, te regalaremos una gallina bien pelada». ¿Entiende?,\n¡tuvieron las desfachatez de hacerme semejante propuesta! Porque yo seré\nuna marioneta con todos los defectos del mundo, pero jamás sirvo de\ncómplice a la gente deshonesta.\n—¡Muy bien, muchacho! —gritó el campesino, dándole una palmada en\nla espalda—. Estas actitudes te honran. Y para demostrarte mi\nagradecimiento, te dejaré libre para que puedas volver a casa.\nY le quitó el collar de perro.\nXXIII\nPinocho llora la muerte de la hermosa Niña del pelo turquesa, luego encuentra\nun palomo que lo lleva hasta la orilla del mar y se arroja al agua para auxiliar a\nsu padre Geppetto.\nApenas Pinocho dejó de sentir el peso humillante del collar, se dedicó a\ncorrer a través de los campos y no se detuvo ni un solo minuto, hasta que no\nalcanzó el camino principal que debía conducirlo hasta la casita del Hada.\nAl llegar al camino principal, se volvió y miró abajo la llanura, y divisó a\nsimple vista el bosque, donde infortunadamente se había encontrado a la\nZorra y al Gato, y vio, en medio de los árboles, alzarse la punta del Gran\nRoble, en el cual había estado colgado. Pero, por más que observaba, no le\nfue posible descubrir la pequeña casa de la hermosa Niña del pelo turquesa.\nEntonces tuvo una suerte de triste presentimiento y, poniéndose a correr\ncon toda la fuerza que quedaban en sus piernas, se encontró en pocos\nminutos en el prado, donde una vez se levantó la blanca casita. Pero la\nblanca casita no estaba. Había, en cambio, una pequeña roca de mármol, en\nla cual se podían leer estas dolorosas palabras:\nAQUÍ YACE\nLA NIÑA DEL PELO TURQUESA\nQUE MURIÓ DE DOLOR\nTRAS HABER SIDO ABANDONADA\nPOR SU HERMANITO PINOCHO\nCuando la marioneta mal pudo deletrear estas palabras… Bueno,\nimagínense cómo quedo. Cayó postrada en el suelo y, cubriendo con mil\nbesos el mármol fúnebre, estalló en lágrimas. Lloró toda la noche y la\nmañana siguiente, al alba, seguía llorando, a pesar de que en sus ojos no\nquedaban ya lágrimas. Y sus gritos y lamentos eran tan desgarradores y\nagudos, que todas las colinas alrededor repetían su eco. Y llorando decía:\n—Oh, Hadita mía, ¿por qué te moriste? ¿Por qué, en vez de ti, no me\nmorí yo, que soy tan malo, mientras tú eras tan buena?… ¿Y mi padre,\ndónde estará? ¡Oh, Hadita mía, dime dónde puedo encontrarlo, porque\nquiero estar con él y nunca, nunca, nunca más abandonarlo!… ¡Oh, Hadita\nmía, dime que no es verdad que estás muerta! Si de veras me quieres, si\nquieres a tu hermanito, resucita, vuelve a la vida como antes!… ¿No te\ndisgusta verme solo y abandonado por todos?… Si llegan los asesinos, me\ncolgarán de nuevo en la rama de un árbol, y entonces moriré para siempre.\n¿Qué quieres que haga solo en este mundo? Ahora que te he perdido a ti y\nque no está mi padre, ¿quién me dará de comer? ¿Adónde iré a dormir por\nlas noches? ¿Quién me hará una chaquetica nueva? ¡Oh, sería mejor, cien\nmil veces mejor morir de una vez! ¡Sí, quiero morir!…\nY mientras se desesperaba de este modo, intentó arrancarse el pelo, pero\nsu pelo, al ser de madera, no podía ni siquiera agarrarse.\nEn ese momento pasó por arriba un enorme Palomo, que, planeando lento\ncon sus alas extendidas, le gritó desde una gran altura:\n—¿Dime, niño, qué haces allá abajo?\n—¿No lo ves? ¡Lloro! —dijo Pinocho alzando la cabeza hacia la voz y\nrestregándose los ojos con las mangas de la chaqueta.\n—Dime —añadió ahora el Palomo—, ¿no conoces, por casualidad, entre\ntus compañeros, una marioneta que tiene por nombre Pinocho?\n—¿Pinocho?… ¿Dijiste Pinocho? —repitió la marioneta saltando de\nrepente—. ¡Yo soy Pinocho!\nEl Palomo, ante esta respuesta, descendió velozmente y fue a posarse en\ntierra. Era más grande que un pavo.\n—Entonces conoces a Geppetto —preguntó a la marioneta.\n—¿Que si lo conozco? ¡Es mi pobre padre! ¿Acaso te ha hablado de mí?\n¿Me puedes llevar a él? ¿Está vivo? Respóndeme por favor: ¿sigue vivo?\n—Lo dejé hace tres días en una playa junto al mar.\n—¿Qué hacía?\n—Se fabricaba un bote para atravesar el Océano. Son más de cuatro\nmeses que ese pobre hombre recorre el mundo buscándote y, no habiéndote\npodido encontrar,\nse le metió en la cabeza buscarte en los lejanos países del Nuevo Mundo.\n—¿Cuánto hay de aquí a la playa? —preguntó Pinocho con incontenible\nansiedad.\n—Más de mil kilómetros.\n—¿Mil kilómetros? ¡Oh, Palomo mío, qué bueno sería tener tus alas!\n—Si quieres ir, yo te llevo.\n—¿Cómo?\n—A horcajadas sobre mi grupa. ¿Pesas mucho?\n—¿Pesar? Al contrario, soy ligero como una pluma.\nY ahí, sin decir más, Pinocho saltó sobre la grupa del Palomo y, poniendo\nuna pierna acá y la otra allá, como hacen los jinetes, gritó todo contento:\n—Galopa, galopa, caballito, que me urge llegar pronto.\nEl Palomo emprendió el vuelo y en pocos minutos llegó tan alto, que casi\ntocó las nubes. Al llegar a esta altura extraordinaria, la marioneta tuvo la\ntentación de volverse hacia abajo y mirar, y esto le produjo tanto miedo y\ntales mareos que, para evitar el peligro de caerse, se agarró, con los brazos,\nmuy fuerte del cuello de su emplumada cabalgadura.\nVolaron todo el día. Al atardecer el Palomo dijo:\n—Tengo mucha sed.\n—Y yo mucha hambre —añadió Pinocho.\n—Detengámonos en este palomar unos minutos y luego reanudaremos el\nviaje, para lograr llegar mañana, al despuntar el día, a la playa junto al mar.\nEntraron en un palomar desierto, donde solo había una palangana llena\nde agua y una canasta repleta de arvejas.\nLa marioneta, en su vida, había podido soportar las arvejas: su sola\nmención le daban náuseas y le revolvían el estómago; pero esa noche se las\ncomió hasta reventar y, cuando iba a terminar, se volvió hacia el Palomo y\nle dijo:\n—Nunca habría creído que las arvejas eran tan ricas.\n—Hay que convencerse, niño mío —replicó el Palomo—, que, cuando\nhay hambre, uno come lo que hay, y en estos casos incluso las arvejas\nresultan exquisitas. El hambre no se pone con caprichos ni sabe de antojos.\nHicieron una corta siesta, descansaron y volvieron a volar. A la mañana\nsiguiente llegaron a la playa junto al mar.\nEl Palomo dejó en tierra a Pinocho y, para ahorrarse la molestia de que le\nagradecieran el hecho de haber realizado una buena acción, retomó el vuelo\ny desapareció.\nLa playa estaba llena de gente que gritaba y gesticulaba viendo hacia el\nmar.\n—¿Qué sucede? —preguntó Pinocho a una viejita.\n—Sucede que un pobre padre, al perder a su hijo, se le ocurrió meterse en\nun bote para ir a buscarlo más allá del mar, y el mar hoy estaba picado y el\nbote está a punto de volcarse.\n—¿Dónde está el bote?\n—Míralo allá —dijo la viejita señalando un pequeño bote, que, visto a la\ndistancia, parecía la cáscara de una nuez y, adentro, un hombre pequeñito\npequeñito.\nPinocho dirigió su mirada hacia esa parte y, después de haber observado\natentamente, lanzó un grito agudísimo:\n—¡Ese es mi padre, ese es mi padre!\nEntre tanto el bote, batido por las olas, ora desaparecía entre las grandes\noleadas, ora volvía a flotar. Y Pinocho, empinado sobre la punta de una\nroca, no paraba de llamar a su padre por su nombre y de hacerle señales con\nlas manos, el pañuelo e incluso con el gorro de su cabeza.\nY al parecer Geppetto, a pesar de estar muy lejos de la playa, reconoció a\nsu hijo, porque se quitó también el gorro y, haciendo infinidad de gestos, le\ndio a entender que con gusto volvería, pero el mar estaba tan picado que le\nimpedía remar y, así, aproximarse a la tierra.\nDe repente se elevó una ola gigante y la barca desapareció. Esperaron a\nque el bote volviera a flote, pero no se dejó ver de nuevo.\n—¡Pobre hombre! —dijeron entonces los pescadores, que se habían\nreunido en la playa y, murmurando una oración, se dispusieron a regresar a\nsus casas.\nPero en un momento oyeron un grito desesperado y, mirando hacia atrás,\nvieron a un jovencito que, en la punta de un peñasco, se tiró al mar\ngritando:\n—¡Quiero salvar a mi padre!\nPinocho, al ser de madera, flotaba fácilmente y nadaba como un pez. Ora\nse veía desaparecer bajo el agua, llevado por el ímpetu de la marea, ora\nreaparecía afuera con una pierna o un brazo, lejísimos ya de la tierra. Al\nfinal lo perdieron de vista y no lo vieron más.\n—¡Pobre muchacho! —dijeron entonces los pescadores, que se habían\nreunido en la playa, y, murmurando una oración, se dispusieron a regresar a\nsus casas.\nXXIV\nPinocho arriba a la Isla de las Abejas Industriosas y se reencuentra con el Hada.\nPinocho, animado por la esperanza de alcanzar a ayudar a su pobre padre,\nnadó toda la noche.\n¡Y qué horrible nadada fue! Diluvió, granizó, tronó pavorosamente y\nhubo ciertos relámpagos que hacían que pareciera de día.\nAl alba, logró ver a poca distancia una larga franja de tierra. Era una isla\nen medio del mar.\nEntonces hizo todo lo posible por llegar a aquella playa, pero sin éxito.\nLas olas, persiguiéndose y montándose, jugaban con él, como si fuera una\nramita o un pedazo de paja. Al final, y para su fortuna, se levantó una ola\ntan potente e impetuosa, que lo arrojó a la arena de la orilla.\nEl golpe fue tan fuerte que, al estrellarse contra el suelo, le crujieron\ntodas las costillas y todas las coyunturas, pero se consoló de inmediato\ndiciendo:\n—¡De la que me salvé una vez más!\nY al tiempo, poco a poco, el cielo se serenó, el sol se dejó ver en todo su\nesplendor y el mar se tornó tranquilísimo y bueno como el aceite.\nEntonces la marioneta extendió sus ropas al sol para secarlas y se puso a\nmirar aquí y allá si por casualidad, en aquella inmensa extensión de agua,\nhabía un bote con un hombrecito adentro. Pero después de haber visto bien,\nno vio ante sí nada más que el cielo, el mar y la vela de algún barco, pero\ntan lejana que parecía una mosca.\n—¡Si supiera al menos cómo se llama esta isla! —decía—. ¡Si supiera al\nmenos si esta isla está habitada por gente de bien, quiero decir, por gente sin\nel vicio de colgar niños en las ramas de los árboles! ¿A quién se lo puedo\npreguntar? ¿A quién, si aquí no hay nadie?\nEsta idea de encontrarse íngrimo solo en medio de aquel gran país\ndeshabitado le produjo tal melancolía, que estuvo a punto de ponerse a\nllorar. Cuando de repente vio pasar, muy cerca de la orilla, un gran pez que\nse paseaba tranquilamente, con toda la cabeza fuera del agua.\nNo sabiendo su nombre para llamar su atención, la marioneta le gritó\nfuerte, para hacerse oír:\n—Ey, señor pez, ¿me permitiría hacerle una pregunta?\n—Incluso dos —respondió el pez, que era en realidad un Delfín muy\nelegante, de los que había pocos en todos los mares del mundo.\n—¿Me haría el favor de decirme si en esta isla hay algún lugar donde se\npueda comer, sin peligro de ser comido?\n—Sí, por supuesto —respondió el Delfín—, pero se encuentra un poco\nlejos de aquí.\n—¿Y qué camino debo tomar para llegar allá?\n—Debes tomar ese sendero de allí a la izquierda e ir derecho siguiendo tu\nnariz. No hay modo de que te pierdas.\n—Dígame otra cosa. Usted que anda todo el día y toda la noche por el\nmar, ¿de casualidad no se ha encontrado con el botecito en el que andaba mi\npadre?\n—¿Y quién es tu padre?\n—El padre más bueno del mundo, así como yo soy el hijo más malo que\nse pueda imaginar.\n—Con la borrasca que ha hecho esta noche —respondió el Delfín—, el\nbotecito se debe haber hundido.\n—¿Y mi padre?\n—A esta hora se lo habrá tragado el terrible Tiburón que desde hace unos\ndías ha venido a propagar el exterminio y la desolación en nuestras aguas.\n—¿Acaso es tan grande ese Tiburón? —preguntó Pinocho, que ya\ncomenzaba a temblar del miedo.\n—¡Que si es grande! —respondió el Delfín—. Para que te hagas una\nidea, te diré que es más grande que una casa de cinco pisos y que tiene una\nbocaza tan ancha y profunda, que tranquilamente se podría tragar un tren\ncon la locomotora encendida.\n—¡Madre mía! —gritó asustada la marioneta, que se vistió de nuevo\nafanosamente y se volvió hacia el Delfín y le dijo:\n—Hasta pronto, señor pez, disculpe las molestias y mil gracias por su\namabilidad.\nDicho esto, tomo rápido el sendero y comenzó a caminar rápidamente,\ntan rápidamente que parecía corriendo. Y al menor ruido, se volvía a mirar\nhacia atrás, por el temor de verse perseguido por el terrible Tiburón, grande\ncomo una casa de cinco pisos y un tren con la locomotora encendida en la\nboca.\nDespués de media hora de camino, llegó a un lugar denominado el País\nde las Abejas Industriosas. Las calles hormigueaban de personas que iban y\nvenían dedicadas a sus ocupaciones: todas trabajaban, todas tenían algo que\nhacer. Por más que se lo buscara, era imposible encontrar siquiera un ocioso\no un haragán.\n—Ya entendí —dijo de inmediato el bribón de Pinocho—. Este país no\nestá hecho para mí. Yo no nací para trabajar.\nPero el hambre lo atormentaba, pues ya habían pasado veinticuatro horas\nsin que probara bocado, ni siquiera un plato de arvejas.\n¿Qué hacer?\nSolo había dos maneras para satisfacer el hambre: o pedir trabajo, o\nmendigar una moneda o un pedazo de pan.\nPero pedir limosna le avergonzaba, porque su padre le había enseñado\nque solo los viejos y los enfermos tenían derecho a pedirla. Los verdaderos\npobres del mundo, merecedores de asistencia y de compasión, son los que,\npor razones de edad o enfermedad, están condenados a no poder ganarse el\npan con el trabajo de sus propias manos. Todos los demás tienen la\nobligación de trabajar, y si no trabajan y sufren de hambre, peor para ellos.\nEn ese momento pasó por la calle un hombre atareado que, él solo, jalaba\ncon gran esfuerzo dos carretas llenas de carbón.\nPor su aspecto, a Pinocho le pareció un buen hombre; entonces se le\nacercó y, agachando la mirada por la vergüenza y en voz baja, le dijo:\n—¿Me haría el favor de darme una moneda? Siento que me voy a\ndesmayar del hambre.\n—Una moneda no —respondió el carbonero—, sino cuatro, con la\ncondición que me ayudes a jalar hasta la casa estas dos carretas de carbón.\n—¡Me sorprende! —respondió la marioneta casi ofendida—. Para que\nsepas, ¡yo jamás he trabajado de burro; nunca he tirado carretas!\n—Bien por ti —respondió el carbonero—. Entonces, muchacho, si de\nverdad sientes que vas a morir de hambre, cómete dos buenas porciones de\ntu soberbia y trata de no indigestarte.\n—Después de algunos minutos pasó por la calle un albañil que llevaba a\nlas espaldas un saco lleno de cal.\n—¿Me harías el favor, buen hombre, de darle una moneda a este pobre\nniño que bosteza del hambre?\n—Con gusto. Ven conmigo a llevar esta cal —respondió el albañil— y te\ndaré cinco en vez de una.\n—Pero la cal es pesada —replicó Pinocho— y a mí no me gusta\ncansarme.\n—Si no quieres cansarte, entonces, muchacho, diviértete bostezando, y\nque te haga provecho.\n—En menos de media hora pasaron otras veinte personas y a todas\nPinocho les pidió una limosna, pero todas le respondieron:\n—¿No te da vergüenza? En vez de vagabundear, ve a conseguirte un\ntrabajo y aprende a ganarte el pan.\nFinalmente pasó una buena señora que llevaba dos jarras de agua.\n—Me permitirías, buena señora, que beba un sorbo de agua de tu jarra —\ndijo Pinocho reseco por la sed.\n—Bebe, niño mío —dijo la señora, dejando las dos jarras en el suelo.\nCuando Pinocho sació su sed como si fuera una esponja, masculló a\nmedia voz secándose la boca:\n—Ya no tengo sed. Ahora quisiera saciar mi hambre.\nLa buena mujer, oyendo estas palabras, añadió de inmediato:\n—Si me ayudas a llevar a casa una de estas jarras de agua, te daré un\nbuen pedazo de pan.\nPinocho vio la jarra y no dijo ni sí ni no.\n—Y además del pan te daré un plato de coliflor aderezado con aceite y\nvinagre —agregó la buena señora.\nPinocho echó otra ojeada a la jarra y no dijo ni sí ni no.\n—Y después de la coliflor, de daré un dulce relleno de rosoli.\nSeducido por la idea de probar este dulce, Pinocho no se supo resistir y,\ncon ánimo resuelto, dijo:\n—¡Está bien! Te llevaré la jarra hasta la casa.\nLa jarra estaba muy pesada, y la marioneta, no pudiendo llevarla con las\nmanos, se resignó a llevarla encima de la cabeza.\nAl llegar a la casa, la buena mujer hizo sentar a Pinocho en una mesa\nservida, y le puso enfrente el pan, la coliflor aderezada y el dulce.\nPinocho no comió: devoró. Su estómago parecía un cuartel que hubiera\nestado vacío y deshabitado desde hacía cinco meses.\nDespués de calmar poco a poco las punzadas del hambre, alzó la cabeza\npara agradecer a su benefactora, pero no acababa de verla, cuando le salió\nun oooh maravillado, y quedó ahí encantado, con los ojos muy abiertos, con\nel tenedor en el aire y con la boca llena de pan y coliflor.\n—¿Qué es toda esta maravilla? —dijo riendo la buena mujer.\n—Usted es… —respondió Pinocho balbuceando—, usted es… usted…\nusted se me parece… usted me recuerda a… sí, sí, la misma voz… el\nmismo pelo… sí, sí, sí… usted también tiene el pelo turquesa… ¡como\nella!… ¡Oh, mi Hadita, mi Hadita!… ¡Dime que eres tú!… ¡No me hagas\nsufrir más! ¡Si supieras!… ¡He llorado tanto, he sufrido tanto!…\nY al decir esto, Pinocho lloraba incontrolablemente y, arrodillándose,\nabrazaba las rodillas de esa mujercita misteriosa.\nXXV\nPinocho promete al Hada volverse bueno y ponerse a estudiar, porque está\ncansado de ser una marioneta y quiere convertirse en un niño de bien.\nAl principio la mujercita comenzó a decirle que ella no era la pequeña Hada\nde pelo turquesa, pero luego, al verse descubierta y no queriendo continuar\nel teatro, terminó reconociéndolo y le dijo a Pinocho:\n—Marioneta bellaca, ¿cómo te diste cuenta de que era yo?\n—Es el gran amor que te tengo quien me lo ha dicho.\n—¿Te acuerdas? Me abandonaste siendo niña y ahora me encuentras\ncomo una mujer: casi podría ser tu madre.\n—Me encantaría, porque así, en vez de mi hermanita, serías mi madre.\nHace tanto tiempo que me consume el deseo de tener una madre como\ntodos los niños… Pero, ¿cómo hiciste para crecer así de rápido?\n—Es un secreto.\n—Enséñamelo: yo también quisiera crecer un poco. ¿No lo ves? Siempre\nsoy tan bajito…\n—Pero tú no puedes crecer —replicó el Hada.\n—¿Por qué?\n—Porque las marionetas no crecen más. Nacen marionetas, viven como\nmarionetas y mueren como marionetas.\n—Oh, estoy cansado de ser siempre una marioneta —gritó Pinocho,\ndándose un bofetón—. Ya es hora de que me convierta en un hombre.\n—Y en uno te convertirás, si sabes ganártelo.\n—¿De verdad? ¿Y qué puedo hacer para merecerlo?\n—Algo sencillísimo: habituarte a actuar como un niño bueno.\n—¿Y es que acaso no lo soy?\n—¡Claro que no! Los niños bueno son obedientes, en cambio tú…\n—Yo nunca obedezco.\n—Los niños buenos tienen amor por el estudio y por el trabajo, y tú…\n—Yo, al contrario, soy un haragán y un vagabundo todo el tiempo.\n—Los niños buenos siempre dicen la verdad…\n—Y yo solo digo mentiras.\n—Los niños buenos van con gusto a la escuela…\n—Y a mí la escuela me produce dolores en todo el cuerpo. Pero a partir\nde hoy puedo cambiar de vida.\n—¿Me lo prometes?\n—Te lo prometo. Quiero volverme un niño bueno y ser la consolación de\nmi padre… ¿Dónde estará mi pobre padre ahora?\n—No lo sé.\n—¿Tendré la fortuna de volverlo a ver y poderlo abrazar?\n—Creo que sí; de hecho, estoy segura.\nY fue tal la alegría de Pinocho al oír esta respuesta, que tomó las manos\ndel Hada, y las besó con tanta devoción, que parecía fuera de sí. Luego,\nalzando el rostro y mirándola amorosamente, le preguntó:\n—Dime, madrecita: ¿entonces no es verdad que tú estás muerta?\n—Parece que no —respondió sonriendo el Hada.\n—Si tú supieses el dolor y el nudo en la garganta que se me hizo cuando\nleí «AQUÍ YACE…».\n—Lo sé. Y por esto te he perdonado. La sinceridad de tu dolor me mostró\nque tenías un buen corazón. Y de los niños de buen corazón, aunque sean\nun poco pillos y maleducados, siempre se puede esperar algo: es decir,\nsiempre se puede esperar que tomen el buen camino. Por eso fue que vine a\nbuscarte. Seré tu madre…\n—¡Oh, qué alegría! —gritó Pinocho, saltando de la felicidad.\n—Tú me obedecerás y harás siempre lo que te diga.\n—¡Claro, claro que sí!\n—A partir de mañana —añadió el Hada—, comenzarás a ir a la escuela.\nPinocho de inmediato se puso menos alegre.\n—Luego elegirás un arte o un oficio que te guste.\nPinocho se puso serio.\n—¿Qué murmuras entre dientes? —preguntó el Hada con tono dolido.\n—Decía… —gimoteó la marioneta a media voz— que es como tarde\npara ir a la escuela…\n—No, señor. Ten presente que para instruirte y aprender nunca es tarde.\n—Pero no quiero aprender ningún arte ni ningún oficio.\n—¿Por qué?\n—Porque me cansa trabajar.\n—Hijo mío —dijo el Hada—, esos que hablan así terminan casi siempre\nen una cárcel o en un hospital. El hombre, por principio, nazca rico o pobre,\nestá destinado en este mundo a hacer algo, a ocuparse, a trabajar. ¡Ay de los\nque se dejan arrastrar por el ocio! El ocio es una feísima enfermedad y es\nnecesario curarla rápido, desde pequeños; si no, cuando somos grandes, ya\nno nos podemos curar.\nEstas palabras afectaron a Pinocho, que alzando vivamente la cabeza dijo\nal Hada:\n—Estudiaré, trabajaré y haré todo lo que me digan, porque, en resumen,\nesta vida de marioneta ya me tiene harto, y quiero volverme un niño a como\ndé lugar. Tú me lo prometiste, ¿no es así?\n—Sí, te lo prometí. Ahora todo depende de ti.\nXXVI\nPinocho va con sus compañeros de escuela a la orilla del mar para ver al\nterrible tiburón.\nAl día siguiente, Pinocho fue a la escuela.\n¡Imagínense a esos granujas cuando vieron entrar en su escuela a una\nmarioneta! Soltaron una carcajada de nunca acabar. Uno se burlaba de él;\notro le quitaba la gorra de la mano. El de más allá lo jalaba del saco, este de\nacá intentaba pintarle bigotes bajo la nariz y aquel otro trató incluso de\namarrarles los hilos de los pies a las manos, para hacerlo bailar.\nAl principio Pinocho se hizo el desenvuelto y no hizo caso. Pero\nfinalmente, sintiendo que perdía la paciencia, se volvió hacia aquellos que\nmás lo fastidiaban y jugaban con él, y les dijo con gesto serio:\n—Cuídense, muchachos: yo no vine acá a ser su bufón. Yo respeto a los\ndemás y espero ser respetado.\n—¡Bravo, tontarrón! Hablaste como un libro—aullaron esos\nbribonzuelos, desternillándose de la risa. Y uno de ellos, más impertinente\nque los demás, alargó la mano con el propósito de agarrar la marioneta por\nla punta de la nariz.\nPero no alcanzó, porque Pinocho estiró la pierna debajo de la mesa y le\nencajó una patada en el tobillo.\n—¡Uy, qué pies tan duros! —gritó el niño sobándose el morado que le\nhabía hecho la marioneta.\n—¡Y qué codos! Más duros que los pies —dijo otro que, por sus groseras\nburlas, se había ganado un codazo en el estómago.\nEl hecho es que después de esa patada y ese codazo, Pinocho se ganó la\nestima y la simpatía de todos los niños de la escuela, y todos lo consentían y\nle deseaban bien.\nIncluso el maestro lo elogiaba, porque lo veía atento, estudioso,\ninteligente y era siempre el primero en entrar a la escuela y siempre el\núltimo en pararse cuando se terminaban las clases.\nSu único defecto es que era muy amiguero y, entre sus amigos, había\nmuchos pícaros conocidísimos por las pocas ganas que tenían de estudiar y\ndestacarse.\nEl maestro se daba cuenta de esto todos los días e incluso la buena Hada\nno dejaba de repetirle una y otra vez:\n—¡Ten cuidado, Pinocho! Esos compañeros de escuela tuyos terminarán\ntarde o temprano haciéndote perder el amor al estudio y, tal vez, trayéndote\nalguna desgracia.\n—¡No va a pasar nada! —respondía la marioneta, alzando los hombros y\ntocándose la mitad de la frente con el índice, como diciendo: «A mí me\nsobra la sensatez».\nEntonces sucedió que un buen día, mientras caminaba hacia la escuela, se\ntopó con un corrillo de sus amigotes, que se acercaron y le dijeron:\n—¿Sabes la gran noticia?\n—No.\n—Aquí cerca en el mar llegó un tiburón gigante como una montaña.\n—¿De verdad?… ¿Será el mismo tiburón que estaba cuando se hundió\nmi pobre padre?\n—Nosotros vamos a la playa a verlo. ¿Quieres venir?\n—No, quiero ir a la escuela.\n—La escuela no importa. Vamos a la escuela mañana. Una clase más o\nuna menos no va a hacer que dejemos ser los mismos burros.\n—¿Y qué va a decir el maestro?\n—Que el maestro diga lo que quiera. Igual le pagan por refunfuñar todo\nel día.\n—¿Y mi madre?\n—Las madres nunca saben anda —respondieron esos malandrines.\n—¿Saben qué voy a hacer? —dijo Pinocho—. Al tiburón quiero verlo\npor razones personales… pero iré a verlo después de la escuela.\n—¡Pobre tonto! —insistió uno del corrillo—. ¿Crees que un pez de ese\ntamaño va a estar allí esperando que tú aparezcas? Apenas se aburra, se\ndirigirá a otro lado, y quien lo vio lo vio.\n—¿Cuánto tiempo hay de aquí a la playa? —preguntó la marioneta.\n—En un hora, se puede ir y volver.\n—¡Entonces vamos! ¡Y quien llegue primero es el mejor! —gritó\nPinocho.\nAnunciada así la señal de partida, ese corrillo de bribones, con sus libros\ny cuadernos bajo el brazo, se pusieron a correr, a campo traviesa, y Pinocho\nsiempre iba delante de todos, como si tuviera alas en los pies.\nDe tanto en tanto, miraba hacia atrás y se burlaba de sus compañeros, a\nlos que ya había tomado una considerable ventaja. Al verlos jadeantes,\nagotados, polvorientos y con la lengua afuera, se reía a carcajadas. En ese\nmomento el desdichado no sabía de los pavores y de las horribles\ndesgracias con las que se iba a encontrar.\nXXVII\nHay un gran combate entre Pinocho y sus compañeros, uno de los cuales resulta\nherido, razón por la que Pinocho es arrestado por los carabineros.\nCuando arribó a la playa, Pinocho dio de inmediato un vistazo al mar, pero\nno logró ver ningún tiburón. El mar estaba liso como el cristal de un espejo.\n—¿Y dónde está el tiburón? —preguntó volviéndose a sus compañeros.\n—Se habrá ido a desayunar —respondió uno de ellos riendo.\n—O se habrá echado en la cama para echar una siesta—añadió otro\nriendo más alto que nunca.\nDe estas respuestas absurdas y de esas risas estúpidas, Pinocho entendió\nque sus compañeros le habían hecho una fea broma, dándole a entender una\ncosa que no era cierta; y tomándosela a mal, les dijo con rabia:\n—¿Y ahora? ¿Qué provecho sacan con haberme hecho creer esa historia\ndel tiburón?\n—El provecho es claro —respondieron en coro los muy traviesos.\n—¿Cuál?\n—El de hacerte perder la escuela y hacerte venir con nosotros. ¿No te da\nvergüenza ser tan juicioso y diligente en las clases? ¿No te avergüenza\nestudiar tanto?\n—¿Y si yo estudio, a ustedes qué les importa?\n—A nosotros nos importa muchísimo, porque nos haces quedar en\nridículo frente al maestro.\n—¿Por qué?\n—Porque los alumnos que estudian hacen que nos ignoren a nosotros,\nque no queremos estudiar. Y nosotros no queremos que nos ignoren:\n¡también nosotros tenemos nuestro amor propio!\n—¿Y entonces qué debo hacer para que estén contentos?\n—Debes aburrirte también tú de la escuela, las clases y el maestro, que\nson nuestros tres grandes enemigos.\n—¿Y si yo quiero seguir estudiando?\n—No te volveremos a prestar atención y a la primera oportunidad nos la\npagarás.\n—En verdad me hacen reír —dijo la marioneta sacudiendo la cabeza.\n—¡Ey, Pinocho! —gritó entonces el niño más grande mirándolo a los\nojos—. No vengas a fanfarronear, no te hagas tanto el gallito… Porque si tú\nno tienes miedo de nosotros, nosotros no tenemos miedo de ti. Recuerda\nque tú estás solo y nosotros somos siete.\n—Siete como los pecados mortales —dijo Pinocho riéndose.\n—¿Oyeron? Nos ha insultado a todos. ¡Nos dijo pecados mortales!\n—Pinocho, pídenos perdón por lo que dijiste… O si no, ¡lo pagarás caro!\n—¡Cucú! —hizo la marioneta, poniéndose el índice en la punta de la\nnariz, para burlarse.\n—¡Pinocho, la vas a pasar muy mal!\n—¡Cucú!\n—¡Te va a ir como a un burro!\n—¡Cucú!\n—¡Te vamos a romper la nariz!\n—¡Cucú!\n—Ahora el cucú te lo voy a dar yo —gritó el más osado de aquellos\nbribones—. Toma este adelanto, y sírvetelo de cena esta noche.\nY diciendo esto le propinó un puño en la cabeza.\nPero esto fue, como suele decirse, un toma y daca, porque la marioneta,\ncomo era de esperar, respondió de inmediato con otro puño, y ahí, de un\nmomento a otro, la pelea se generalizó y encarnizó.\nPinocho, si bien estaba solo, se defendía como un héroe. Con sus\ndurísimos pies de madera lograba muy bien tener a sus enemigos a una\nrespetable distancia. Adonde sus pies llegaban, dejaba un moretón de\nrecuerdo.\n—Entonces los niños, molestos por no poder vencer a la marioneta, se les\nocurrió recurrir a los proyectiles y, desprendiéndose de los libros de la\nescuela, comenzaron a lanzarle los silabarios, las gramáticas, los\nGiannettino, los Minuzzolo, los cuentos de Thouar, el Pulcino de Baccini y\notros textos escolares. Pero la marioneta, que tenía buenos reflejos y era\nágil, siempre lograba hacer la pirueta a tiempo, de modo que los volúmenes,\npasándole por encima de la cabeza, terminaban cayendo en el mar.\n¡Imagínense los peces! Los peces, creyendo que esos libros eran para\ncomer, corrían a buscarlos en desbandada, pero, después de haber mordido\nalguna página o alguna portada, la escupían ahí mismo, haciendo con la\nboca un gesto que parecía decir: «Esto no es para nosotros; estamos\nhabituados a alimentarnos mucho mejor».\nEntre tanto la guerra cada vez se hacía más feroz, cuando he aquí que un\nenorme Cangrejo, que había salido del agua y poco a poco se había trepado\nhasta la playa, gritó con un vozarrón de trombón agripado:\n—¡Ya basta, rufianes! Estas guerras entre niños nunca terminan bien.\nSiempre acaban en una desgracia.\n¡Pobre Cangrejo! Fue como si predicara al viento. Incluso ese pillo de\nPinocho, volviéndose para mirarlo de modo amenazador, le dijo\ngroseramente:\n—¡Cállate, Cangrejo de mal agüero! Harías mejor comiéndote un par de\npedazos de liquen para curarte de tu mal de garganta. Vete a la cama e\nintenta sudar.\nEn ese momento los niños, que ya habían acabado de lanzar sus libros,\nvieron ahí cerca los libros de la marioneta y se apoderaron de estos en un\nsantiamén.\nEntre estos libros había un volumen encuadernado con cartón rojo, con el\nlomo y las puntas de pergamino. Era un Tratado de aritmética. ¡Imagínense\ncómo era de pesado!\nUno de esos bribones levantó el volumen y, apuntándole a la cabeza de\nPinocho, se lo arrojó con toda la fuerza de su brazo. Pero en vez de darle a\nla marioneta, le cayó en la cabeza a uno de sus compañeros, que se puso\nblanco como un trapo lavado y apenas alcanzó a decir estas palabras:\n—¡Mamita, ayúdame… me muero!\nY entonces se desplomó sobre la arena de la playa.\nA la vista de aquel moribundo, los niños aterrorizados emprendieron la\nfuga y en pocos minutos ya no se veía ninguno.\nPero Pinocho permaneció ahí y, aunque se sentía también más muerto\nque vivo, esto no le impidió correr a mojar su pañuelo en el agua del mar\npara ponérselo en la frente a su pobre compañero de escuela. Mientras lo\nhacía, no dejaba de llorar desesperada e inconsolablemente y de llamarlo\npor su nombre diciéndole:\n—¡Eugenio, pobre Eugenio!… ¡Abre los ojos y mírame!… ¿Por qué no\nme respondes? No fui yo el que te hizo daño. Créelo, no fui yo… ¡Abre los\nojos, Eugenio! Si sigues con los ojos cerrados, me voy a morir yo\ntambién… Oh, Dios mío, ¿cómo haré ahora para volver a casa? ¿Con qué\ncara voy ahora a presentarme a la buena de mi madre?… ¿Qué será de mí?\n¿A dónde huiré? ¿Dónde me podré esconder?… ¡Oh, mejor, mil veces\nmejor sería todo si hubiera ido a la escuela! ¿Por qué les he hecho caso a\nesos compañeros que son mi desgracia? ¡El maestro me lo advirtió! ¡Mi\nmamá me lo repetía: “Ten cuidado de esos malos compañeros”! Pero soy un\nterco, un testarudo: dejo que hablen todos y luego hago lo que se me da la\ngana. Y entonces me toca arrepentirme… Y así, desde que estoy en el\nmundo, no puedo actuar bien ni por un cuarto de hora. Dios mío, ¿qué será\nde mí?\nY Pinocho continuaba llorando, chillando, dándose golpes en la cabeza y\nllamando al pobre Eugenio, cuando de repente sintió un rumor de pasos\nsordos que se aproximaba.\nSe volvió: eran dos carabineros.\n—¿Qué haces ahí tirado en el suelo? —preguntaron a Pinocho.\n—Acompañando a mi compañero de escuela.\n—¿Le pasó algo malo?\n—Parece que sí…\n—¡Muy malo! —dijo uno de los carabineros, agachándose y observando\na Eugenio de cerca—. Este niño está herido en una sien: ¿quién le hizo esa\nherida?\n—¡Yo no! —balbuceó la marioneta, que ya se estaba quedando sin\naliento.\n—Si no has sido tú, ¿entonces quién?\n—¡Yo no! —repitió Pinocho.\n—¿Y con qué objeto fue herido?\n—Con este libro —y la marioneta recogió del suelo el Tratado de\naritmética encuadernado en cartón y pergamino, para mostrárselo al\ncarabinero.\n—¿Y este libro de quién es?\n—Mío.\n—Suficiente: no hay más que decir. Párate ya y ven con nosotros.\n—Pero yo…\n—¡Ven con nosotros!\n—Pero yo soy inocente…\n—¡Ven con nosotros!\nAntes de partir, los carabineros llamaron a algunos pescadores, que en\nese momento pasaban por ahí en su barca cerca de la playa y les dijeron:\n—Les encargamos a este jovencito herido en la cabeza. Llévenselo a casa\ny cuídenlo. Mañana volveremos a verlo.\nEntonces se volvieron a Pinocho y, después de ponerlo entre los dos, lo\nexhortaron con tono castrense:\n—¡Adelante! ¡Camina rápido si no quieres que te vaya peor!\nSin necesidad de que se lo repitieran, la marioneta comenzó a caminar\npor ese sendero que conducía al pueblo. Pero el pobre diablo ni siquiera\nsabía en qué mundo estaba. Sentía que se encontraba en un mal sueño.\nEstaba fuera de sí. Sus ojos veían todo doble, las piernas le temblaban, la\nlengua se le quedaba pegada al paladar y no podían siquiera pronunciar una\npalabra. Sin embargo, en medio de aquella especie de pusilanimidad y\nentontamiento, una espina afiladísima se le enterraba en el corazón: la idea\nde tener que pasar bajo la ventana de la casa de su buena Hada, en medio de\nlos carabineros. Habría preferido morir.\nHabían ya llegado y estaban por entrar en el pueblo, cuando un ventarrón\nle arrancó su gorro y la dejó a más de diez pasos.\n—¿Me permiten —dijo la marioneta a los carabineros— que vaya a\nrecuperar mi gorro?\n—Ve, pero hazlo aprisa.\nLa marioneta fue, recogió su gorro, pero en vez de ponérselo en la\ncabeza, se lo puso en la boca entre los dientes y entonces comenzó a correr\ndesenfrenadamente hacia la playa del mar, veloz como la bala de un fusil.\nLos carabineros, juzgando que sería difícil alcanzarlo, le azuzaron un\ngran mastín que había ganado el primer premio en todas las competencias\nde perros. Pinocho corría y el perro corría más que él, por lo que toda la\ngente se asomaba a las ventanas y se agolpaba en la calle, ansiosa de ver el\nresultado de esta carrera feroz. Pero no pudieron darse ese gusto, porque el\nperro mastín y Pinocho levantaron a lo largo del camino tal polvareda, que\ndespués de pocos minutos ya no fue posible ver nada.\nXXVIII\nPinocho corre el peligro de que lo friten en una sartén como un pescado.\nDurante esa carrera desesperada, hubo un momento terrible, un momento en\nel que Pinocho se creyó perdido: porque es necesario saber que Alidoro\n(este era el nombre del perro mastín) en su feroz persecución casi lo\nalcanzó.\nBasta decir que la marioneta sentía detrás de sí, a un palmo, el jadeo\nafanoso de esa bestia e incluso sentía el vaho caliente de su aliento.\nPor fortuna, la playa estaba ya cerca y el mar se encontraba a pocos\npasos.\nApenas llegó a la playa, la marioneta dio un grandísimo salto, como lo\nhubiera podido hacer un renacuajo, y fue a caer en medio del agua. Alidoro,\nal contrario, quiso detenerse, pero, impulsado por el ímpetu de la carrera,\nentró en el agua también él. Y este desventurado no sabía nadar, por lo que\ncomenzó a agitar las patas para mantenerse a flote: pero cuanto más\npataleaba, más se hundía.\nCuando logró sacar la cabeza, se vio al pobre perro asustado y aturdido, y\nladrando gritaba:\n—¡Me ahogo! ¡Me ahogo!\n—¡Muérete! —le dijo Pinocho desde lejos, al verse ya fuera de peligro.\n—¡Ayúdame, Pinocho! ¡Sálvame de la muerte!…\nAl oír estos gritos desgarradores la marioneta, que en el fondo tenía un\ncorazón excelente, se conmovió y volviéndose hacia el perro le dijo:\n—Pero si te ayudo a salvarte, ¿prometes no molestarme más y dejar de\nperseguirme?\n—¡Te lo prometo! ¡Te lo prometo! Apúrate por favor, si lo dudas medio\nminuto más estaré muerto.\nPinocho titubeó un momento, pero luego, acordándose de que su padre le\nhabía dicho miles de veces que uno nunca se arrepiente de hacer una buena\nacción, fue nadando a alcanzar a Alidoro y, agarrándolo por la cola con las\ndos manos, lo llevó sano y salvo a la arena seca de la playa.\nEl pobre perro ni siquiera se podía parar. Había bebido, sin quererlo,\ntanta agua salada, que se había hinchado como un balón. Por lo demás la\nmarioneta, no queriendo confiarse en exceso, consideró prudente echarse\nnuevamente al mar y, alejándose de la playa, gritó al amigo rescatado:\n—Adiós, Alidoro, que tengas buen viaje y saluda de mi parte a los de tu\ncasa.\n—Adiós, Pinocho —respondió el perro—, mil gracias por haberme\nsalvado de la muerte. Me has hecho un gran favor y en este mundo se\nsiembra lo que se cosecha. Si surge la oportunidad, te devolveré el favor.\nPinocho continuó nadando, manteniéndose siempre cerca de la orilla.\nFinalmente le pareció llegar a un lugar seguro y, dando una ojeada a la\nplaya, vio sobre un escollo una suerte de gruta de la que salía un larguísimo\npenacho de humo.\n—En esa gruta —se dijo entonces—, debe haber fuego. ¡Tanto mejor! Iré\na secarme y a calentarme, y luego… ¡ya veré que resulta después!\nCuando adoptó esta determinación, se aproximó al arrecife, pero, en el\nmomento en que se disponía a escalar, sintió algo debajo del agua que\nsubía, subía y subía y que lo transportó en el aire. Trató de escapar, pero ya\nera tarde, porque con gran asombro se encontró atrapado en una red gigante\nen medio de un revuelo de peces de todos los tamaños y todas las formas\nque se agitaban y debatían como almas desesperadas.\nY al mismo tiempo vio salir de la gruta un pescador tan feo que parecía\nun monstruo marino. En vez de pelo tenía en la cabeza una mata tupidísima\nde hierba verde, verde era la piel de su cuerpo, verdes los ojos, verde la\nbarba larguísima que le llegaba hasta el suelo. Parecía un inmenso lagarto\nparado sobre las patas traseras.\nCuando el pescador sacó la red del mar, gritó todo contento:\n—¡Divina Providencia! También hoy podré hartarme de peces.\n«Al menos yo no soy un pez», se dijo Pinocho, recobrando un poco de\nvalor.\nLa red llena de peces fue llevada adentro de la gruta, una gruta oscura y\nahumada, en medio de la cual se freía una gran sartén de aceite que tenía un\nolorcito a cera capaz de cortar la respiración.\n—Ahora veamos qué peces cayeron —dijo el pescador verde e\nintroduciendo en la red una manaza tan desproporcionada, que parecía la\npala de un panadero, sacó una manotada de salmonetes—. ¡Estos buenos\nsalmonetes! —dijo mirándolos y oliéndolos complacido. Y después de\nhaberlos olfateado una vez más, los echó en un cuenco sin agua.\nLuego repitió más veces la misma operación y, a medida que fue sacando\nlos otros peces, sentía que se le hacía agua a la boca y relamiéndose decía:\n—¡Buenas estas merluzas!\n—¡Exquisitos estos mújoles!\n—¡Deliciosos estos lenguados!\n—¡Sabrosos estos meros!\n—¡Apetitosas estas anchoas!\nComo pueden imaginárselo, las merluzas, los mújoles, los lenguados, los\nmeros y las anchoas fueron a dar desordenadamente al cuenco a acompañar\nlos salmonetes.\nEl último que quedó en la red fue Pinocho.\nApenas el pescador lo sacó, abrió del asombro sus grandes ojos verdes,\nexclamando confundido:\n—¿Qué tipo de pez es este? Peces de este tipo no recuerdo haber comido\nnunca.\nY volvió a observarlo atentamente y, después de haberlo visto bien por\ntodos lados, dijo:\n—Ya entendí: debe ser un cangrejo de mar.\nEntonces Pinocho, mortificado por sentirse confundido por un cangrejo,\ndijo con tono resentido:\n—¡Pero qué cangrejos ni qué ocho cuartos! ¡Tenga cuidado con cómo me\ntrata! Para su información, soy una marioneta.\n—¿Una marioneta? —respondió el pescador—. Si te soy sincero, el pez\nmarioneta es una especie nueva para mí. Mejor así: te comeré con más\nganas.\n—¿Comerme? ¿Acaso no entiende que yo no soy un pez? ¿No ve que\nhablo y razono como usted?\n—Es verdad —añadió el pescador—. Y como veo que eres un pez que\ntiene la suerte de hablar y razonar como yo, tendré contigo las debidas\nconsideraciones.\n—Y estas consideraciones serían…\n—En señal de amistad y de especial estima, te dejaré la elección de cómo\nquieres ser cocinado. ¿Quieres que te fría en una sartén o prefieres que te\ncocine en una cazuela con salsa de tomate?\n—A decir verdad —respondió Pinocho—, si me toca elegir, prefiero que\nme dejes libre, para poder volver a mi casa.\n—¡No seas chistoso! ¿Te parece que voy a desaprovechar la oportunidad\nde probar un pez tan raro? No se encuentra todos los días un pez marioneta\nen estos mares. Déjame a mí: te freiré en una olla junto con los otros peces,\ny esto será lo mejor para ti. Ser frito en compañía es siempre un consuelo.\nEl infeliz de Pinocho, al oír estas palabras, comenzó a llorar, a chillar, a\nsuplicar, y llorando decía:\n—¿Por qué no fui a la escuela?… He debido hacer caso, y ahora lo estoy\npagando…\nY como forcejeaba al igual que una anguila y hacía esfuerzos increíbles\npor zafarse de las garras del pescador verde, este tomó la corteza de un\njunco y, después de atarlo de pies y manos como un salami, lo echó al fondo\ndel cuenco con los demás.\nEntonces, sacando una taza de madera llena de harina, se puso a\nenharinar todos esos peces y, a medida que los iba enharinando, los echaba\na freír dentro de la olla.\nLos primeros en bailar en el aceite hirviendo fueron las pobres merluzas,\nluego fueron los meros, los mújoles, los lenguados y finalmente las\nanchoas. Entonces fue el turno de Pinocho, que, al verse tan cercano a la\nmuerte (¡y qué horrible muerte!), fue presa de tantos temblores y tuvo tanto\nmiedo, que no tuvo ni voz ni aliento para suplicar.\n¡El pobre niño suplicaba con los ojos! Pero el pescador verde, sin\nsiquiera determinarlo, le dio cinco o seis vueltas en la harina, y quedó tan\nbien cubierto de la cabeza a los pies, que parecía una marioneta de yeso.\nLuego lo tomó de la cabeza y…\nXXIX\nVuelve a la casa del Hada, que le promete que a partir del día siguiente dejará\nde ser una marioneta y se convertirá en un niño. Gran desayuno para festejar\neste gran acontecimiento.\nEn el momento en que el pescador estaba a punto a botar a Pinocho en la\nolla, entró en la gruta un enorme perro que había llegado ahí atraído por el\napetitoso olor de la fritura.\n—¡Vete! —gritó el pescador amenazándolo, con la marioneta enharinada\nen la mano.\nPero el pobre perro tenía un hambre feroz y, gimoteando y meneando la\ncola, parecía decir:\n—Dame un pedazo de fritura y de dejo en paz.\n—¡Vete, te estoy diciendo! —le repitió el pescador y movió la pierna\nhaciendo el gesto de lanzarle una patada.\nEntonces el perro que, cuando tenía hambre de verdad, no estaba\nhabituado a dejarse amedrentar, se puso a ladrar al pescador, mostrándole\nsus terribles colmillos.\nEn cierto punto, se oyó en la gruta una vocecita muy débil que decía:\n—¡Sálvame, Alidoro! ¡Si no me salvas, me fritan!\nEl perro reconoció de inmediato la voz de Pinocho y se percató con gran\nasombro de que la vocecita salía de ese pedazo enharinado que el pescador\ntenía en la mano.\n¿Entonces qué hizo? Dio un gran salto, mordió aquel pedazo enharinado\ny, teniéndolo cuidadosamente entre los dientes, salió de la gruta veloz como\nun relámpago.\nEl pescador, furiosísimo de ver que le arrebataban un pez que se habría\ncomido con gusto, se puso a perseguir al perro, pero después de un tramo le\ndio un acceso de tos y debió volver atrás.\nEntre tanto Alidoro, reencontrando el sendero que lo conducía a la\nciudad, se detuvo y delicadamente puso en el suelo a su amigo Pinocho.\n—¡Cuánto te agradezco! —dijo la marioneta.\n—No hace falta —replicó el perro—: tú me salvaste y yo te lo debía. Ya\nsabes: en este mundo es necesario que nos ayudemos los unos a los otros.\n—¿Pero cómo resultaste en esa gruta?\n—Estuve siempre tirado en esa playa, más muerto que vivo, cuando el\nviento me trajo de lejos un olor a fritura, y este hizo que se me abriera el\napetito, y entonces le seguí la pista. Si hubiera llegado un minuto después…\n—¡Ni lo digas! —gritó Pinocho que temblaba todavía del miedo—. ¡Ni\nlo menciones! Si tú llegas un minuto más tarde, a esta hora estaría bien\nfrito, comido y digerido. Brrrr… ¡Me vienen escalofríos de solo pensarlo!\nAlidoro, riendo, extendió su pata diestra a la marioneta, que se la\nestrechó fuerte fuerte en señal de gran amistad. Y después cada uno cogió\nsu camino.\nEl perro retomó el camino hacia su casa y Pinocho, al quedarse solo, fue\na la cabaña que estaba ahí cerca y le preguntó a un viejo que estaba en la\npuerta calentándose al sol:\n—Dígame, buen hombre, ¿usted sabe algo de un pobre niño herido en la\ncabeza llamado Eugenio?\n—El niño fue traído por unos pescadores a esta cabaña y ahora…\n—¡Ahora está muerto!… —interrumpió Pinocho con inmenso dolor.\n—No: ahora está vivo y ya volvió a su casa.\n—¿De verdad verdad? —gritó la marioneta saltando de la alegría—.\n¿Entonces la herida no era grave?\n—Pero pudo ser gravísima y volverse mortal —respondió el viejo—,\nporque le arrojaron a la cabeza un libro grandísimo encuadernado en cartón.\n—¿Y quién se lo tiró?\n—Un compañero de su escuela, un tal Pinocho.\n—¿Y quién es este Pinocho? —preguntó la marioneta haciéndose la\ndesentendida.\n—Dicen que es un sinvergüenza, un vago, una verdadera pesadilla.\n—¡Calumnias, todas calumnias!\n—¿Tú conoces a este Pinocho?\n—De vista —respondió la marioneta.\n—¿Y tú qué opinas de él? —le preguntó el viejo.\n—A mí me parece un buen hijo, lleno de ganas de estudiar, obediente,\namoroso con su padre y con su familia…\nMientras la marioneta enfilaba una a una todas estas mentiras, se tocó la\nnariz y se dio cuenta de que se le había alargado más de un palmo. Entonces\ntodo asustado comenzó a gritar:\n—No me haga caso, buen hombre, de todo lo que le acabo de decir, pues\nconozco muy bien a Pinocho y le puedo asegurar yo también que es de\nverdad un sinvergüenza, un desobediente y un vagabundo que, en vez de ir\na la escuela, se va con sus compañeros a hacer pilatunas.\nApenas pronunció estas palabras, su nariz se recortó y volvió a su tamaño\nnatural, al que tenía antes.\n—Y, a todas estas, ¿por qué estás completamente blanco? —le preguntó\nde repente el viejo.\n—Le contaré… sin darme cuenta, me he apoyado contra un muro que\nestaba pintado de blanco —respondió la marioneta, avergonzándose de\nconfesar que lo había enharinado como un pez para freírlo en una olla.\n—¿Y qué pasó con tu chaqueta, tus pantalones y tu gorra?\n—Me he encontrado con unos ladrones y me los han quitado. Dime, buen\nhombre, ¿no tendrías por casualidad algo para que me vista, al menos hasta\nque pueda volver a casa?\n—Niño mío, lo único que tengo para que te vistas es la bolsa donde tengo\nlos altramuces. Si lo quieres, tómala, aquí está.\nY Pinocho no hizo que se lo repitiera: cogió la bolsa que estaba vacía y,\ndespués de haber hecho con las tijeras un agujero al fondo y dos huecos a\nlos lados, se lo puso como una camisa. Y así, ligero de ropas, se encaminó\nhacia el pueblo.\nPero en el camino no lograba sentirse tranquilo, hasta el punto de dar un\npaso atrás y uno adelante, pues se decía a sí mismo:\n—¿Cómo haré para presentarme a mi buena Hadita? ¿Qué dirá cuando\nme vea?… ¿Podrá perdonarme esta segunda travesura? Apuesto a que no\nme la perdona: ¡oh, de verdad no me la va a perdonar! Y me lo merezco:\nporque soy un pilluelo que promete corregirme y nunca cumplo.\nArribó a la ciudad cuando ya era de noche y, porque hacía helaje y el\nagua llovía a cántaros, fue directo a la casa del Hada, con la firme\nresolución de tocar a la puerta para que le abrieran.\nPero cuando estuvo ahí le faltó el ánimo y, en vez de tocar, se alejó\ncorriendo unos veinte pasos. Luego volvió una segunda vez a la puerta, y\ntampoco se decidió. Se aproximó una tercera vez, y nada. La cuarta vez\ntomó temblando el aldabón de hierro y dio un suave golpecito.\nEsperó y esperó y finalmente, después de media hora, se abrió una\nventana en el último piso (la casa tenía cuatro pisos) y Pinocho vio\nasomarse un enorme Caracol que tenía una lámpara en la cabeza; este le\ndijo:\n—¿Quién es a esta hora?\n—¿El Hada se encuentra? —preguntó la marioneta.\n—El Hada duerme y no quiere ser despertada. ¿Pero tú quién eres?\n—Soy yo.\n—¿Y quién es «yo»?\n—Pinocho.\n—¿Cuál Pinocho?\n—La marioneta; yo estaba en la casa con el Hada.\n—Ah, ya entiendo —dijo el Caracol—: espérame ahí, que ya bajo y te\nabro.\n—Apúrate, por favor, porque muero del frío.\n—Muchacho, soy un caracol, y los caracoles nunca tenemos prisa.\nPasó una hora, pasaron dos, y la puerta no se abría. Por lo que Pinocho,\nque temblaba del frío, del miedo y del agua que lo empapaba, se resolvió a\ntocar por segunda vez, más fuerte esta vez.\nAl segundo toque, se abrió una ventana del tercer piso y se asomó el\nmismo Caracol.\n—Caracolito mío —gritó Pinocho desde la calle—, hace dos horas que\nespero, y dos horas, con esta noche, parecen más de dos años. Apúrate, por\nfavor.\n—Muchacho —le respondió desde la ventana este bicho toda paz y toda\nflema—, muchacho, soy un caracol, y los caracoles nunca tienen afán.\nY la ventana se cerró.\nPasó un tiempo y llegó la medianoche, luego un toque, luego las dos de\nla mañana, y la puerta siempre cerrada.\nEntonces Pinocho, perdiendo la paciencia, aferró con rabia el aldabón de\nla puerta para tocar de manera que se oyera en toda la casa, pero el batiente,\nque era de hierro, se volvió de repente un anguila viva que, escapándose de\nsus manos, desapareció en un arroyuelo de agua en mitad de la calle.\n—¿Ah, sí? —gritó Pinocho cada vez más cegado por la cólera—. Si el\naldabón huye, seguiré tocando a patadas.\nY dando unos pasos para atrás, mandó una solemne patada en la puerta\nde la casa. El golpe fue tan fuerte, que el pie penetró en la madera hasta la\nmitad. Y cuando la marioneta intentó sacarlo, todos sus esfuerzos fueron en\nvano, porque el pie había quedado incrustado como un clavo remachado.\n¡Imagínense al pobre Pinocho! Debió pasar el resto de la noche con un\npie en el suelo y el otro por el aire.\nFinalmente al alba del día siguiente la puerta se abrió. Ese esforzadísimo\nCaracol, para bajar del cuarto piso al primero, solo tuvo que dedicar nueve\nhoras. Además, hace falta aclarar que además sudó copiosamente.\n—¿Qué hace tu pie ahí clavado en la puerta? —preguntó riendo a la\nmarioneta.\n—Ha sido una desgracia. Mira, Caracolito precioso, te contaré si logras\nliberarme de este suplicio.\n—Niño mío, aquí hace falta un leñador… Y yo no soy una leñadora.\n—Ruégale al Hada de parte mía…\n—El Hada duerme y no le gusta que la despierten.\n—¿Pero qué quieres que yo haga, clavado todo el día en esta puerta?\n—Diviértete contando las hormigas que pasan por el camino.\n—Tráeme al menos algo de comer, porque siento que me voy a desmayar.\n—¡De inmediato! —dijo el Caracol.\nEn efecto, después de tres horas y media, Pinocho lo vio regresar con una\nbandeja de plata en la cabeza. En la bandeja había un pan, un pollo asado y\ncuatro albaricoques maduros.\n—Esta es la comida que te envía el Hada —dijo el Caracol.\nAl ver esas delicias, la marioneta experimentó un gran consuelo. Pero\ncuál fue su desengaño cuando, comenzando a comer, se percató de que el\npan era de yeso, el pollo de cartón y los cuatro albaricoques de alabastro,\npintados como si fueran de verdad.\nQuería llorar, quería abandonarse a la desesperación, quería arrojar la\nbandeja y todo lo que tenía, pero, en vez de esto, sea por el gran dolor o por\nla debilidad, se desmayó.\nCuando recobró la consciencia, se encontró acostado sobre un sofá y el\nHada estaba junto a él.\n—Te perdono también esta vez —le dijo el Hada—, ¡pero te vas a meter\nun problema si vuelves a hacer una de las tuyas!\nPinocho prometió y juró que iba a estudiar y a comportarse debidamente.\nY mantuvo la palabra el resto del año. De hecho, tras los exámenes se ganó\nel honor de ser el mejor de la escuela y sus actitudes, en general, fueron\njuzgadas tan loables, que el Hada toda contenta le dijo:\n—Mañana finalmente tu deseo será satisfecho.\n—¿Cuál?\n—Mañana dejarás de ser una marioneta de palo y te convertirás en un\nniño con todas las de la ley.\nQuien no haya visto la alegría de Pinocho, ante esta noticia tan anhelada,\nnunca podrá imaginársela. Todos sus amigos y compañeros de escuela\nfueron invitados al día siguiente a una gran comida en la casa del Hada,\npara festejar juntos el gran acontecimiento. Y el Hada había hecho preparar\ndoscientas tazas de café con leche y cuatrocientos panes con mantequilla.\nEse día prometía ser maravilloso y alegre, pero…\nDesgraciadamente, en la vida de las marionetas hay siempre un pero que\nlo estropea todo.\nXXX\nPinocho, en vez de convertirse en un niño, se escapa a escondidas con su amigo\nhacia el País de los Juguetes.\nComo es natural, Pinocho le pidió permiso al Hada para ir a la ciudad a\nhacer las invitaciones, y el Hada le dijo:\n—Buen, ve a invitar a tus compañeros a la comida de mañana, pero\nacuérdate de volver a casa antes de que se haga de noche. ¿Entendiste?\n—Prometo estar de regreso en una hora —respondió la marioneta.\n—¡Ten cuidado, Pinocho! Los niños siempre están listos a hacer\npromesas, pero las más de las veces no las saben cumplir.\n—Pero yo no soy como los demás: yo, cuando digo algo, lo cumplo.\n—Ya veremos. En todo caso, si desobedeces, tanto peor para ti.\n—¿Por qué?\n—Porque los niños que no hacen caso a los consejos de quien sabe más\nque ellos siempre les sucede alguna desgracia.\n—¡Ya lo sé! —dijo Pinocho—. Pero no me vuelve a pasar.\n—Ya veremos si dices la verdad.\nSin decir más, la marioneta se despidió de la buena Hada, que era como\nsu mamá, y cantando y bailando atravesó el umbral de la puerta y salió de\ncasa.\nEn poco más de una hora todos sus amigos habían sido invitados.\nAlgunos aceptaron de inmediato y de corazón; otros al principio se hicieron\nde rogar, cuando supieron que el pan para mojar en el café con leche iba a\ntener mantequilla por todos lados, terminaron diciendo: «Sí, iremos para\ndarte gusto».\nAhora es necesario saber que Pinocho, entre sus amigos y compañeros de\nescuela, tenía uno al que quería más y era su preferido; se llamaba Romeo,\npero todos lo llamaban «Pabilo», pues era delgado, enjuto y espigado, tal\ncomo el pabilo nuevo de un velón.\nPabilo era el niño más vago y travieso de toda la escuela, pero Pinocho lo\nquería mucho. De hecho, fue el primero que fue a buscar para invitarlo a la\ncomida, pero no lo encontró. Volvió una segunda vez, y Pabilo no estaba.\nRegresó una tercera vez, e hizo el camino en vano.\n¿Dónde poderlo pescar? Buscó en un lado y en otro, y finalmente lo vio\nescondido en el pórtico de la casa de unos campesinos.\n—¿Qué haces ahí? —le preguntó Pinocho acercándose.\n—Espero la medianoche para partir.\n—¿Adónde vas?\n—Lejos, muy lejos.\n—¡Y yo que he ido a tu casa tres veces!…\n—¿Qué quieres de mí?\n—¿No sabes del gran acontecimiento? ¿No sabes la suerte que tengo?\n—¿Cuál?\n—Mañana dejo de ser una marioneta y me vuelvo un niño como tú y\ncomo los demás.\n—Que te aproveche.\n—Mañana, por esto, espero para que vengas a comer en mi casa.\n—Pero ya te dije que parto esta noche.\n—¿A qué hora?\n—Dentro de poco.\n—¿Y adónde vas?\n—Voy a vivir en un país… que es el país más maravilloso del mundo:\n¡una verdadera dicha!\n—¿Y cómo se llama?\n—Se llama el País de los Juguetes. ¿Por qué no vienes conmigo?\n—No, ¡no puedo!\n—¡Te equivocas, Pinocho! Créeme, si no vienes, te arrepentirás. ¿Dónde\nvas a encontrar un lugar mejor para nosotros los niños? Allí no hay\nescuelas, no hay maestros, no hay libros. En ese país bendito no se estudia\njamás. El jueves no se estudia y cada semana está compuesta de seis jueves\ny un domingo. Imagínate que las vacaciones de otoño comienzan el primero\nde enero y terminan el último día de diciembre. ¡Este es el país que de\nverdad quiero! ¡Así deberían ser todos los países civilizados!\n—¿Pero cómo se pasan los días en ese País de los Juguetes?\n—Se pasan jugando y divirtiéndose de la mañana a la noche. Por la\nnoche te vas a dormir y a la mañana siguiente comienza de nuevo todo.\n¿Qué te parece?\n—¡Uhm! —exclamó Pinocho y meneó ligeramente la cabeza, como\ndiciendo: “Es una vida que querría yo también”.\n—Entonces, ¿quieres venir conmigo? ¿Sí o no? Decídete.\n—No, no, no. Ahora le prometí a mi Hada volverme un niño de bien y\nquiero mantener la promesa. Mejor dicho, como veo que el sol se está\nponiendo, te tengo que dejar, pero te deseo un buen viaje.\n—¿Adónde corres con tanto afán?\n—A mi casa. Mi buena Hada quiere que vuelva antes de que caiga la\nnoche.\n—Espera un par de minutos más.\n—Se me hace muy tarde.\n—Solamente dos minutos.\n—¿Y si después el Hada me regaña?\n—Déjala que te regañe. Cuando te haya regañado lo suficiente, se\ncalmará —dijo ese pilluelo de Pabilo.\n—¿Y cómo vas a hacer? ¿Te vas a ir solo o en compañía?\n—¿Solo? Seremos más de cien niños.\n—Y el viaje, ¿lo hacen a pie?\n—Dentro de poco pasará por aquí un carro que me debe conducir hasta la\nfrontera del aquel país maravilloso.\n—¡Cuánto daría por ver pasar el carro ahora!\n—¿Por qué?\n—Para verlos partir a todos ustedes.\n—Quédate aquí un rato más y nos verás.\n—No: quiero volver a casa.\n—Espera un par de minutos más.\n—Me he demorado demasiado. El Hada debe estar preocupada por mí.\n—¡Pobre Hada! ¡Debe pensar que te han comido los murciélagos!\n—Pero entonces —añadió Pinocho—, ¿de verdad estás seguro de que en\nese país no hay escuelas?\n—Ni una sola.\n—¿Ni tampoco maestros?\n—Ni siquiera uno.\n—¿Y no hay ninguna obligación de estudiar?\n—Ninguna en absoluto.\n—¡Qué bello lugar! —dijo Pinocho, que ya se empezaba a ilusionar—.\n¡Qué bien suena! Nunca he estado, pero ya me lo imagino.\n—¿Por qué no vienes tú?\n—Es inútil que me tientes. Ya prometí a mi buena Hada volverme un\nniño juicioso y no quiero faltar a mi palabra.\n—Entonces adiós y salúdame a los de primaria y a los de bachillerato…\nsi te los encuentras por ahí.\n—Adiós, Pabilo: que tengas buen viaje, diviértete y acuérdate de vez en\ncuando de tus amigos.\nDicho esto, la marioneta dio dos pasos reanudando su camino, pero\nentonces, deteniéndose y volviéndose hacia su amigo, le preguntó:\n—¿Pero estás completamente seguro de que en ese lugar todas las\nsemanas tienen seis jueves y un domingo?\n—¡Segurísimo!\n—¿Y en serio las vacaciones principian el primero de enero y terminan el\núltimo día de diciembre?\n—¡No hay duda!\n—¡Qué hermoso lugar! —repitió Pinocho, escupiendo con gran\nsatisfacción. Luego, con ánimo resuelto, añadió de afán: —Entonces, adiós\nde verdad, y buen viaje.\n—Adiós.\n—¿Dentro de cuánto partirán?\n—Dentro de poco.\n—¡Qué lástima! Si solo faltara una hora, podría esperar.\n—¿Y el Hada?…\n—Ya voy tarde… y volver a casa una hora antes o una hora después va a\nser lo mismo.\n—¡Pobre Pinocho! ¿Y si el Hada te regaña?\n—Está bien: la dejaré que me regañe. Cuando me haya regañado lo\nsuficiente, se calmará.\nEntre tanto ya se había hecho noche y había oscurecido. Pero en cierto\nmomento vieron moverse a lo lejos una lucecita y les llegó un sonido de\ncascabeles y un toque de trompeta, tan agudo y sofocado que parecía el\nsilbido de un zancudo.\n—¡Helo aquí! —gritó Pabilo, parándose inmediatamente.\n—¿Qué? —preguntó en voz baja Pinocho.\n—Es el carro, que viene a llevarme. Entonces, ¿quieres venir o no?\n—¿Pero es verdad —preguntó la marioneta— que en aquel país los niños\nno tienen nunca la obligación de estudiar?\n—¡Nunca, nunca jamás!\n—¡Qué hermoso lugar, qué hermoso, qué maravilla!\nXXXI\nPinocho, en vez de convertirse en un niño, se va con su amigo Pabilo al País de\nlos Juguetes.\nFinalmente el carro llegó y lo hizo sin hacer el más mínimo ruido, porque\nsus ruedas estaban hechas de estopa y andrajos.\nLo tiraban doce parejas de burritos, todos del mismo tamaño, pero de\ndiverso pelaje.\nEran pardos, o blancos, o entrecanos, o de grandes rayas amarillas y\nturquesa.\nPero el aspecto más singular era el siguiente: que estas doce parejas, es\ndecir estos veinticuatro burritos, en vez de estar herrados como suelen\nestarlo las bestias de tiro, tenían en las patas unas botinas de hombre hechas\ncon cuero blanco.\n¿Y el conductor del carro?\nImagínense un hombre más ancho que alto, tierno y untuoso como una\nbola de mantequilla, con una carita de pomarrosa, una boquita que reía\nsiempre y una voz meliflua y sutil, como la de un gato que trata de ganarse\nlos favores de la dueña de la casa.\nTodos los niños, apenas lo veían, quedaban encantados y hacían\ncompetencia para montarse en su carro y ser conducidos por él hacia esa\nbuena vida conocida en la carta geográfica con el seductor nombre del País\nde los Juguetes.\nDe hecho, el carro ya estaba lleno de niños entre los ocho y los doce\naños, montados unos sobre los otros como anchoas enlatadas. Estaban mal,\nestaban embutidos, no podían casi respirar, pero ninguno decía nada, nadie\nse lamentaba. El consuelo de saber que en pocas horas llegarían a ese sitio\ndonde no había libros, ni escuelas, ni maestros los ponía tan felices, y a la\nvez tan resignados, que no sentían ni las incomodidades, ni el cansancio, ni\nel hambre, ni la sed, ni el sueño.\nApenas el carro se detuvo, el Hombrecito se volvió hacia Pabilo y, con\nmil muecas y de mil maneras, le preguntó sonriendo:\n—Dime, querido niño mío, ¿quieres venir tú también a este dichoso país?\n—Claro que quiero ir.\n—Pero te advierto, querido mío, que en el carro ya no hay puesto. Como\nves, está repleto.\n—¡Está bien! —respondió Pabilo—, si no hay puesto adentro, me\nacomodaré aquí sentado en las varales del carro.\nY dando un salto, se montó a horcajadas en los varales.\n—Y tú, precioso —dijo el Hombrecito mostrándose más obsequioso—,\n¿qué vas a hacer? ¿Vienes con nosotros o te quedas?\n—Yo me quedo —respondió Pinocho—. Quiero volver a mi casa: quiero\nestudiar y ganarme los honores de la escuela, como hacen todos los niños\nbuenos.\n—¡Que te aproveche!\n—¡Pinocho! —dice entonces Pabilo—, hazme caso: ven conmigo y te\naseguro que la vamos a pasar bien.\n—¡No, no, no!\n—Ven, la vamos a pasar bien —gritaron al tiempo un centenar de voces\ndesde dentro del carro.\n—Y si voy con ustedes, ¿qué le diré a mi buena Hada? —dijo la\nmarioneta que comenzaba a titubear y a dar su brazo a torcer.\n—No te llenes la cabeza con melancolías. Piensa que vamos a un lugar\ndonde tendremos de hacer alboroto de la mañana a la noche.\nPinocho no respondió, pero dejó escapar un suspiro; luego, otro suspiro;\nhubo un tercer suspiro, y finalmente dijo:\n—Ábranme lugar: yo también quiero ir.\n—No hay puesto —replicó el Hombrecito—, pero para mostrarte cuán\ncomplacidos estamos de que vengas, puedo cederte mi puesto en el\npescante.Yo haré el camino a pie.\n—No, no puedo permitirlo. Prefiero entonces subirme en la grupa de\nalguno de estos burritos —gritó Pinocho.\nDicho y hecho: se acercó al burrito derecho dela primera pareja e hizo el\ngesto de quererlo cabalgar; pero la bestia, volviéndose en seco, le dio un\ngran hocicazo en el estómago y lo arrojó volando por el aire.\nImagínense la risotada impertinente y desquiciada de todos esos niños\nque presenciaron la escena.\nPero el Hombrecito no se rio. Se aproximó amorosísimo al burrito\nrebelde y, haciendo el gesto de darle un beso, le arrancó con un mordisco la\nmitad de la oreja derecha.\nMientras tanto Pinocho, poniéndose de pie enfurecido, se impulsó y de\nun salto se montó en la grupa del pobre animal. Y fue un salto tan hermoso\nque los niños, dejando de reír, comenzaron a exclamar: «Viva Pinocho» y a\ndesgranar aplausos que nunca se acababan.\nPero de repente el burrito alzó las dos patas traseras y, dando un fortísima\nsacudida, arrojó a la pobre marioneta a la mitad de la calle sobre un montón\nde grava.\nEntonces todos se desternillaron de risa, pero el Hombrecito, en vez de\nreír, se sintió poseído de gran amor por el inquieto burrito, al que, con un\nbeso, le quitó la mitad de la otra oreja. Luego le dijo a la marioneta:\n—Vuelve a montar, sin miedo. Este burrito tenía un grillo en la cabeza.\nPero le he dicho un par de palabritas y espero así haberlo amansado y\nvuelto razonable.\nPinocho se montó y el carro comenzó a moverse, pero en el momento en\nque los burritos galopaban y el carro corría sobre el empedrado del camino\nprincipal, le pareció a la marioneta oír una voz queda y apenas inteligible\nque le dijo:\n—Pobre bobalicón, has querido hacer lo que te da la gana, pero te\narrepentirás.\nPinocho, un poco asustado, miró hacia aquí y hacia allá intentando\ndescifrar de dónde venía la voz, pero no vio a nadie: los burritos galopaban,\nel carro andaba, los niños dormían en el carro, Pabilo roncaba como un\nlirón y el Hombrecito, sentando en el pescante, canturreaba entre dientes:\nTodos por la noche duermen,\ny yo no duermo jamás…\nLuego de medio kilómetro, Pinocho oyó la misma vocecita débil que le\ndijo:\n—¡Tenlo en mente, tontarrón! Los niños que dejan de estudiar y les dan\nla espalda a los libros, a las escuelas y a los maestros, para dedicarse\nenteramente a los juegos y a las diversiones, no les queda otra que acabar\nmal… Yo lo sé por experiencia… y te lo puedo decir. Vendrá un día en que\nllorarás tú también, como hoy lloro yo… pero entonces será tarde.\nA estas palabras susurradas quedamente, la marioneta, asustada más que\nnunca, saltó de la grupa y fue a tomar a su burro por el hocico.\nE imagínense cómo quedó cuando se dio cuenta de que su burro\nlloraba… ¡y lloraba como un niño!\n—Ey, señor —gritó entonces Pinocho al dueño del carro—, ¿sabe qué\nestá pasando? Este burro llora.\n—Déjalo llorar: ya reirá cuando sea el momento.\n—¿Pero acaso usted le ha enseñado a hablar?\n—No, ha aprendido él solo a mascullar algunas palabras, tras haber\nestado tres años en una compañía de perros amaestrados.\n—¡Pobre bestia!\n—Vamos, vamos —dijo el Hombrecito—, no perdamos nuestro tiempo\nviendo llorar un burro. Vuélvete a montar y vamos: la noche está fresca y el\ncamino es largo.\nPinocho obedeció sin chistar. El carro reanudó su carrera y, a la mañana\nsiguiente, al alba, arribaron felizmente al País de los Juguetes.\nEste país no se parecía a ningún otro país del mundo. Su población estaba\ntoda compuesta por niños. Los más viejos tenían catorce años, los más\njóvenes apenas ocho. ¡En las calles reinaba una alegría, un barullo, una\ngritería para enloquecerse! Pandillas de traviesos por todo lado: estaban los\nque jugaban con las canicas, al tejo o con una pelota; otros iban en bicicleta\no se balanceaban montados en un caballo de madera; estos jugaban a la\ngallina ciega, esos se perseguían, otros, vestidos de payasos, echaban fuego\npor la boca; unos actuaban, o cantaban, o hacían saltos mortales, o se\ndivertían caminando con las manos en el suelo y los pies por el aire; había\nquienes jugaban con el aro, quien se paseaba vestido de general con el\ncasco de papel y un escuadrón de cartón; niños que reían, gritaban,\nllamaban, batían las manos, fisgoneaban, imitaban a las gallinas al poner un\nhuevo. En suma, era tal el pandemonio, el batiburrillo, el alboroto\ndesenfrenado, que era necesario meterse algodón en los oídos para no\nquedarse sordo. En todas las plazas se veían teatrinos de tela, poblados de\nniños de la mañana a la noche, y en todos los muros de las casas se leían,\nescritas con carbón, frases del siguiente tenor: «Vivan los jugetes» (en vez\nde «juguetes»), «No queremos más hescuelas» (en vez de «escuelas»),\n«Abajo Larin Metica» (en vez de «la aritmética») y otras perlas similares.\nPinocho, Pabilo y todos los demás niños que habían hecho el viaje con el\nHombrecito, apenas pusieron pie en la ciudad, se fijaron de inmediato en la\ngran barahúnda y, en pocos minutos, como es fácil\nimaginárselo, se volvieron amigos de todos. ¿Cuál era el más contento, cuál\nel más feliz de todos?\nEn medio de las inagotables diversiones y continuos esparcimientos, las\nhoras, los días y las semanas pasaban como relámpagos.\n—¡Oh, qué gran vida! —decía Pinocho todas las veces que por\ncasualidad se topaba con Pabilo.\n—¿Ves que tenía razón? —replicaba este último—. ¡Y pensar que tú no\nquerías venir! ¡Y pensar que se te había metido en la cabeza volver a la casa\nde tu Hada, para perder el tiempo estudiando!… Si hoy te has liberado del\nfastidio de los libros y de las escuelas, me lo debes a mí, a mis consejos, a\nmis favores, ¿no crees? Los verdaderos amigos son los que te hacen estas\ngrandes atenciones.\n—Es verdad, Pabilo. Si hoy soy un niño absolutamente contento, es\ngracias a ti. ¿Y sabes qué me decía el maestro de ti? Me decía siempre: «No\nhagas lo que hace ese travieso de Pabilo; Pabilo es una mala compañía y no\npodría aconsejarte nada distinto de hacer el mal».\n—¡Pobre maestro! —replicó el otro, meneando la cabeza—. Sé por\ndesgracia que me tenía tirria y que se divertía calumniándome. Pero yo soy\ngeneroso y lo perdono.\n—¡Gran corazón! —dijo Pinocho, abrazando afectuosamente al amigo y\ndándole un beso en medio de los ojos.\nY así ya eran cinco meses que duraba esta dicha de divertirse y jugar los\ndías enteros, sin ver un solo libro ni una escuela, cuando Pinocho,\ndespertándose, tuvo, como se suele decir, una desagradable sorpresa, que lo\npuso de inmediato de mal humor.\nXXXII\nA Pinocho le salen orejas de burro y entonces se convierte en un burro de verdad\ny comienza a rebuznar.\n¿Y esta sorpresa cuál fue?\nSe lo diré, mis queridos y pequeños lectores: la sorpresa fue que Pinocho,\ndespertándose, espontáneamente le da por rascarse la cabeza, y al rascarse\nse da cuenta de…\n¿Adivinen de qué se da cuenta?\nSe da cuenta, con grandísimo asombro, de que las orejas le habían\ncrecido más de un palmo.\nUstedes saben que la marioneta, desde su nacimiento, tenía las orejas\nchiquitas chiquitas, tanto que a simple vista ni siquiera se veían. Imagínense\ncómo quedó cuando se dio cuenta de que sus orejas, durante la noche,\nestaban tan largas como dos escobillas.\nFue rápido a buscar un espejo, para poderse ver, pero, al no encontrar un\nespejo, llenó de agua una palangana y, viendo su reflejo, vio lo que nunca\ndebió haber visto: vio su imagen embellecida por un magnífico par de\norejas de burro.\nDejo a ustedes que imaginen el dolor, la vergüenza y la desesperación del\npobre Pinocho.\nComenzó a llorar, a chillar, a darle cabezazos a la pared, pero cuanto más\nse desesperaba, más sus orejas crecían y se volvían peludas hacia las\npuntas.\nAl sonido de esos gritos agudísimos, entró en la habitación una hermosa\nMarmotica que vivía en el piso de arriba, la cual, viendo a la marioneta en\ntal agitación, le preguntó afanosamente:\n—¿Qué sucede, mi querido vecino?\n—Estoy enfermo, Marmotica mía, muy enfermo… y enfermo de un\npadecimiento que me da miedo. ¿Tú sabes tomar el pulso?\n—Un poquito.\n—Mira entonces si por casualidad tengo fiebre.\nLa Marmotica alzó la pata derecha y, después de haber palpado el pulso a\nPinocho, le dijo suspirando:\n—Amigo mío, lamento darte una mala noticia.\n—¿Cuál?\n—Tienes una fiebre muy fea.\n—¿Y qué fiebre es esa?\n—La fiebre del burro.\n—No sé cuál es esta fiebre —respondió la marioneta, que por desgracia\nla estaba sufriendo.\n—Ya te explico —añadió la Marmotica—. Debes saber que dentro de dos\no tres horas no serás ya una marioneta ni tampoco un niño…\n—¿Y qué seré entonces?\n—Dentro de dos o tres horas te convertirás en un burrito hecho y\nderecho, como los que tiran la carreta y llevan las coles y las lechugas al\nmercado.\n—¡Oh, pobre, pobre de mí! —gritó Pinocho cogiéndose con las manos\nlas dos orejas, y jalándoselas y tratándoselas de arrancar como si fuesen las\norejas de otro.\n—Querido mío —replicó la Marmotica para consolarlo—, ¿qué quieres\nhacer ahora? Este es tu destino. Esto estaba escrito en los decretos de la\nsabiduría: todos los niños vagos que se aburren con los libros, las escuelas y\nlos maestros y pasan sus días entre juguetes y diversiones terminan tarde o\ntemprano transformados en pequeños burros.\n—¿De verdad es siempre así? —preguntó sollozando la marioneta.\n—Por desgracia es así. Y ahora las lágrimas son inútiles. ¡Era necesario\npensarlo antes!\n—Pero la culpa no es mía: la culpa, créelo, Marmotica, es toda de Pabilo.\n—¿Y quién es este Pabilo?\n—Un compañero mío de la escuela. Yo quería volver a casa, quería ser\nobediente, quería seguir estudiando, ser aplicado… pero Pabilo me dijo:\n«¿Por qué quieres aburrirte estudiando? ¿Para qué quieres ir a la escuela?\nMás bien ven conmigo, al País de los Juguetes: allí no estudiaremos, allí\nnos divertiremos de la mañana a la noche y viviremos siempre alegres».\n—¿Y por qué seguiste el consejo de ese falso amigo, de ese mal\ncompañero?\n—¿Por qué? Porque, Marmotica mía, soy una marioneta sin juicio… y\nsin corazón. Oh, si hubiera tenido una pizca de corazón, nunca habría\nabandonado a la buena Hada, que me quería como una madre y que había\nhecho tanto por mí… Y a esta hora no sería una marioneta, sino un niño de\nbien como tantos. Pero si me llego a encontrar a Pabilo, ¡que se tenga! Le\nvoy a poner los puntos sobre las íes.\nE hizo el gesto de querer salir. Pero cuando estaba en la puerta, se acordó\nde que tenía orejas de burro y, avergonzándose de mostrarlas en público,\n¿qué se le ocurrió? Tomó una gran gorra de algodón y, poniéndosela en la\ncabeza, se la caló hasta la nariz.\nLuego salió y se puso a buscar a Pabilo por todos lados. Lo buscó en las\ncalles, en las plazas, en los teatrinos, en todas partes, pero no lo encontró.\nPreguntó por él a todos los que se encontraba, pero nadie lo había visto.\nEntonces fue a buscarlo a su casa y, al llegar a la puerta, tocó.\n—¿Quién es? —preguntó Pabilo, desde dentro.\n—Soy yo —respondió la marioneta.\n—Espera un momento, ya te abro.\nDespués de media hora la puerta se abrió e imagínense cómo quedó\nPinocho al entrar a la sala y ver a su amigo Pabilo con un gran gorro en la\ncabeza, encasquetado hasta la nariz.\nAl ver ese gorro, Pinocho casi sintió consuelo y pensó en ese instante\npara sí: «¿Será que mi amigo sufre la misma enfermedad que yo tengo?\n¿Tendrá la fiebre del burro?».\nY fingiendo no darse cuenta de nada, le preguntó sonriendo:\n—¿Cómo estás, querido Pabilo?\n—Muy bien: como un ratón dentro de un queso parmesano.\n—¿Lo dices en serio?\n—¿Y por qué habría de mentirte?\n—Discúlpame, amigo: ¿y entonces por qué tienes en la cabeza ese gorro\nde algodón que te cubre hasta las orejas?\n—Me lo ha recetado el médico, porque me pegué en esta rodilla. Y tú,\nquerida marioneta, ¿por qué llevas ese gorro de algodón encasquetado hasta\nla nariz?\n—Me lo ha recetado el médico, porque me duele este pie.\n—¡Oh, pobre Pinocho!\n—¡Oh, pobre Pabilo!\nA estas palabras siguió un larguísimo silencio, durante el cual los dos\namigos no hicieron más que observarse el uno al otro en plan de burla.\nFinalmente la marioneta, con una vocecita meliflua y aflautada, le dijo a\nsu compañero.\n—Sácame de una duda, mi querido Pabilo: ¿has tenido alguna\nenfermedad en las orejas?\n—¡Nunca! ¿Y tú?\n—¡Nunca! Pero desde esta mañana siento rasquiña en una oreja.\n—A mí me pasa lo mismo.\n—¿También a ti?… ¿Y cuál es la oreja que te molesta?\n—Las dos. ¿Y a ti?\n—Las dos. ¿Será la misma enfermedad?\n—Me temo que sí.\n—¿Quieres hacerme un favor, Pabilo?\n—¡Con gusto! ¡De todo corazón!\n—¿Me dejas ver tus orejas?\n—¿Por qué no? Pero primero quiero ver las tuyas, querido Pinocho.\n—No, primero muéstramelas tú.\n—No, querido. Primero tú y después yo.\n—Está bien —dice entonces la marioneta—, hagamos un pacto de\nbuenos amigos.\n—Te oigo.\n—Levantemos los dos el gorro al mismo tiempo, ¿te parece?\n—Sí, me parece.\n—Entonces, pon atención —y Pinocho comenzó a contar en voz alta—:\n¡uno!… ¡dos!… ¡tres!\nA la palabra de tres, los dos niños tomaron sus gorros de la cabeza y los\nlanzaron al aire.\nY entonces sucedió algo increíble, si no hubiera pasado de verdad.\nSucedió que Pinocho y Pabilo, cuando se vieron víctimas de la misma\ndesgracia, en vez de mortificarse y lamentarse, comenzaron a acariciarse\nsus orejas desmesuradamente grandes y, después de mil monerías, acabaron\nsoltando una sonora carcajada.\nY siguieron riendo tanto que no podían mantenerse en pie, hasta que, en\nel momento de mayor alborozo, Pabilo de repente se calló y, tambaleándose\ny cambiando de color, le dijo a su amigo:\n—¡Ayuda, ayuda, Pinocho!\n—¿Qué pasa?\n—Ay, no logro pararme en las dos piernas.\n—Yo tampoco puedo —gritó Pinocho gimiendo y bamboleándose.\nY mientras hablaban así, quedaron a gatas y, caminando con las manos y\ncon los pies, comenzaron a dar vueltas por la habitación. Y, al tiempo que\ncorrían, sus brazos se convirtieron en patas, sus caras se alargaron y se\nvolvieron hocicos y sus espaldas se cubrieron con un pelaje grisáceo,\nmanchado de negro.\n¿Pero saben cuál fue el momento más feo para estos dos desdichados? El\nmomento más feo y más humillante fue cuando les empezó a salir por\ndetrás una cola. Vencidos ahora por la vergüenza y el dolor, intentaron\nllorar y quejarse por su destino.\n¡Ojalá nunca lo hubieran hecho! En vez de gemidos y lamentos, salieron\nrebuznos de burro, y rebuznando sonoramente hacían los dos en coro:\n—Ijá, ijá, ijá.\nEn ese momento tocaron a la puerta y una voz de afuera dijo:\n—¡Abran! Soy el Hombrecito, soy el conductor del carro que los trajo a\neste país. ¡Abran ya o se van a meter en problemas!\nXXXIII\nConvertido en un burro de verdad, lo llevan a una venta donde lo compra el\ndirector de una compañía de payasos, el cual quiere enseñarle a bailar y a saltar\nobstáculos. Pero una noche empieza a cojear y entonces lo compra otro para\nhacer con su piel un tambor.\nViendo que la puerta no se abría, el Hombrecito la abrió con una\nviolentísima patada y, luego de entrar en la sala, dijo con su habitual risita a\nPinocho y a Pabilo:\n—¡Muy bien, niños! Han rebuznado bien; los he reconocido al instante.\nVengan acá.\nAl oír estas palabras los dos burritos se sintieron abatidos, cabizbajos;\ntenían las orejas abajo y la cola entre las patas.\nDesde el principio, el Hombrecito los sobó, los acarició, los palpó; luego,\nsacó un peine y comenzó a peinarlos muy bien.\nY cuando de tanto peinarlos los dejó lustrosos como dos espejos, les puso\nel cabestro y los condujo a la plaza de mercado, con la esperanza de\nvenderlos y obtener así alguna ganancia.\nY los compradores, de hecho, no se hicieron esperar.\nPabilo fue comprado por un campesino a quien se le había muerto el\nburro el día anterior y Pinocho fue vendido al director de una compañía de\npayasos y saltadores de cuerda, el cual lo compró para amaestrarlo y así\nponerlo a saltar y bailar junto con las otras bestias de la compañía.\n¿Ya entendieron, mis queridos lectores, cuál era el trabajo al que se\ndedicaba el Hombrecito? Este horrible monstruo, que parecía dulce como la\nmiel, iba cada tanto con un carro a dar vueltas por el mundo y recogía con\npromesas y con halagos a todos los niños vagabundos que se aburrían de los\nlibros y las escuelas y, después de haberlos subido en su carro, los conducía\nal País de los Juguetes, para que se la pasaran jugando, alborotando y\ndivirtiéndose. Más tarde, cuando esos pobres niños ingenuos, a punta de\njugar siempre y no estudiar jamás, se volvían burros, él entonces muy\ncontento se los adueñaba y los llevaba a vender a las ferias y al mercado. Y\nasí, en pocos años, había logrado hacerse una considerable fortuna.\nEso que le sucedió a Pabilo, no lo sé; por otro lado, sé que Pinocho tuvo\ndesde los primeros días una vida durísima y agotadora.\nCuando fue conducido al establo, el nuevo dueño le llenó el pesebre de\npaja, pero Pinocho, después de haber probado un bocado, la escupió.\nEntonces el dueño, refunfuñando, le llenó el pesebre de heno, pero\ntampoco el heno le gustó.\n—Ah, ¿no te gusta tampoco el heno? —gritó el dueño enfurecido—.\nDéjame a mí, hermoso burrito, que si tienes caprichos, ya sabré como\nquitártelos.\nY, para corregirlo, le propinó un latigazo entre las patas.\nPinocho, del gran dolor, comenzó a llorar y a rebuznar, y rebuznando\ndijo:\n—Ijá, ijá, no puedo digerir la paja.\n—Entonces cómete el heno —replicó el dueño, que entendía\nperfectamente la lengua de los burros.\n—Ijá, ijá, el heno hace que me duela el cuerpo.\n—¿Pretenderás entonces que alimente a un burro como tú a punta de\npechugas de pollo y galantina de pollo —agregó el dueño cada vez más\nairado y asestándole un segundo latigazo.\nTras este segundo latigazo Pinocho, por prudencia, se quedó callado y no\nvolvió a musitar palabra.\nCerraron el establo y Pinocho quedó solo y, como ya llevaba varias horas\nsin haber comido, comenzó a bostezar por el hambre y, al bostezar, abría la\nboca como si fuera un horno.\nAl final, no habiendo nada más en el pesebre, se resignó a masticar un\npoco de heno y, después de haberlo masticado bien, cerró los ojos y se lo\ntragó.\n«Este heno no está mal —dijo para sí—, pero, ay, si hubiera seguido\nestudiando… A esta hora, en vez de heno, podría comer un pedazo de pan\nfresco y un buen trozo de salami. ¡Qué se le va hacer!…».\nA la mañana siguiente, despertándose, buscó en el pesebre otro poco de\nheno, pero no lo encontró, porque se lo había comido todo por la noche.\nEntonces tomó un bocado de paja picada, pero en el momento en que la\nmasticaba, se dio cuenta de que el sabor de la paja no se parecía en nada al\nrisotto a la milanesa ni a los macarrones a la napolitana.\n—¡Qué se le va a hacer! —repitió, sin dejar de masticar—… Que al\nmenos mi desgracia pueda servir de lección a todos los niños desobedientes\ny que no tienen ganas de estudiar… ¡Qué se le va a hacer!\n—¡Ya basta! —gritó el dueño, entrando en ese momento en el establo—.\n¿Crees acaso, mi querido burrito, que yo te compré únicamente para darte\nde comer y de beber? Te compré para que trabajes y me hagas ganar un\nbuen dinero. ¡Párate, no te quedes ahí! Ven conmigo al circo y allá te\nenseñaré a saltar los obstáculos, a romper con la cabeza toneles de cartón y\na bailar el vals y la polca parado en las patas traseras.\nEl pobre Pinocho, por amor o por fuerza, debió aprender todas estas\ncosas, pero, para aprenderlas, fueron necesarios trece meses de clases y\nmuchos latigazos que lo dejaron pelado.\nLlegó finalmente el día en que su dueño pudo anunciar un espectáculo\nverdaderamente extraordinario. Los carteles de varios colores, pegados en\nlas esquinas, decían así:\nGRAN ESPECTÁCULO DE GALA\nPor esta noche\nTENDRÁN LUGAR LOS HABITUALES SALTOS\nY SORPRENDENTES EJERCICIOS\nrealizados por todos los artistas\ny todos los caballos de la compañía\ny además\nSERÁ PRESENTADO POR PRIMERA VEZ\nel famoso\nBURRO PINOCHO\ndenominado\nLA ESTRELLA DEL BAILE\nEl teatro estará iluminado\ncomo si fuera de día\nEsa noche, como pueden imaginárselo, una hora antes de que comenzara\nel espectáculo, el teatro estaba lleno a reventar.\nNo había ni un solo puesto libre, ni una silla sin ocupante, ni un palco\nvacío, ni siquiera pagándolos a precio de oro.\nLas gradas del circo hormigueaban de niños y niñas de todas las edades,\nque estaban ansiosos por ver bailar al famoso burro Pinocho.\nAl finalizar la primera parte del espectáculo, el Director de la compañía,\nvestido con un saco negro, pantalones blancos y botas de piel que le\nllegaban más arriba de las rodillas, se presentó al nutridísimo público y,\nhaciendo una gran venia, inició con gran solemnidad este delirante discurso:\n—¡Respetable público, damas y caballeros!\n“Este humilde servidor, estando de paso por esta ilustre metrópoli, ha\nquerido tener el honor, qué digo, el placer de presentar a este inteligente y\nconspicuo auditorio un célebre burro que tuvo ya el honor de bailar ante la\npresencia de Su Majestad el Emperador, en las principales cortes de Europa.\n«Y dándoles las gracias a todo ustedes, les pido que nos ayuden con su\nmagnífica y animada concurrencia».\nEste discurso estuvo acompañado por muchas carcajadas y aplausos, pero\nlos aplausos se redoblaron y se convirtieron en una suerte de huracán ante la\naparición del burro Pinocho en mitad de la pista del circo. Estaba\nengalanado como para una fiesta. Tenía unas riendas nuevas de piel\nbrillante, con broches y botones de latón, dos camelias blancas en las orejas,\nla crin dividida en muchos flecos atados con lazos de seda roja, una gran\nfaja de oro y plata alrededor del estómago, y la cola toda trenzada con\ncintas de terciopelo carmesí y azul celeste. Era, en suma, un burrito\nadorable.\nEl Director, al presentarlo al público, añadió estas pocas palabras:\n—¡Mi respetable público! No estoy aquí para mentirles sobre las grandes\ndificultades que he debido enfrentar para comprender y someter a este\nmamífero, mientras pacía libre de montaña en montaña en las llanuras\ntórridas. Observen, les pido, cuánto salvajismo traslucen sus ojos, por lo\nque, siendo vanos todos los métodos para domesticarlo al modo de los\ncuadrúpedos civilizados, he debido recurrir con frecuencia al afable dialecto\ndel azote. Pero con cada gentileza mía, en vez de hacerme querer por él, me\nhe granjeado su animadversión. No obstante yo, siguiendo el sistema de\nGales, encontré en su cráneo una diminuta Cartago ósea que la misma\nFacultad de Medicina de París reconoció como el bulbo regenerador del\npelo y de la danza pírrica. Y por esto quise amaestrarlo en el baile, además\nde para el salto de obstáculos y de los toneles de cartón. ¡Admírenlo y\ndespués júzguenlo! Pero antes de despedirme de ustedes, permítanme,\nseñoras y señores, invitarlos al espectáculo de mañana por la noche; en caso\nde que el día amenace lluvia, el espectáculo, en vez de mañana por la\nnoche, se pospondrá hasta la mañana siguiente, a las once de la mañana de\nese día.\nY el Director hizo otra ampulosísima reverencia y, volviéndose hacia\nPinocho, le dijo:\n—¡Vamos, Pinocho! Antes de dar principio a sus rutinas, ¡saluda a este\nrespetable público, caballeros, damas y niños!\nPinocho, obediente, dobló las dos rodillas de adelante sobre el suelo y se\nmantuvo arrodillado hasta que el Director, restañando el látigo, no le gritó:\n—¡Al paso!\nEntonces el burrito se paró sobre las cuatro patas y comenzó a girar\nalrededor de la pista, caminando siempre al paso.\nDespués de un rato el Director gritó:\n—¡Al trote!\nY Pinocho, obediente a la orden, emprendió el trote.\n—¡Al galope!\nY Pinocho arrancó a galopar.\n—¡A la carrera! —y Pinocho se puso a correr velozmente. Pero en el\nmomento en que corría como un caballo bereber, el Director, alzando el\nbrazo en el aire, dio un pistoletazo.\nAl instante el burro, fingiéndose herido, cayó y quedó acostado en la\npista, como si fuera un moribundo de verdad.\nParándose del suelo en medio de una salva de aplausos, gritos y palmadas\nque llegaban a las estrellas, se le ocurrió alzar la cabeza y, entonces, vio en\nun palco a una bella señora que lucía un collar de oro, del cual pendía un\nmedallón. En el medallón estaba pintado el retrato de una marioneta.\n«¡Ese es mi retrato!… ¡Esa señora es el Hada!», dijo para sí,\nreconociéndola de inmediato. Y dejándose vencer por una gran alegría,\nintentó gritar:\n—¡Oh, Hadita, Hadita mía!\nPero, en vez de estas palabras, le salió de la garganta un rebuzno tan\nsonoro y prolongado que hizo reír a todos los espectadores y especialmente\na los niños que estaban en el teatro.\nEntonces el Director, para enseñarle y hacerle entender que no es de\nbuena educación ponerse a rebuznar frente al público, le dio con el mango\ndel látigo un baquetazo en el hocico.\nEl pobre burrito, sacando su lengua un palmo, se puso a lamerse el\nhocico por lo menos cinco minutos, creyendo que así iba a aliviar el dolor\nque sentía.\nPero cuál no sería su desesperación cuando, volviéndose a ver una\nsegunda vez, vio que el palco estaba vacío y que el Hada había\ndesaparecido…\nSintió que se moría: los ojos se le llenaron de lágrimas y comenzó a\nllorar desconsoladamente. Sin embargo nadie se dio cuenta y, mucho\nmenos, el Director, el cual restañando el látigo le dijo:\n—¡Sé bueno, Pinocho! Ahora muéstrales a estos señores con qué gracia\nsabes saltar los aros.\nPinocho lo intentó dos o tres veces, pero cada vez que se aproximaba al\naro, en vez de superarlo, pasaba cómodamente por abajo. Al final dio un\nsalto y pasó a través de él, pero las patas de atrás se le quedaron enredadas\nen el aro, y cayó al otro lado de frente contra el suelo.\nCuando se levantó estaba cojo y, con gran esfuerzo, pudo regresar a la\ncuadra.\n—¡Que salga Pinocho! ¡Queremos al burro! ¡Que salga el burrito! —\ngritaban los niños de la platea, conmovidos por el triste incidente.\nPero el burrito esa noche no se volvió a dejar ver.\nA la mañana siguiente el veterinario, es decir el médico de las bestias,\ncuando lo visitó declaró que había quedado cojo para toda la vida.\nEntonces el Director dijo a su mozo de cuadra:\n—¿Qué quieres que haga con un burrito cojo? Se la pasaría tragando\ngratis. Llévalo a la plaza y revéndelo.\nAl llegar a la plaza, encontraron rápidamente un comprador, que le\npreguntó al mozo de cuadra:\n—¿Cuánto quieres por este burrito cojo?\n—Veinte liras.\n—Te doy veinte sueldos. No creas que lo compro porque me resulte útil:\nlo compro únicamente por la piel. Veo que tiene la piel bastante dura, con la\nque quisiera hacerme un tambor para la banda musical de mi país.\nDejo que se imaginen, niños, el placer que experimentó el pobre Pinocho,\ncuando supo que estaba destinado a volverse un tambor.\nSucedió que el comprador, apenas pagó sus veinte sueldos, condujo al\nburrito a la orilla del mar y, colgándole una piedra al cuello y amarrándolo\npor una pata con una soga que tenía en la mano, le dio de improviso un\nempujón y lo arrojó al agua.\nPinocho, con ese peso al cuello, se precipitó al fondo y el comprador,\nteniendo siempre agarrada la soga, se sentó sobre una piedra, a la espera de\nque el burrito se muriera ahogado, para luego quitarle la piel.\nXXXIV\nPinocho, arrojado al mar, es devorado por los peces y vuelve a ser una\nmarioneta como antes. Pero mientras nada para salvarse, es tragado por un\nterrible tiburón.\nDespués de cincuenta minutos durante los cuales el burrito duró bajo el\nagua, el comprador dijo, discurriendo para sí:\n—A esta hora mi pobre burrito cojo ya debe estar bien ahogado.\nSaquémoslo entonces y hagamos con su piel un buen tambor.\nY comenzó a tirar de la soga con la que lo había atado de una pata, y tiró\ny tiró y tiró, y al final vio aparecer sobre el agua… ¿Adivinen? En vez de\nun burrito muerto, vio aparecer sobre el agua una marioneta viva, que se\nagitaba como una anguila.\nViendo aquella marioneta de madera, el pobre hombre creyó estar\nsoñando y se quedó ahí entontecido, con la boca abierta y los ojos que se le\nsalían.\nRecuperado de la sorpresa inicial, dijo sollozando y lamentándose:\n—¿Y el burrito que he arrojado al mar dónde está?\n—Ese burrito soy yo —respondió la marioneta riendo.\n—¿Tú?\n—Yo.\n—¡Ah, estafador! ¿Pretendes burlarte de mí?\n—¿Burlarme de usted? Todo lo contrario, caro patrón: le estoy hablando\nen serio.\n—¿Pero entonces por qué hace un instante eras un borrico y ahora, luego\nde estar en el agua, te has convertido en una marioneta de palo?\n—Será el efecto del agua del mar. El mar causa ese tipo de efectos.\n—¡Ten cuidado, marioneta, ten cuidado!… No creas que te vas a divertir\na costa mía. ¡Te vas a meter en problemas si se me acaba la paciencia!\n—Bueno, patrón: ¿quiere saber la verdadera historia? Desáteme esta pata\ny se la contaré.\nY el buen hombretón del comprador, curioso de conocer la verdadera\nhistoria, le desató el nudo de la soga con que lo tenía amarrado; Pinocho, al\nencontrarse libre como un pájaro en el aire, se puso a hablarle de esta\nmanera:\n—Tienes que saber que yo era una marioneta de palo, como me ves\nahora, pero se me había metido en la cabeza volverme un niño como hay\ntantos en el mundo. Sin embargo, por las pocas ganas de estudiar que tenía\ny por hacer caso a las malas amistades, me escapé de casa… y un buen día,\nal despertar, me encontré transformado en un burro con largas orejas… y\nuna larga cola. ¡Qué vergüenza se apoderó de mí!… Una vergüenza,\nquerido patrón, que, por san Antonio bendito, ojalá nunca vaya a\nexperimentar usted! Y así me llevaron a vender al mercado de los burros, y\nfui comprado por el Director de una compañía ecuestre, el cual se puso en\nla tarea de hacer de mí un gran bailarín y un gran saltador de aros. Pero una\nnoche, durante el espectáculo, hice en el teatro un mal movimiento, me caí\ny quedé cojo de las dos patas. Entonces el Director, no sabiendo qué hacer\ncon un burrito cojo, me mandó a revender, y usted me ha comprado.\n—¡Por desgracia! Y he pagado veinte sueldos. ¿Y ahora quién me\ndevuelve mis míseros veinte sueldos?\n—¿Y para qué me compró? ¡Usted me compró para hacer con mi piel un\ntambor!… ¡Un tambor!\n—¡Por desgracia! ¿Y dónde encontraré ahora otra piel?…\n—No se eche a la pena, patrón. ¡Hay muchos burros en este mundo!\n—Dime, bribón, ¿y tu historia termina aquí?\n—No —respondió la marioneta—, un par de palabras más y la termino.\nDespués de haberme comprado, usted me condujo a este sitio para matarme,\npero entonces, cediendo a un sentimiento piadoso de humanidad, prefirió\namarrarme una piedra al cuello y arrojarme al fondo del mar. Este\nsentimiento de delicadeza le hace grandísimo honor, por el que le debo\neterno agradecimiento. Por lo demás, querido patrón, esta vez usted ha\narreglado cuentas sin el Hada.\n—¿Y quién es esta Hada?\n—Es mi madre, la cual se parece a todas las buenas madres que quieren\nel bien para sus hijos y no los pierden de vista jamás, y los asisten\namorosamente en cada desgracia, incluso cuando estos niños, por sus\ntravesuras y sus malos comportamientos, merecerían ser abandonados y\ndejados a la merced de sí mismos. Decía entonces que la buena Hada,\napenas me vio en peligro de ahogarme, me envió un banco de innumerables\npeces, que, creyéndome un burro muerto, comenzaron a comerme. ¡Y qué\nmordiscos los que me daban! Nunca hubiera creído que los peces eran tan\nglotones como los niños… Unos me comieron las orejas, otros el hocico,\notros el cuello y la crin, otros más la piel de las patas, los de allá el pelaje\ndel lomo… y entre los demás hubo un pececito tan amable que se dignó\nincluso a comerme la cola.\n—De hoy en adelante —dijo el comprador horrorizado, juro nunca volver\na probar ningún pescado. Me disgustaría enormemente abrir un salmonete o\nuna merluza frita y encontrarme adentro la cola de un burro.\n—Pienso igual que usted —respondió la marioneta riendo—. Por lo\ndemás, debe saber que cuando los peces terminaron de comerme toda esa\ncáscara de burro que me cubría de la cabeza a los pies llegaron, como es\nnatural, a la osamenta… o, para decirlo mejor, al maderamen, porque, como\nve, soy de madera durísima. Pero después de los primeros mordiscos, estos\npeces glotones se dieron cuenta de que la madera no era materia para sus\ndientes y, nauseados por esa comida indigesta, se fueron, para un lado o\npara el otro, sin volverme siquiera a darme las gracias. Y he aquí el cuento\nde cómo, al tirar de su soga, se encontró con una marioneta viva, en vez de\nun burrito muerto.\n—Me río de tu historia —vociferó el comprador enfurecido—. Sé que\ngasté veinte sueldos en comprarte y quiero mi dinero de regreso. ¿Sabes qué\nvoy a hacer? Te llevaré de nuevo al mercado y te revenderé por peso como\nleña seca para encender la chimenea.\n—Revéndeme: por mí está bien —dijo Pinocho.\nPero diciendo esto, dio un gran salto y se echó al agua. Y nadando\nalegremente y alejándose de la playa, gritaba al pobre comprador:\n—Adiós, patrón: si tiene necesidad de una piel para hacerse un tambor,\nacuérdese de mí.\nY luego reía y seguía nadando. Y después de un poco, volviéndose hacia\natrás, gritaba más fuerte:\n—Adiós, patrón: si tiene necesidad de un poco de leña seca para\nencender la chimenea, acuérdese de mí.\nY en un abrir y cerrar de ojos se había alejado tanto, que casi ni se podía\nver; es decir, se veía solamente sobre la superficie del mar un puntico negro\nque cada tanto estiraba las patas fuera del agua y hacía cabriolas y saltos,\ncomo un delfín de buen humor.\nEn tanto Pinocho nadaba a su gusto, vio en mitad del mar un escollo que\nparecía de mármol blanco, y sobre el escollo, una hermosa Cabrita que\nbalaba amorosamente y le hacía señales para que se acercara.\nEl asunto más singular era este: que la lana de la Cabrita, en vez de ser\nnegra o blanca, o de ambos colores, como la de las otras cabras, era\nturquesa, de un modo refulgente que hacía recordar muchísimo el pelo de la\nbella Niña.\n¡Dejo que ustedes se imaginen si el corazón del pobre Pinocho comenzó\na latir más fuerte! Redoblando sus esfuerzos, se dedicó a nadar hacia el\nescollo blanco y, estando a medio camino, súbitamente salió del agua y se le\nvino encima la horrible cabeza de un monstruo marino, con la boca abierta\nde par en par con la fuerza de una vorágine, y tres filas de dientes que\nhabrían asustado con solo verlas pintadas.\n¿Y saben cuál era ese monstruo marino?\nEse monstruo marino era, nada más ni nada menos, aquel descomunal\ntiburón mencionado otras veces en esta historia y que, por los desastres que\ncausaba y su insaciable voracidad, era denominado el Atila de los peces y\nde los pescadores.\nImagínense el pavor que el pobre Pinocho experimentó al ver aquel\nmonstruo. Buscó esquivarlo, irse por otro lado, pero esa inmensa boca\nabierta se le acercaba más y más con la velocidad de una saeta.\n—¡Apúrate, Pinocho, por favor! —gritaba balando la bella Cabrita.\nY Pinocho nadaba desesperadamente con los brazos, con el pecho, con\nlas piernas y con los pies.\n—¡Corre, Pinocho, tienes al monstruo ya muy cerca!\nY Pinocho, haciendo acopio de todas sus fuerzas, redoblaba el empeño de\nsu carrera.\n—¡Cuidado, Pinocho!… ¡el monstruo te alcanza!… ¡Ahí está, ahí está!…\n¡Muévete por favor o te tragará!\nY Pinocho nadaba más rápido que nunca, más y más y más, como la bala\nde un fusil. Y ya estaba a punto de arribar al escollo, y ya la Cabrita,\ninclinándose hacia el mar, le ofrecía sus dos patitas para ayudarlo a salir del\nagua…\n¡Pero ya era tarde! El monstruo lo había alcanzado: el monstruo,\naspirando fuertemente, se tragó a la pobre marioneta como si fuera el huevo\nde una gallina, y lo devoró con tanta violencia y avidez, que Pinocho,\nprecipitándose adentro del cuerpo del Tiburón, se dio un golpe tan brutal,\nque quedó inconsciente por al menos quince minutos.\nCuando volvió en sí del pasmo, no atinaba siquiera a comprender en qué\nmundo se encontraba. En torno a sí reinaba una gran oscuridad, pero era\nuna oscuridad tan negra y espesa, que le parecía haber entrado de cabeza en\nun calamar lleno de tinta. Se puso a escuchar y no oyó nada: solamente, de\ntanto en tanto, sentía en el rostro ráfagas de viento. Al principio no entendía\ncuál era el origen de aquel viento, pero luego comprendió que salía de los\npulmones del monstruo. Porque es necesario advertir que el Tiburón sufría\nde asma y, cuando respiraba, era como si soplara la tramontana.\nPinocho primero se las ingenió para darse un poco de ánimo, pero cuando\nfue evidente que se encontraba encerrado en el cuerpo del monstruo marino,\nentonces comenzó a llorar y a chillar, y gimiendo decía:\n—¡Auxilio, auxilio! ¡Oh, pobre de mí! ¿No hay nadie que pueda\nsalvarme?\n—¿Quién quieres que te salve, desventurado? —dijo en esa oscuridad un\nvozarrón cascado de guitarra desafinada.\n—¿Y quién habla así? —preguntó Pinocho, sintiéndose helar del miedo.\n—Soy yo: un pobre Atún, devorado por el Tiburón junto contigo. ¿Y tú\nqué pez eres?\n—Yo no tengo nada que ver con los peces. Yo soy una marioneta.\n—Y entonces, si no eres un pez, ¿por qué te hiciste tragar del monstruo?\n—Yo no me hice tragar: fue él quien me tragó. ¿Y ahora qué vamos a\nhacer en esta oscuridad?\n—Resignarse y esperar a que el Tiburón nos digiera a los dos.\n—¡Pero yo no quiero ser digerido! —vociferó Pinocho, volviendo a\nllorar.\n—Tampoco yo quiero ser digerido —añadió el Atún—, pero soy muy\ndado a filosofar y me consuelo pensando en que, cuando se nace atún, hay\nmás dignidad en morir bajo el agua que bajo el aceite.\n—¡Tonterías! —exclamó Pinocho.\n—Es mi opinión —replicó el Atún— y todas las opiniones, como dicen\nlos atunes políticos, deben respetarse.\n—En todo caso, yo quiero irme de aquí… quiero huir.\n—Huye, si eres capaz.\n—¿Es muy grande este tiburón que nos ha engullido? —preguntó la\nmarioneta.\n—Imagínate que su cuerpo tiene más de un kilómetro, sin contar la cola.\nMientras conversaban en la oscuridad, a Pinocho le pareció entrever a lo\nlejos una suerte de claridad.\n—¿Qué será esa lucecita a lo lejos? —dijo Pinocho.\n—Será algún compañero de infortunio que estará esperando como\nnosotros ser digerido.\n—Quiero ir a encontrarlo. ¿No podría ser acaso algún pez veterano que\npueda enseñar el camino de salida?\n—Ojalá lo fuera. Te lo deseo, de corazón, querida marioneta.\n—Adiós, Atún.\n—Adiós, marioneta, y buena suerte.\n—¿Cuándo nos volveremos a ver?\n—¡Quién sabe!… Es mejor no ponerse a pensar en eso.\nXXXV\nPinocho se encuentra en el cuerpo del Tiburón a… ¿A quién se encuentra? Lee\neste capítulo y lo sabrás.\nPinocho, apenas le dijo adiós a su buen amigo Atún, se movió\ntambaleándose en medio de aquella oscuridad, y comenzó a caminar a\ntientas dentro del cuerpo del Tiburón, dirigiéndose poco a poco hacia\naquella claridad que titilaba a lo lejos.\nY al caminar sintió que sus pies chapoteaban en unos charcos de agua\npegajosa y resbaladiza, y esa agua tenía un olor tan fuerte a pescado frito,\nque le parecía estar en mitad de la cuaresma.\nY cuanto más andaba, la claridad se hacía más fuerte y nítida, hasta que\nal fin arribó y, al llegar… ¿qué encontró? Nunca lo adivinarían: se encontró\ncon una mesa puesta, una vela encima sobre una botella de cristal verde y\nsentado a la mesa un viejito todo blanco, como si fuese de nieve o crema de\nleche, que estaba ahí echándoles el diente a unos pescaditos vivos, tan vivos\nque a veces, mientras se los comía, se le escapaban de la boca.\nAnte esta imagen el pobre Pinocho sintió una alegría tan grande e\ninesperada, que estuvo a nada de ponerse a delirar. Quería reír, quería llorar,\nquería decir un montón de cosas, y en vez de esto gimoteaba confusamente\ny balbuceaba palabras incomprensibles. Finalmente, fue capaz de dar un\ngrito de felicidad y, abriendo los brazos y lanzándose al cuello del viejito,\ncomenzó a gritar:\n—¡Oh, padrecito mío! ¡Finalmente te encontré! ¡Ahora sí nunca más te\nvoy a volver abandonar, nunca, nunca más!\n—¿Entonces mis ojos no me están mintiendo? —replicó el viejo\nrestregándose los ojos—. ¿Entonces tú eres de verdad mi querido Pinocho?\n—¡Sí, sí, soy yo, soy yo! ¿Y tú ya me perdonaste, cierto? ¡Oh, padrecito\nmío, cómo eres de bueno!… Y pensar que yo… Oh, ¡si supieras cuántas\ndesgracias he tenido que sufrir y cuántas cosas me han salido mal!\nImagínate que el día que tú, pobre papá, vendiste tu abrigo y compraste la\ncartilla para que yo fuera a la escuela, me escapé para ver a las marionetas,\ny el titiritero me quería echar al fuego para cocinar un cordero, y que fue\naquel el que me dio las cinco monedas de oro para que te las llevara, pero\nfue ahí cuando me encontré a la Zorra y al Gato que me llevaron hasta la\nHostería del Cangrejo Rojo, donde comieron como lobos, y al partir yo de\nnoche, solo, me encontré a los asesinos, que se pusieron a perseguirme, y yo\ncorrí, y ellos detrás, pisándome los talones, hasta que me colgaron de una\nrama del Gran Roble, adonde la bella Niña del pelo turquesa mandó una\ncarroza para salvarme, y los médicos, cuando me fueron a visitar, dijeron de\ninmediato: «Si no está muerto, es señal de que está vivo», y entonces se me\nsalió una mentira, y la nariz comenzó a crecerme y no me cabía por la\npuerta de la habitación, razón por la cual me fui con la Zorra y el Gato a\nenterrar las monedas de oro, pues una la había gastado en la hostería, y el\nPapagallo se puso a reír, y en vez de dos mil monedas no encontré nada, por\nlo que el Juez, cuando supo que había sido robado, me hizo ahí mismo\nmeter en prisión, para dar una satisfacción a los ladrones, y mientras yo\ncaminaba, vi un racimo de uvas en el campo, pero caí en una trampa, y el\ncampesino me puso el collar de su perro para que cuidara el gallinero, pero\nreconoció mi inocencia y me dejó ir, y la Serpiente, con la cola que parecía\nuna chimenea, principió a reír y se le estalló una vena en el pecho, y así\nvolví a la casa de la Niña, que estaba muerta, y el Palomo, viendo que\nlloraba, me dijo: «He visto a tu papá fabricándose un bote para irte a\nbuscar», y yo le dije: «Oh, si yo tuviese alas», y él me dijo: «¿Quieres ir\ndonde tu padre?», y yo le dije: «¡Claro que sí! ¿Pero quién podría\nllevarme?», y él me dijo: «Te llevo yo», y yo le dije: «¿Cómo?», y él me\ndijo: «Móntate sobre la grupa», y así volamos toda la noche, y luego a la\nmañana todos los pescadores que observaban el mar me dijeron: «Hay un\npobre hombre en una barquita que está por ahogarse», y yo, de lejos, te\nreconocí de inmediato, porque me lo decía el corazón, y te hice señas para\nque volvieras a la playa.\n—Yo también te reconocí —dijo Geppetto—, y hubiera querido volver a\nla playa, pero no sabía cómo. El mar estaba picado y una oleada tumbó la\nbarca. Entonces un horrible Tiburón, que estaba cerca, apenas me avistó en\nel agua me comenzó a perseguir y, sacando la lengua, me engulló como si\nfuera un pastelillo.\n—¿Y hace cuánto que estás encerrado aquí dentro? —preguntó Pinocho.\n—Desde aquel día… Deben ser ahora como dos años: dos años, Pinocho\nmío, que me han parecido dos siglos.\n—¿Y cómo has hecho? ¿Dónde encontraste la vela? Y los fósforos para\nencenderla, ¿quién te los dio?\n—Ya te contaré todo. Antes debes saber que la misma borrasca que volcó\nmi barquita hizo zozobrar también un buque mercante. Todos los marinos se\nsalvaron, pero la mercancía se hundió y el mismo Tiburón, que ese día tenía\nun excelente apetito, después de haberme tragado, se tragó también el\nbuque.\n—¿Cómo? ¿Se lo tragó todo de un bocado? —preguntó Pinocho\nmaravillado.\n—Todo de un bocado: y escupió solamente el palo mayor, porque se le\nhabía quedado entre los dientes como si fuera una espina. Para mi gran\nfortuna, ese buque estaba cargado de carne en conserva, galletas, panes,\nbotellas de vino, uvas pasas, queso, café, azúcar, velas y cajas de fósforos.\nCon todos estos favores divinos, pude arreglármelas dos años, pero hoy me\nquedan las últimas porciones: en la despensa ya no hay nada, y esta vela\nque ves prendida es la última vela que me queda.\n—¿Y entonces?…\n—Y entonces, querido mío, nos quedaremos en la oscuridad.\n—Pues, padrecito mío —dijo Pinocho—, no hay tiempo que perder. Es\nnecesario que pensemos en la manera de huir.\n—¿Huir? ¿Y cómo?\n—Escapando de la boca del Tiburón y echarse al mar y nadar.\n—Tienes razón, pero yo, querido Pinocho, no sé nadar.\n—¿Y qué importa?… Tú te montas a mis espaldas y yo, que soy un buen\nnadador, te llevaré sano y salvo hasta la playa.\n—¡No te ilusiones, niño mío! —replicó Geppetto, sacudiendo la cabeza y\nsonriendo melancólicamente—. ¿Crees que una marioneta, de apenas un\nmetro como tú, tiene la fuerza suficiente para llevarme a nado en las\nespaldas?\n—¡Inténtalo y verás! En todo caso, si es seguro que vamos a morir, al\nmenos tendremos el consuelo de morir abrazados.\nY sin decir más, Pinocho tomó la vela entre las manos y, llevándola\nadelante para alumbrarse, dijo a su padre:\n—Sígueme y no tengas miedo.\nY así caminaron un buen trecho y atravesaron el cuerpo y el estómago\ndel Tiburón. Pero, cuando llegaron donde empezaba la gran garganta del\nmonstruo, se detuvieron y dieron una ojeada para decidir el momento\noportuno de la fuga.\nEs necesario advertir que el Tiburón, al ser muy viejo y sufrir de asma y\nde palpitaciones del corazón, estaba obligado a dormir con la boca abierta,\npor lo que Pinocho, asomándose al principio de la garganta y mirando hacia\narriba, pudo ver, afuera de esa enorme boca abierta de par en par, el cielo\nestrellado y una bellísima luz de luna.\n—Este es el momento preciso para escapar —susurró entonces\nvolviéndose hacia su padre—. El Tiburón duerme como un lirón, el mar\nestá en calma y hay luz como si fuera de día. Ven entonces, padre mío,\ndetrás de mí, y dentro de poco estaremos salvados.\nDicho y hecho, subieron por la garganta del monstruo marino y, al llegar\na la enorme boca, comenzaron a caminar en puntas de pie sobre la lengua:\nuna lengua tan larga y tan ancha que parecía el sendero de un jardín. Y ya\nestaban a punto de dar el gran salto y se iban a lanzar al mar, cuando el\nTiburón estornudó y, al hacerlo, dio una sacudida tan violenta, que Pinocho\ny Geppetto se encontraron impulsados hacia atrás, con tan mala suerte que\nse encontraron de nuevo en el estómago del monstruo.\nEn el gran golpe de la caída la vela se apagó y padre e hijo quedaron a\noscuras.\n—¿Y ahora?… —preguntó Pinocho poniéndose serio.\n—Ahora, hijo mío, estamos perdidos.\n—¿Por qué perdidos? Dame la mano, papá, y trata de no resbalarte.\n—¿A dónde me llevas?\n—Debemos reintentar la fuga. Ven conmigo y no tengas miedo.\nDicho esto, Pinocho tomó a su padre por la mano y, caminando siempre\nen puntas de pie, volvieron a subir juntos por la garganta del monstruo,\nluego atravesaron toda la lengua y saltaron las tres hileras de dientes. Sin\nembargo, antes de dar el gran salto, la marioneta dijo a su padre:\n—Móntate a caballo sobre mi espalda y abrázame fuerte. Déjame el resto\na mí.\nApenas Geppetto se acomodó bien sobre la espalda del hijo, Pinocho,\nsegurísimo de lo que hacía, se lanzó al agua y comenzó a nadar. El mar\nestaba tranquilo como el aceite, la luna esplendía con toda su claridad y el\nTiburón seguía durmiendo con un sueño tan profundo que no lo habría\ndespertado un cañonazo.\nXXXVI\nFinalmente Pinocho deja de ser una marioneta y se convierte en un niño.\nMientras Pinocho nadaba a su gusto para alcanzar la playa, se dio cuenta de\nque su padre, que estaba a caballo sobre su espalda y tenía las piernas\nmetidas en el agua, no paraba de temblar como si sufriera de fiebre terciana.\n¿Temblaba de frío o de miedo? ¡Quién sabe!… Quizás un poco por una\nrazón y un poco por la otra. Pero Pinocho, creyendo que ese temblor era por\nel miedo, le dijo para confortarlo:\n—¡Ánimo, papá! En pocos minutos pisaremos tierra y estaremos a salvo.\n—¿Pero dónde está esa bendita playa? —preguntó el viejito poniéndose\ncada vez más inquieto y achinando los ojos como hacen los sastres cuando\nvan a enfilar un aguja—. Miro para todos lados y no veo otra cosa que cielo\ny mar.\n—Pero yo además veo la playa —dijo la marioneta—. Para tu\ninformación, yo soy como los gatos: veo mejor de noche que de día.\nEl pobre Pinocho fingía estar de buen humor, pero, en realidad,\ncomenzaba a desmoralizarse: las fuerzas le fallaban, su respiración se\nvolvía pesada y afanosa; en suma, no podía más y la playa seguía estando\nlejos.\nNadó hasta que tuvo aliento, luego volteó la cabeza para ver a Geppetto y\ndijo con voz entrecortada:\n—¡Papá… ayúdame… porque muero!\nY padre e hijo estaban a punto de hundirse, cuando oyeron una voz de\nguitarra desafinada que dijo:\n—¿Quién muere?\n—Mi pobre padre y yo.\n—Esta voz me es conocida. ¡Tú eres Pinocho!\n—El mismo. ¿Y tú?\n—Soy el Atún, tu compañero de prisión en el cuerpo del Tiburón.\n—¿Y cómo hiciste para escapar?\n—Seguí tu ejemplo. Tú fuiste el que me enseñó el camino y, después de\nque huiste tú, seguí yo.\n—Mi Atún, llegaste justo a tiempo. Te pido por el amor que les tienes a\ntus atuncitos: ayúdanos o estamos perdidos.\n—Con gusto y de todo corazón. Agárrense los dos a mi cola y déjense\nllevar. En pocos minutos estarán en la orilla.\nGeppetto y Pinocho, como pueden imaginárselo, aceptaron en el acto la\ninvitación. Pero, en vez de agarrarse a la cola, juzgaron más cómodo\nacomodarse en el lomo del Atún.\n—¿Estamos muy pesados? —le preguntó Pinocho.\n—¿Pesar? Ni un poquito: me parece tener encima las conchas de un par\nde almejas —respondió el Atún, el cual era de una complexión tan gruesa y\nrobusta, que parecía un ternero de dos años.\nLlegados a la ribera, Pinocho saltó a la tierra primero, para ayudar a su\npadre a hacer lo propio. Luego se volvió hacia el Atún y con voz\nconmovida le dijo:\n—Amigo mío, ¡has salvado a mi padre! No tengo suficientes palabras\npara agradecerte. Permíteme al menos que te dé un beso en señal de eterno\nreconocimiento.\nEl Atún sacó la cabeza fuera del agua y Pinocho, arrodillándose sobre la\ntierra, le dio un muy afectuoso beso en la boca. En este instante de\nespontánea y vivísima ternura, el pobre Atún, que no estaba acostumbrado,\nse sintió tan conmovido, que avergonzándose de que lo vieran llorar como\nun niño, volvió a meter la cabeza dentro del agua y desapareció.\nY se hizo de día.\nEntonces Pinocho, ofreciendo su brazo a Geppetto, que apenas tenía\naliento para tenerse en pie, le dijo:\n—Apóyate en mi brazo, querido padre, y vamos. Caminaremos despacio,\ncomo las hormigas, y cuando nos cansemos, reposaremos en el camino.\n—¿Y adónde vamos a ir? —preguntó Geppetto.\n—En busca de una casa o de una cabaña, donde nos puedan dar un trozo\nde pan y un poco de paja que nos sirva de lecho.\nNo habían dado cien pasos, cuando vieron a la orilla del camino dos feos\npordioseros pidiendo limosna.\nEran el Gato y la Zorra, pero estaban irreconocibles. Imagínense que el\nGato, a fuerza de fingir ceguera, se había vuelto ciego de verdad. Y la\nZorra, envejecida, roñosa y renca, ni siquiera tenía cola. Así es: esa triste\nladronzuela, caída en la más inmunda miseria, se vio obligada un día a\nvender su bellísima cola a un mercachifle ambulante, que la compró para\nhacerse un espantamoscas.\n—¡Oh, Pinocho! —gritó la Zorra lloriqueando—, ten un poco de caridad\nde estos dos enfermos.\n—¡Enfermos! —repitió el Gato.\n—¡Adiós, avivatos! —respondió la marioneta—. Me engañaron una vez,\npero no lo van a volver a hacer.\n—Créelo, Pinocho, ¡somos pobres y desgraciados de verdad!\n—¡De verdad! —repitió el Gato.\n—Si son pobres, se lo merecen. Y recuerden ese proverbio que dice:\n«Dinero robado no queda sembrado». Adiós, avivatos.\n—¡Ten compasión de nosotros!\n—¡De nosotros!\n—¡Adiós, avivatos! Y recuerden ese proverbio que dice: «Harina del\ndiablo, toda se vuelve salvado».\n—¡No nos abandones!\n—¡… ones! —repitió el Gato.\n—¡Adiós, avivatos! Recuerden ese proverbio que dice: «¡Quien roba la\ncapa de su vecino muere sin camisa!».\nY así diciendo, Pinocho y Geppetto continuaron tranquilamente su\ncamino, hasta que, dados otros cien pasos, vieron al fondo de un sendero, en\nmedio del campo, una hermosa cabaña toda de paja y con el techo cubierto\nde teja y ladrillo.\n—Esa cabaña debe estar habitada por alguien —dijo Pinocho—. Vamos a\ntocar la puerta.\nY en efecto fueron y tocaron la puerta.\n—¿Quién es? —dijo una vocecita desde adentro.\n—Somos un pobre padre y un pobre hijo, sin pan y sin techo —respondió\nla marioneta.\n—Giren el pomo y la puerta se abrirá —dijo la misma voz.\nPinocho giró el pomo y la puerta se abrió. Apenas entraron, miraron a un\nlado y al otro y no vieron a nadie.\n—¿El dueño de casa dónde está? —dijo Pinocho asombrado.\n—¡Heme aquí, arriba de ustedes!\nPadre e hijo se volvieron a mirar el techo y vieron sobre un travesaño al\nGrillo parlante.\n—¡Oh, mi querido Grillito! —dijo Pinocho saludándolo cálidamente.\n—¿Con que ahora me llamas tu querido Grillito? ¿Pero te acuerdas\ncuando, para echarme de tu casa, me tiraste un martillo?\n—¡Tienes razón, Grillito! Échame a mí… Tírame ahora un martillo a mí,\npero ten piedad de mi pobre padre.\n—Tendré piedad del padre y del hijo también. Pero he querido recordarte\nel feo gesto tuyo, para enseñarte que en este mundo, cuando se puede, es\nnecesario mostrarse corteses con todos, si queremos gozar de las mismas\ncortesías los días de necesidad.\n—Tienes razón, Grillito, tienes razón y voy a grabar en la mente las\nlecciones que me das. Pero dime: ¿cómo has hecho para comprarte esta\nbella cabaña?\n—Esta cabaña me la regaló ayer una graciosa Cabra, que tenía la lana de\nun bellísimo color turquesa.\n—¿Y la Cabra a dónde fue? —preguntó Pinocho con vivísima curiosidad.\n—No lo sé.\n—¿Y cuándo volverá?\n—No volverá jamás. Ayer partió toda afligida y al balar parecía decir:\n“Pobre Pinocho, ahora no lo veré más: ¡el Tiburón a esta hora ya se lo debe\nhaber devorado!”.\n—¿Ha dicho así?…¡Entonces era ella… era ella!… ¡Era mi querida\nHadita!… —comenzó a gritar Pinocho, sollozando y llorando\ninconteniblemente.\nCuando lloró lo suficiente, se restregó los ojos, preparó su lecho de paja,\ny acostó ahí al viejo Geppetto. Luego le preguntó al Grillo parlante:\n—Dime, Grillito, ¿dónde podría encontrar un vaso de leche para mi\npobre padre?\n—A tres kilómetros de acá, vive el hortelano Juan que tiene vacas. Ve\ndonde él, que tiene la leche que buscas.\nPinocho fue a toda prisa a la casa del hortelano Juan, y este le dijo:\n—¿Cuánto quieres de leche?\n—Un vaso entero.\n—Un vaso de leche cuesta un sueldo. Tienes que dármelo primero.\n—No tengo ni siquiera un centavo —respondió Pinocho mortificado y\nafligido.\n—Mal, apreciada marioneta —replicó el hortelano—. Si no tienes ni\nsiquiera un centésimo, yo no tengo tampoco un poco de leche.\n—¡Está bien! —dijo Pinocho e hizo el gesto de irse.\n—Espera un momento —dijo Juan—. Entre tú y yo podemos llegar a un\nacuerdo. ¿Quieres ponerte a girar la noria?\n—¿Qué es una noria?\n—Es ese instrumento de madera que sirve para sacar el agua de la\ncisterna que va a regar las hortalizas.\n—Lo intentaré.\n—Entonces, tráeme cien baldes de agua, y en compensación te daré el\nvaso de leche.\n—Está bien.\nJuan condujo a la marioneta a la huerta y le enseñó la manera de manejar\nla noria. Pinocho se puso de inmediato a trabajar, pero antes de haber\nacabado su tarea, ya estaba bañado de sudor de la cabeza a los pies. Nunca\nse había esforzado de tal manera.\n—Hasta ahora este trabajo de hacer girar la noria —dijo el hortelano— lo\nhabía hecho mi burrito, pero hoy ese pobre animal está en las últimas.\n—¿Me llevas a verlo? —dijo Pinocho.\n—Con gusto.\nApenas Pinocho entró en el establo, vio un bonito burrito echado sobre la\npaja, reducido por el hambre y la fatiga. Cuando pudo verlo con más\ncuidado, dijo para sí, sintiéndose perturbado: «¡Pero si yo sé quién es este\nburrito! ¡A este yo lo conozco!».\nY agachándose cerca de él, le preguntó en el idioma de los burros:\n—¿Quién eres?\nA esta pregunta, el burrito abrió los ojos moribundos y respondió\nbalbuciendo en el mismo dialecto:\n—Soy Pa… bi… lo.\nY después cerró los ojos y expiró.\n—¡Oh, pobre Pabilo! —dijo Pinocho a media voz. Y tomando una\nmanotada de paja, se secó una lágrima que le bajaba por el rostro.\n—¿Te conmueves tanto por un burro que no tiene nada que ver contigo?\n—dijo el hortelano—. ¿Qué debería hacer yo que lo compré con dinero\ncontante y sonante?\n—Es que… era un amigo mío.\n—¿Tu amigo?\n—Un compañero de escuela.\n—¿Cómo? —vociferó Juan soltando una carcajada—. ¡Cómo! ¿Tenías\nburros por compañeros de escuela? ¡No me quiero imaginar lo mucho que\nestudiaban!\nLa marioneta, sintiéndose mortificada por estas palabras, no respondió,\nsino que tomó el vaso de leche casi caliente y regresó a la cabaña.\nY desde aquel día en adelante, por más de cinco meses, continuó\nlevantándose cada mañana antes del alba, para ir a girar la noria y ganarse\nasí el vaso de leche que tanto bien le hacía a la disminuida salud de su\npadre. Pero no se contentó con esto, porque, con el tiempo, aprendió a\nfabricar canastas y cestos de mimbre, y con las monedas que recogía,\ncontribuía juiciosamente a todos los gastos diarios. Entre otras cosas,\nconstruyó él solo una elegante carretilla para sacar de paseo a su padre, a\ntomar el sol y un poco de aire.\nY a la luz de las velas, por la noche, se dedicaba a leer ya escribir. Había\ncomprado en el pueblo vecino por pocos centavos un libro gordo al cual le\nfaltaban la portada y el índice, pero que igual le servía para hacer sus\nlecturas. En cuanto a escribir, utilizaba una ramita afilada como pluma, y no\nteniendo ni tintero ni tinta, lo teñía en una botellita llena de jugo de mora y\ncereza.\nEl hecho es que con su buena voluntad y su ingenio por trabajar y salir\nadelante, no solo logró mantener desahogadamente a su padre, sino que,\nademás, había podido ahorrar para comprarse un vestido nuevo.\nUna mañana dijo a su padre:\n—Me voy al mercado cercano a comprarme una chaqueta, un gorro y un\npar de zapatos. Cuando regrese a casa —agregó riendo—, estaré tan bien\nvestido, que me confundirás con un gran señor.\nY saliendo de casa, comenzó a correr todo alegre y satisfecho. En un\npunto, oyó que alguien pronunciaba su nombre y, volviéndose, vio a un\nhermoso Caracol que sacaba la cabeza por un matorral.\n—¿No me reconoces? —dijo el Caracol.\n—No estoy seguro…\n—¿No te acuerdas de ese Caracol que servía a la Hada de pelo turquesa?\n¿No recuerdas aquella vez en que bajé a abrirte y tú te quedaste con el pie\natrapado en la puerta?\n—Me acuerdo de todo —gritó Pinocho—. Respóndeme, Caracolito,\n¿dónde se encuentra mi buena Hada? ¿Qué hace? ¿Me ha perdonado? ¿Se\nacuerda aún de mí? ¿Todavía me quiere? ¿Está muy lejos de aquí? ¿Puedo\nir a buscarla?\nA todas estas preguntas hechas precipitadamente y sin tomar aliento, el\nCaracol respondió con su habitual flema:\n—Pinocho mío, la pobre Hada se encuentra postrada en la cama de un\nhospital.\n—¿En un hospital?\n—Por desgracia. A causa de mil infortunios, se enfermó gravemente y\nahora no tiene siquiera para comprarse un pedazo de pan.\n—¿De verdad?… ¡Oh, qué gran dolor me haces sentir! ¡Oh, pobre\nHadita! ¡Pobrecita!… Si tuviera un millón, correría a llevárselo… Pero solo\ntengo cuarenta monedas… Estas de acá, con las que iba de camino a\ncomprarme un vestido nuevo. Tómalas, Caracol, y llévaselas rápido a mi\nbuena Hada.\n—¿Y tu vestido nuevo?\n—¿Qué importancia tiene mi vestido nuevo? Venderé incluso estos\nharapos que tengo encima, para poder ayudarla. Ve, Caracolito, ayúdala, y\nregresa aquí dentro de dos días, cuando espero poder darte algo más de\ndinero. Hasta ahora he trabajado para mantener a mi padre: desde hoy\ntrabajaré cinco horas más para mantener a mi buena madre. Adiós, Caracol,\ny nos vemos dentro de dos días.\nEl Caracol, contra su costumbre, comenzó a volar como una luciérnaga\nbajo el gran sol de agosto.\nCuando Pinocho regresó a su casa, su padre le preguntó:\n—¿Y el vestido nuevo?\n—No pude encontrar ninguno que me quedara bien. ¡No importa!… Lo\ncompraré después.\nEsa noche Pinocho, en vez de trasnochar hasta las diez, se mantuvo\ndespierto hasta después de medianoche y, en vez de hacer ocho canastas de\nmimbre, hizo dieciséis.\nLuego se fue a la cama y se quedó dormido de inmediato. Y en el sueño\nle pareció ver al Hada, hermosa y muy sonriente, la cual, después de\nhaberle dado un beso, le habló de esta manera:\n—¡Muy bien, Pinocho! Por tu buen corazón, te perdono todas las\ntravesuras que has hecho hasta hoy. Los niños que ayudan amorosamente a\nsus padres en sus días malos y en la enfermedad merecen todo el honor y el\nafecto, aunque no puedan ser citados como modelos de obediencia y de\nbuena conducta. Sigue juicioso de aquí en adelante y serás feliz.\nEn este punto el sueño concluyó y Pinocho se despertó, abriendo los ojos\nde par en par.\nAhora imagínense cuál fue su sorpresa cuando, al despertar, se dio cuenta\nde que no era más una marioneta de madera, sino que se había convertido\nen un niño como los demás. Dio una ojeada en torno y, en vez de las\nhabituales paredes de paja de la cabaña, vio una hermosa habitación\namoblada y arreglada con sencillez y elegancia. Saltando de la cama, se\nencontró con un vestido nuevo y un par de botas de piel que lo hicieron\nparecer salido de un cuadro.\nApenas se vistió, se metió espontáneamente las manos en los bolsillos y\nsacó un pequeño monedero de marfil sobre el cual estaban grabadas estas\npalabras: «El Hada del pelo turquesa restituye al querido Pinocho las\ncuarenta monedas y le agradece por su buen corazón». Al abrirlo, en vez de\nducados de cobre, había cuarenta cequíes de oro recién acuñados.\nDespués fue a verse a un espejo y le pareció que era otro. No vio el\nreflejo de la marioneta de madera de siempre, sino que vio la imagen\ndespierta e inteligente de un muchacho con el pelo castaño, los ojos celestes\ny un aire alegre y festivo como una pascua.\nEn medio de todas estas maravillas que se sucedían una tras otra, Pinocho\nno sabía si estaba pasando de verdad o si estaba soñando con los ojos\nabiertos.\n—¿Y dónde está mi padre? —gritó de repente y, al entrar a la habitación\nde al lado, se encontró con el viejo Geppetto sano, activo y de buen humor,\nque, habiendo retomado de una vez su oficio como tallador de madera,\nestaba diseñando una hermosísima cornisa adornada con hojas, flores y\ncabezas de distintos animales.\n—Sácame de una duda, padre: ¿cómo te explicas todos estos cambios\nrepentinos? —le preguntó Pinocho, saltándole al cuello y cubriéndolo de\nbesos.\n—Este cambio repentino en la casa es todo mérito tuyo —dijo Geppetto.\n—¿Por qué mérito mío?\n—Porque cuando los niños malos se vuelven buenos, tienen la virtud de\nadoptar un aspecto completamente nuevo e irradiar alegría a su familia.\n—Y el viejo Pinocho de madera, ¿dónde quedó?\n—Míralo acá —respondió Geppetto, y le señaló una gran marioneta\napoyada en una silla, con la cabeza ladeada, los brazos colgantes y las\npiernas cruzadas y medio dobladas; parecía un milagro que pudiera tenerse\nen pie.\nPinocho se volteó a verlo. Y después de que lo observó un momento, se\ndijo con gran complacencia:\n«¡Cómo era de gracioso cuando era una marioneta! ¡Y cómo estoy de\ncontento ahora que soy un niño de verdad».	16	2026-04-05 17:34:55.129984	\N
\.


--
-- TOC entry 5108 (class 0 OID 16425)
-- Dependencies: 220
-- Data for Name: matriculas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matriculas (id, alumno_id, curso_id, fecha_matricula, estado) FROM stdin;
1	2	1	2026-04-04	activo
2	3	1	2026-04-04	activo
3	19	5	2026-04-05	activo
4	20	5	2026-04-05	activo
\.


--
-- TOC entry 5116 (class 0 OID 16499)
-- Dependencies: 228
-- Data for Name: opciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.opciones (id, pregunta_id, texto, es_correcta) FROM stdin;
1	1	De un viaje espacial	f
2	1	De un principito que explora mundos	t
3	2	El Principito	t
4	2	Un robot	f
\.


--
-- TOC entry 5114 (class 0 OID 16484)
-- Dependencies: 226
-- Data for Name: preguntas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.preguntas (id, lectura_id, enunciado, tipo, orden_pregunta, cuestionario_id) FROM stdin;
1	1	¿De qué trata la lectura?	unica	1	\N
2	1	¿Quién es el personaje principal?	unica	2	\N
\.


--
-- TOC entry 5122 (class 0 OID 16556)
-- Dependencies: 234
-- Data for Name: progreso_lectura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progreso_lectura (id, alumno_id, lectura_id, porcentaje_avance, ultima_pagina, actualizado_en) FROM stdin;
1	2	1	50	5	2026-03-29 00:33:53.647807
2	19	3	100	1	2026-04-19 22:31:43.420784
\.


--
-- TOC entry 5126 (class 0 OID 16589)
-- Dependencies: 238
-- Data for Name: puntos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.puntos (id, alumno_id, motivo, delta, creado_en) FROM stdin;
1	2	Aprobó evaluación de lectura 1	20	2026-03-28 17:28:00.555714
2	3	Aprobó evaluación de lectura 1	20	2026-03-28 17:51:49.487694
4	3	Aprobó evaluación de lectura 1	20	2026-03-28 21:58:10.462006
5	3	Aprobó evaluación de lectura 1	20	2026-03-28 22:02:44.381616
6	3	Aprobó evaluación de lectura 1	20	2026-03-28 22:05:25.444274
7	10	Aprobó evaluación de lectura 1	20	2026-03-29 00:33:51.02574
8	3	Aprobó evaluación de lectura 1	20	2026-04-05 16:36:04.44557
9	19	Aprobó evaluación de lectura 3	20	2026-04-05 20:18:46.070933
\.


--
-- TOC entry 5124 (class 0 OID 16579)
-- Dependencies: 236
-- Data for Name: recompensas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recompensas (id, nombre, descripcion, puntos_necesarios) FROM stdin;
\.


--
-- TOC entry 5120 (class 0 OID 16534)
-- Dependencies: 232
-- Data for Name: respuestas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.respuestas (id, intento_id, pregunta_id, opcion_id, correcta) FROM stdin;
1	3	1	2	t
2	3	2	3	t
3	4	1	2	t
4	4	2	3	t
5	5	1	2	t
6	5	2	3	t
9	7	1	2	t
10	7	2	3	t
11	8	1	2	t
12	8	2	3	t
13	9	1	2	t
14	9	2	3	t
15	10	1	2	t
16	10	2	3	t
17	11	1	2	t
18	11	2	3	t
19	12	1	2	t
20	12	2	3	t
\.


--
-- TOC entry 5142 (class 0 OID 16725)
-- Dependencies: 254
-- Data for Name: respuestas_alumno; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.respuestas_alumno (id, alumno_id, pregunta_id, alternativa_id, es_correcta, respondido_en) FROM stdin;
\.


--
-- TOC entry 5104 (class 0 OID 16400)
-- Dependencies: 216
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, apellido, correo, password, rol, creado_en, activo, verification_token, asignatura, curso, es_profesor_jefe) FROM stdin;
1	Emilio	Robles	emilio@test.com	123456	alumno	2026-03-28 16:35:44.891295	f	\N	\N	\N	f
2	Emilia	Robles	emilia@test.com	$2b$10$hqa7DXG9Z64cqeyW0d4zFe1gFjVAvameVcUuDFg4NRciuLzx5S4sO	alumno	2026-03-28 16:40:31.167237	f	\N	\N	\N	f
3	Lucas	Robles	lucas@gmail.com	$2b$10$aqen1FvMYG7ARu2Ph7YqxOpI7dVuQGNdWKlRkQuJLUwjJPXbg.Aha	alumno	2026-03-28 17:37:28.068096	f	\N	\N	\N	f
8	Administrador	Sistema	admin@cazalibros.com	$2b$10$cOmACqeC2A/pj51UajWwDOH0PjQAvUXLcAECE1urExyXHY/eQLnk6	admin	2026-03-28 23:14:03.043765	f	\N	\N	\N	f
10	Jesus	López	emiliojrobleslopez@gmail.com	$2b$10$1/HDVtAj3GujaitxpNgJIe2iDBnRpApreRD0qJsxAVupKjhM.rV0K	alumno	2026-03-29 00:23:24.815472	f	105fd54e47f6fb9dd394524c04c30269fdc5c1c38f73761f0c17164db4a98a4d	\N	\N	f
6	Manuel	Garcia	profesor@gmail.com	$2b$10$k94d5ERqNXUpKg.nRP7vM.ysz5fNpXgB16XYuJUCCiBJlSuQZGhJi	docente	2026-03-28 22:11:46.584015	f	\N	Lenguaje y Comunicacíon	3° Básico A	t
9	Lady	Pino	ladypino112@gmail.com	$2b$10$go/fz0RMfT6DCFqru.xy0eMz.tdhx6GNEWbi1mtV1dEYxYnjm5yv.	docente	2026-03-29 00:17:48.129988	f	3b73abddd140d060f395ec9d4c7d42b309f879d2407c227faf4cf0b3ef7520d7	Lenguaje y Comunicacíon	4° Básico A	t
14	Adrian	Morales	a@gmail.com	$2b$10$J94rGZ53J7hJLWXH38bse.GIi0ZBT2v27uWoZdJMV9PBUKPmBLFqm	docente	2026-04-05 00:02:29.480761	f	\N	Lenguaje y Comunicación	4° Básico B	t
15	Andres	Mendez	b@profesor.cl	$2b$10$CSvrMwyxDkZw4jc7TysWPeQbFiCEs5Y87diG6V5dhMUYOCnUZBJAm	docente	2026-04-05 00:07:53.709909	f	\N	Lenguaje y Comunicación	4° Básico C	t
17	Mario	Meneses	m@gmail.com	$2b$10$hfC0HFA0kxZr2sPeodoiaeqP7CRY46Gxu8.QYHrYtZI2cUO.5FfnG	alumno	2026-04-05 01:38:46.570481	f	\N	\N	\N	f
18	Francisco	Lizama	fl@alumno.cl	$2b$10$cJ0ucv8WvYx0w61NfDoWHuPoy4hC5sAH/hN7L5w21RawoQIRBoS4W	alumno	2026-04-05 01:47:59.605374	f	\N	\N	\N	f
19	Lady Natalie	Pino Ramirez	lp@alumno.cl	$2b$10$f9jihgQhcSbHgt4y/qrgoOQYtCa12r4Mzd8f65oIgcgDHJ/V1.y2y	alumno	2026-04-05 01:58:26.674288	f	\N	\N	\N	f
20	Elsa Del Carmen	Lopez Lizama	el@alumno.cl	$2b$10$qO6zsGZxztElRLyKvuTPtuGJ8jDU4fh3vu6HW6GNRpu/a3TMtQ.xO	alumno	2026-04-05 02:21:31.553039	f	\N	\N	\N	f
16	Juanita	Perez	c@profesor.cl	$2b$10$sc82NOUl2gA.mqCF3vH5CedGv0oGJvXzEsEqJLJwEb.UkOrSDfD82	docente	2026-04-05 00:19:05.995806	f	\N	Lenguaje y Comunicación	5° Básico A	t
\.


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 249
-- Name: alternativas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alternativas_id_seq', 1, false);


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 243
-- Name: alumnos_pendientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alumnos_pendientes_id_seq', 7, true);


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 223
-- Name: asignaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asignaciones_id_seq', 1, true);


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 245
-- Name: asignaciones_lectura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asignaciones_lectura_id_seq', 4, true);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 239
-- Name: canjes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.canjes_id_seq', 1, false);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 251
-- Name: cuestionarios_asignados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuestionarios_asignados_id_seq', 1, false);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 247
-- Name: cuestionarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuestionarios_id_seq', 1, false);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 217
-- Name: cursos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cursos_id_seq', 5, true);


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 241
-- Name: eventos_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eventos_log_id_seq', 59, true);


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 229
-- Name: intentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.intentos_id_seq', 12, true);


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 221
-- Name: lecturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lecturas_id_seq', 3, true);


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 219
-- Name: matriculas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matriculas_id_seq', 4, true);


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 227
-- Name: opciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.opciones_id_seq', 4, true);


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 225
-- Name: preguntas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.preguntas_id_seq', 2, true);


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 233
-- Name: progreso_lectura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.progreso_lectura_id_seq', 2, true);


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 237
-- Name: puntos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.puntos_id_seq', 9, true);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 235
-- Name: recompensas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recompensas_id_seq', 1, false);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 253
-- Name: respuestas_alumno_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.respuestas_alumno_id_seq', 1, false);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 231
-- Name: respuestas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.respuestas_id_seq', 20, true);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 215
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 20, true);


--
-- TOC entry 4928 (class 2606 OID 16703)
-- Name: alternativas alternativas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alternativas
    ADD CONSTRAINT alternativas_pkey PRIMARY KEY (id);


--
-- TOC entry 4916 (class 2606 OID 16648)
-- Name: alumnos_pendientes alumnos_pendientes_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumnos_pendientes
    ADD CONSTRAINT alumnos_pendientes_correo_key UNIQUE (correo);


--
-- TOC entry 4918 (class 2606 OID 16655)
-- Name: alumnos_pendientes alumnos_pendientes_correo_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumnos_pendientes
    ADD CONSTRAINT alumnos_pendientes_correo_unique UNIQUE (correo);


--
-- TOC entry 4920 (class 2606 OID 16646)
-- Name: alumnos_pendientes alumnos_pendientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumnos_pendientes
    ADD CONSTRAINT alumnos_pendientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4922 (class 2606 OID 16664)
-- Name: asignaciones_lectura asignaciones_lectura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones_lectura
    ADD CONSTRAINT asignaciones_lectura_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 16467)
-- Name: asignaciones asignaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones
    ADD CONSTRAINT asignaciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4912 (class 2606 OID 16608)
-- Name: canjes canjes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canjes
    ADD CONSTRAINT canjes_pkey PRIMARY KEY (id);


--
-- TOC entry 4930 (class 2606 OID 16716)
-- Name: cuestionarios_asignados cuestionarios_asignados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuestionarios_asignados
    ADD CONSTRAINT cuestionarios_asignados_pkey PRIMARY KEY (id);


--
-- TOC entry 4926 (class 2606 OID 16693)
-- Name: cuestionarios cuestionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuestionarios
    ADD CONSTRAINT cuestionarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4886 (class 2606 OID 16418)
-- Name: cursos cursos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);


--
-- TOC entry 4914 (class 2606 OID 16628)
-- Name: eventos_log eventos_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos_log
    ADD CONSTRAINT eventos_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4900 (class 2606 OID 16522)
-- Name: intentos intentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intentos
    ADD CONSTRAINT intentos_pkey PRIMARY KEY (id);


--
-- TOC entry 4892 (class 2606 OID 16454)
-- Name: lecturas lecturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturas
    ADD CONSTRAINT lecturas_pkey PRIMARY KEY (id);


--
-- TOC entry 4888 (class 2606 OID 16434)
-- Name: matriculas matriculas_alumno_id_curso_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matriculas
    ADD CONSTRAINT matriculas_alumno_id_curso_id_key UNIQUE (alumno_id, curso_id);


--
-- TOC entry 4890 (class 2606 OID 16432)
-- Name: matriculas matriculas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matriculas
    ADD CONSTRAINT matriculas_pkey PRIMARY KEY (id);


--
-- TOC entry 4898 (class 2606 OID 16507)
-- Name: opciones opciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opciones
    ADD CONSTRAINT opciones_pkey PRIMARY KEY (id);


--
-- TOC entry 4896 (class 2606 OID 16492)
-- Name: preguntas preguntas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);


--
-- TOC entry 4904 (class 2606 OID 16567)
-- Name: progreso_lectura progreso_lectura_alumno_id_lectura_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso_lectura
    ADD CONSTRAINT progreso_lectura_alumno_id_lectura_id_key UNIQUE (alumno_id, lectura_id);


--
-- TOC entry 4906 (class 2606 OID 16565)
-- Name: progreso_lectura progreso_lectura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso_lectura
    ADD CONSTRAINT progreso_lectura_pkey PRIMARY KEY (id);


--
-- TOC entry 4910 (class 2606 OID 16595)
-- Name: puntos puntos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntos
    ADD CONSTRAINT puntos_pkey PRIMARY KEY (id);


--
-- TOC entry 4908 (class 2606 OID 16587)
-- Name: recompensas recompensas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recompensas
    ADD CONSTRAINT recompensas_pkey PRIMARY KEY (id);


--
-- TOC entry 4933 (class 2606 OID 16731)
-- Name: respuestas_alumno respuestas_alumno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas_alumno
    ADD CONSTRAINT respuestas_alumno_pkey PRIMARY KEY (id);


--
-- TOC entry 4902 (class 2606 OID 16539)
-- Name: respuestas respuestas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);


--
-- TOC entry 4924 (class 2606 OID 16681)
-- Name: asignaciones_lectura unique_asignacion_lectura; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones_lectura
    ADD CONSTRAINT unique_asignacion_lectura UNIQUE (lectura_id, alumno_id, curso_id);


--
-- TOC entry 4882 (class 2606 OID 16411)
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- TOC entry 4884 (class 2606 OID 16409)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4931 (class 1259 OID 16733)
-- Name: uq_cuestionario_asignado_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_cuestionario_asignado_activo ON public.cuestionarios_asignados USING btree (cuestionario_id, curso_id, activo) WHERE (activo = true);


--
-- TOC entry 4958 (class 2606 OID 16704)
-- Name: alternativas alternativas_pregunta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alternativas
    ADD CONSTRAINT alternativas_pregunta_id_fkey FOREIGN KEY (pregunta_id) REFERENCES public.preguntas(id) ON DELETE CASCADE;


--
-- TOC entry 4954 (class 2606 OID 16649)
-- Name: alumnos_pendientes alumnos_pendientes_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumnos_pendientes
    ADD CONSTRAINT alumnos_pendientes_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE CASCADE;


--
-- TOC entry 4938 (class 2606 OID 16478)
-- Name: asignaciones asignaciones_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones
    ADD CONSTRAINT asignaciones_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4939 (class 2606 OID 16473)
-- Name: asignaciones asignaciones_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones
    ADD CONSTRAINT asignaciones_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE CASCADE;


--
-- TOC entry 4955 (class 2606 OID 16670)
-- Name: asignaciones_lectura asignaciones_lectura_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones_lectura
    ADD CONSTRAINT asignaciones_lectura_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4956 (class 2606 OID 16675)
-- Name: asignaciones_lectura asignaciones_lectura_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones_lectura
    ADD CONSTRAINT asignaciones_lectura_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE CASCADE;


--
-- TOC entry 4940 (class 2606 OID 16468)
-- Name: asignaciones asignaciones_lectura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones
    ADD CONSTRAINT asignaciones_lectura_id_fkey FOREIGN KEY (lectura_id) REFERENCES public.lecturas(id) ON DELETE CASCADE;


--
-- TOC entry 4957 (class 2606 OID 16665)
-- Name: asignaciones_lectura asignaciones_lectura_lectura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignaciones_lectura
    ADD CONSTRAINT asignaciones_lectura_lectura_id_fkey FOREIGN KEY (lectura_id) REFERENCES public.lecturas(id) ON DELETE CASCADE;


--
-- TOC entry 4951 (class 2606 OID 16609)
-- Name: canjes canjes_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canjes
    ADD CONSTRAINT canjes_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4952 (class 2606 OID 16614)
-- Name: canjes canjes_recompensa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canjes
    ADD CONSTRAINT canjes_recompensa_id_fkey FOREIGN KEY (recompensa_id) REFERENCES public.recompensas(id) ON DELETE CASCADE;


--
-- TOC entry 4959 (class 2606 OID 16717)
-- Name: cuestionarios_asignados cuestionarios_asignados_cuestionario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuestionarios_asignados
    ADD CONSTRAINT cuestionarios_asignados_cuestionario_id_fkey FOREIGN KEY (cuestionario_id) REFERENCES public.cuestionarios(id) ON DELETE CASCADE;


--
-- TOC entry 4934 (class 2606 OID 16419)
-- Name: cursos cursos_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.usuarios(id) ON DELETE SET NULL;


--
-- TOC entry 4953 (class 2606 OID 16629)
-- Name: eventos_log eventos_log_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos_log
    ADD CONSTRAINT eventos_log_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE SET NULL;


--
-- TOC entry 4943 (class 2606 OID 16523)
-- Name: intentos intentos_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intentos
    ADD CONSTRAINT intentos_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4944 (class 2606 OID 16528)
-- Name: intentos intentos_lectura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intentos
    ADD CONSTRAINT intentos_lectura_id_fkey FOREIGN KEY (lectura_id) REFERENCES public.lecturas(id) ON DELETE CASCADE;


--
-- TOC entry 4937 (class 2606 OID 16455)
-- Name: lecturas lecturas_creado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturas
    ADD CONSTRAINT lecturas_creado_por_fkey FOREIGN KEY (creado_por) REFERENCES public.usuarios(id) ON DELETE SET NULL;


--
-- TOC entry 4935 (class 2606 OID 16435)
-- Name: matriculas matriculas_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matriculas
    ADD CONSTRAINT matriculas_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4936 (class 2606 OID 16440)
-- Name: matriculas matriculas_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matriculas
    ADD CONSTRAINT matriculas_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id) ON DELETE CASCADE;


--
-- TOC entry 4942 (class 2606 OID 16508)
-- Name: opciones opciones_pregunta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opciones
    ADD CONSTRAINT opciones_pregunta_id_fkey FOREIGN KEY (pregunta_id) REFERENCES public.preguntas(id) ON DELETE CASCADE;


--
-- TOC entry 4941 (class 2606 OID 16493)
-- Name: preguntas preguntas_lectura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preguntas
    ADD CONSTRAINT preguntas_lectura_id_fkey FOREIGN KEY (lectura_id) REFERENCES public.lecturas(id) ON DELETE CASCADE;


--
-- TOC entry 4948 (class 2606 OID 16568)
-- Name: progreso_lectura progreso_lectura_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso_lectura
    ADD CONSTRAINT progreso_lectura_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4949 (class 2606 OID 16573)
-- Name: progreso_lectura progreso_lectura_lectura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso_lectura
    ADD CONSTRAINT progreso_lectura_lectura_id_fkey FOREIGN KEY (lectura_id) REFERENCES public.lecturas(id) ON DELETE CASCADE;


--
-- TOC entry 4950 (class 2606 OID 16596)
-- Name: puntos puntos_alumno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntos
    ADD CONSTRAINT puntos_alumno_id_fkey FOREIGN KEY (alumno_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4945 (class 2606 OID 16540)
-- Name: respuestas respuestas_intento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas
    ADD CONSTRAINT respuestas_intento_id_fkey FOREIGN KEY (intento_id) REFERENCES public.intentos(id) ON DELETE CASCADE;


--
-- TOC entry 4946 (class 2606 OID 16550)
-- Name: respuestas respuestas_opcion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas
    ADD CONSTRAINT respuestas_opcion_id_fkey FOREIGN KEY (opcion_id) REFERENCES public.opciones(id) ON DELETE CASCADE;


--
-- TOC entry 4947 (class 2606 OID 16545)
-- Name: respuestas respuestas_pregunta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas
    ADD CONSTRAINT respuestas_pregunta_id_fkey FOREIGN KEY (pregunta_id) REFERENCES public.preguntas(id) ON DELETE CASCADE;


-- Completed on 2026-04-27 20:32:13

--
-- PostgreSQL database dump complete
--

\unrestrict YCWhXzbg9Nm4eef9ktswozSQYe0wi3sz3dY1koP1zt0smVIsCrvjaYHri2gE4F3

