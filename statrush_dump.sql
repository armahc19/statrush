--
-- PostgreSQL database dump
--

\restrict 8JrPIm29pUGeXwYsXmcpUfI2YzTEBGun5Y94dvfKippK1ISllxdnhW6N6igQBzt

-- Dumped from database version 18.3 (Debian 18.3-1+b1)
-- Dumped by pg_dump version 18.3 (Debian 18.3-1+b1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: fixtures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fixtures (
    id bigint NOT NULL,
    home_team character varying(255),
    away_team character varying(255),
    group_name character varying(50),
    stage character varying(50),
    matchday integer,
    kickoff_time timestamp without time zone,
    status character varying(50),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.fixtures OWNER TO postgres;

--
-- Name: match_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_events (
    id bigint NOT NULL,
    event_type character varying(50) NOT NULL,
    minute integer,
    team_name character varying(255),
    player_name character varying(255),
    created_at timestamp without time zone DEFAULT now(),
    match_id integer
);


ALTER TABLE public.match_events OWNER TO postgres;

--
-- Name: match_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.match_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.match_events_id_seq OWNER TO postgres;

--
-- Name: match_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.match_events_id_seq OWNED BY public.match_events.id;


--
-- Name: match_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_results (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    home_team character varying(255),
    away_team character varying(255),
    home_score integer,
    away_score integer,
    result character varying(20),
    winner_team character varying(255),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.match_results OWNER TO postgres;

--
-- Name: match_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.match_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.match_results_id_seq OWNER TO postgres;

--
-- Name: match_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.match_results_id_seq OWNED BY public.match_results.id;


--
-- Name: player_rankings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player_rankings (
    id integer NOT NULL,
    player_id integer,
    rank integer,
    points integer DEFAULT 0,
    goals integer DEFAULT 0,
    assists integer DEFAULT 0,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.player_rankings OWNER TO postgres;

--
-- Name: player_rankings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.player_rankings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.player_rankings_id_seq OWNER TO postgres;

--
-- Name: player_rankings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.player_rankings_id_seq OWNED BY public.player_rankings.id;


--
-- Name: player_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player_stats (
    id bigint NOT NULL,
    player_name character varying(255),
    goals integer DEFAULT 0,
    assists integer DEFAULT 0,
    yellow_cards integer DEFAULT 0,
    red_cards integer DEFAULT 0,
    matches_played integer DEFAULT 0,
    updated_at timestamp without time zone DEFAULT now(),
    points integer DEFAULT 0,
    team_name character varying(100)
);


ALTER TABLE public.player_stats OWNER TO postgres;

--
-- Name: player_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.player_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.player_stats_id_seq OWNER TO postgres;

--
-- Name: player_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.player_stats_id_seq OWNED BY public.player_stats.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    "position" character varying(50),
    team_name character varying(255),
    nationality character varying(100),
    created_at timestamp without time zone DEFAULT now(),
    goals integer DEFAULT 0,
    yellow_cards integer DEFAULT 0,
    red_cards integer DEFAULT 0,
    points integer DEFAULT 0,
    updated_at timestamp without time zone DEFAULT now(),
    name_norm text,
    assists integer DEFAULT 0
);


ALTER TABLE public.players OWNER TO postgres;

--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.players_id_seq OWNER TO postgres;

--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.players_id_seq OWNED BY public.players.id;


--
-- Name: team_rankings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_rankings (
    id integer NOT NULL,
    team_id integer,
    rank integer,
    points integer DEFAULT 0,
    goal_difference integer DEFAULT 0,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.team_rankings OWNER TO postgres;

--
-- Name: team_rankings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_rankings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_rankings_id_seq OWNER TO postgres;

--
-- Name: team_rankings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_rankings_id_seq OWNED BY public.team_rankings.id;


--
-- Name: team_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_stats (
    id bigint NOT NULL,
    team_name character varying(255) NOT NULL,
    goals_scored integer DEFAULT 0,
    goals_conceded integer DEFAULT 0,
    wins integer DEFAULT 0,
    losses integer DEFAULT 0,
    draws integer DEFAULT 0,
    matches_played integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    points integer DEFAULT 0
);


ALTER TABLE public.team_stats OWNER TO postgres;

--
-- Name: team_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_stats_id_seq OWNER TO postgres;

--
-- Name: team_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_stats_id_seq OWNED BY public.team_stats.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teams_id_seq OWNER TO postgres;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: match_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_events ALTER COLUMN id SET DEFAULT nextval('public.match_events_id_seq'::regclass);


--
-- Name: match_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_results ALTER COLUMN id SET DEFAULT nextval('public.match_results_id_seq'::regclass);


--
-- Name: player_rankings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_rankings ALTER COLUMN id SET DEFAULT nextval('public.player_rankings_id_seq'::regclass);


--
-- Name: player_stats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats ALTER COLUMN id SET DEFAULT nextval('public.player_stats_id_seq'::regclass);


--
-- Name: players id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players ALTER COLUMN id SET DEFAULT nextval('public.players_id_seq'::regclass);


--
-- Name: team_rankings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_rankings ALTER COLUMN id SET DEFAULT nextval('public.team_rankings_id_seq'::regclass);


--
-- Name: team_stats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_stats ALTER COLUMN id SET DEFAULT nextval('public.team_stats_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Data for Name: fixtures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fixtures (id, home_team, away_team, group_name, stage, matchday, kickoff_time, status, created_at) FROM stdin;
537334	Qatar	Switzerland	GROUP_B	GROUP_STAGE	1	2026-06-13 19:00:00	TIMED	2026-06-09 08:33:37.94165
537339	Brazil	Morocco	GROUP_C	GROUP_STAGE	1	2026-06-13 22:00:00	TIMED	2026-06-09 08:33:37.94165
537340	Haiti	Scotland	GROUP_C	GROUP_STAGE	1	2026-06-14 01:00:00	TIMED	2026-06-09 08:33:37.94165
537346	Australia	Turkey	GROUP_D	GROUP_STAGE	1	2026-06-14 04:00:00	TIMED	2026-06-09 08:33:37.94165
537351	Germany	Curaçao	GROUP_E	GROUP_STAGE	1	2026-06-14 17:00:00	TIMED	2026-06-09 08:33:37.94165
537357	Netherlands	Japan	GROUP_F	GROUP_STAGE	1	2026-06-14 20:00:00	TIMED	2026-06-09 08:33:37.94165
537352	Ivory Coast	Ecuador	GROUP_E	GROUP_STAGE	1	2026-06-14 23:00:00	TIMED	2026-06-09 08:33:37.94165
537358	Sweden	Tunisia	GROUP_F	GROUP_STAGE	1	2026-06-15 02:00:00	TIMED	2026-06-09 08:33:37.94165
537369	Spain	Cape Verde Islands	GROUP_H	GROUP_STAGE	1	2026-06-15 16:00:00	TIMED	2026-06-09 08:33:37.94165
537363	Belgium	Egypt	GROUP_G	GROUP_STAGE	1	2026-06-15 19:00:00	TIMED	2026-06-09 08:33:37.94165
537370	Saudi Arabia	Uruguay	GROUP_H	GROUP_STAGE	1	2026-06-15 22:00:00	TIMED	2026-06-09 08:33:37.94165
537364	Iran	New Zealand	GROUP_G	GROUP_STAGE	1	2026-06-16 01:00:00	TIMED	2026-06-09 08:33:37.94165
537391	France	Senegal	GROUP_I	GROUP_STAGE	1	2026-06-16 19:00:00	TIMED	2026-06-09 08:33:37.94165
537392	Iraq	Norway	GROUP_I	GROUP_STAGE	1	2026-06-16 22:00:00	TIMED	2026-06-09 08:33:37.94165
537397	Argentina	Algeria	GROUP_J	GROUP_STAGE	1	2026-06-17 01:00:00	TIMED	2026-06-09 08:33:37.94165
537398	Austria	Jordan	GROUP_J	GROUP_STAGE	1	2026-06-17 04:00:00	TIMED	2026-06-09 08:33:37.94165
537403	Portugal	Congo DR	GROUP_K	GROUP_STAGE	1	2026-06-17 17:00:00	TIMED	2026-06-09 08:33:37.94165
537409	England	Croatia	GROUP_L	GROUP_STAGE	1	2026-06-17 20:00:00	TIMED	2026-06-09 08:33:37.94165
537410	Ghana	Panama	GROUP_L	GROUP_STAGE	1	2026-06-17 23:00:00	TIMED	2026-06-09 08:33:37.94165
537404	Uzbekistan	Colombia	GROUP_K	GROUP_STAGE	1	2026-06-18 02:00:00	TIMED	2026-06-09 08:33:37.94165
537329	Czechia	South Africa	GROUP_A	GROUP_STAGE	2	2026-06-18 16:00:00	TIMED	2026-06-09 08:33:37.94165
537335	Switzerland	Bosnia-Herzegovina	GROUP_B	GROUP_STAGE	2	2026-06-18 19:00:00	TIMED	2026-06-09 08:33:37.94165
537336	Canada	Qatar	GROUP_B	GROUP_STAGE	2	2026-06-18 22:00:00	TIMED	2026-06-09 08:33:37.94165
537330	Mexico	South Korea	GROUP_A	GROUP_STAGE	2	2026-06-19 01:00:00	TIMED	2026-06-09 08:33:37.94165
537348	United States	Australia	GROUP_D	GROUP_STAGE	2	2026-06-19 19:00:00	TIMED	2026-06-09 08:33:37.94165
537342	Scotland	Morocco	GROUP_C	GROUP_STAGE	2	2026-06-19 22:00:00	TIMED	2026-06-09 08:33:37.94165
537341	Brazil	Haiti	GROUP_C	GROUP_STAGE	2	2026-06-20 00:30:00	TIMED	2026-06-09 08:33:37.94165
537347	Turkey	Paraguay	GROUP_D	GROUP_STAGE	2	2026-06-20 03:00:00	TIMED	2026-06-09 08:33:37.94165
537359	Netherlands	Sweden	GROUP_F	GROUP_STAGE	2	2026-06-20 17:00:00	TIMED	2026-06-09 08:33:37.94165
537353	Germany	Ivory Coast	GROUP_E	GROUP_STAGE	2	2026-06-20 20:00:00	TIMED	2026-06-09 08:33:37.94165
537354	Ecuador	Curaçao	GROUP_E	GROUP_STAGE	2	2026-06-21 00:00:00	TIMED	2026-06-09 08:33:37.94165
537360	Tunisia	Japan	GROUP_F	GROUP_STAGE	2	2026-06-21 04:00:00	TIMED	2026-06-09 08:33:37.94165
537371	Spain	Saudi Arabia	GROUP_H	GROUP_STAGE	2	2026-06-21 16:00:00	TIMED	2026-06-09 08:33:37.94165
537365	Belgium	Iran	GROUP_G	GROUP_STAGE	2	2026-06-21 19:00:00	TIMED	2026-06-09 08:33:37.94165
537372	Uruguay	Cape Verde Islands	GROUP_H	GROUP_STAGE	2	2026-06-21 22:00:00	TIMED	2026-06-09 08:33:37.94165
537366	New Zealand	Egypt	GROUP_G	GROUP_STAGE	2	2026-06-22 01:00:00	TIMED	2026-06-09 08:33:37.94165
537399	Argentina	Austria	GROUP_J	GROUP_STAGE	2	2026-06-22 17:00:00	TIMED	2026-06-09 08:33:37.94165
537393	France	Iraq	GROUP_I	GROUP_STAGE	2	2026-06-22 21:00:00	TIMED	2026-06-09 08:33:37.94165
537394	Norway	Senegal	GROUP_I	GROUP_STAGE	2	2026-06-23 00:00:00	TIMED	2026-06-09 08:33:37.94165
537400	Jordan	Algeria	GROUP_J	GROUP_STAGE	2	2026-06-23 03:00:00	TIMED	2026-06-09 08:33:37.94165
537405	Portugal	Uzbekistan	GROUP_K	GROUP_STAGE	2	2026-06-23 17:00:00	TIMED	2026-06-09 08:33:37.94165
537411	England	Ghana	GROUP_L	GROUP_STAGE	2	2026-06-23 20:00:00	TIMED	2026-06-09 08:33:37.94165
537412	Panama	Croatia	GROUP_L	GROUP_STAGE	2	2026-06-23 23:00:00	TIMED	2026-06-09 08:33:37.94165
537406	Colombia	Congo DR	GROUP_K	GROUP_STAGE	2	2026-06-24 02:00:00	TIMED	2026-06-09 08:33:37.94165
537337	Switzerland	Canada	GROUP_B	GROUP_STAGE	3	2026-06-24 19:00:00	TIMED	2026-06-09 08:33:37.94165
537338	Bosnia-Herzegovina	Qatar	GROUP_B	GROUP_STAGE	3	2026-06-24 19:00:00	TIMED	2026-06-09 08:33:37.94165
537344	Morocco	Haiti	GROUP_C	GROUP_STAGE	3	2026-06-24 22:00:00	TIMED	2026-06-09 08:33:37.94165
537343	Scotland	Brazil	GROUP_C	GROUP_STAGE	3	2026-06-24 22:00:00	TIMED	2026-06-09 08:33:37.94165
537331	Czechia	Mexico	GROUP_A	GROUP_STAGE	3	2026-06-25 01:00:00	TIMED	2026-06-09 08:33:37.94165
537332	South Africa	South Korea	GROUP_A	GROUP_STAGE	3	2026-06-25 01:00:00	TIMED	2026-06-09 08:33:37.94165
537355	Ecuador	Germany	GROUP_E	GROUP_STAGE	3	2026-06-25 20:00:00	TIMED	2026-06-09 08:33:37.94165
537356	Curaçao	Ivory Coast	GROUP_E	GROUP_STAGE	3	2026-06-25 20:00:00	TIMED	2026-06-09 08:33:37.94165
537361	Tunisia	Netherlands	GROUP_F	GROUP_STAGE	3	2026-06-25 23:00:00	TIMED	2026-06-09 08:33:37.94165
537362	Japan	Sweden	GROUP_F	GROUP_STAGE	3	2026-06-25 23:00:00	TIMED	2026-06-09 08:33:37.94165
537349	Turkey	United States	GROUP_D	GROUP_STAGE	3	2026-06-26 02:00:00	TIMED	2026-06-09 08:33:37.94165
537350	Paraguay	Australia	GROUP_D	GROUP_STAGE	3	2026-06-26 02:00:00	TIMED	2026-06-09 08:33:37.94165
537395	Norway	France	GROUP_I	GROUP_STAGE	3	2026-06-26 19:00:00	TIMED	2026-06-09 08:33:37.94165
537396	Senegal	Iraq	GROUP_I	GROUP_STAGE	3	2026-06-26 19:00:00	TIMED	2026-06-09 08:33:37.94165
537373	Uruguay	Spain	GROUP_H	GROUP_STAGE	3	2026-06-27 00:00:00	TIMED	2026-06-09 08:33:37.94165
537374	Cape Verde Islands	Saudi Arabia	GROUP_H	GROUP_STAGE	3	2026-06-27 00:00:00	TIMED	2026-06-09 08:33:37.94165
537367	New Zealand	Belgium	GROUP_G	GROUP_STAGE	3	2026-06-27 03:00:00	TIMED	2026-06-09 08:33:37.94165
537368	Egypt	Iran	GROUP_G	GROUP_STAGE	3	2026-06-27 03:00:00	TIMED	2026-06-09 08:33:37.94165
537413	Panama	England	GROUP_L	GROUP_STAGE	3	2026-06-27 21:00:00	TIMED	2026-06-09 08:33:37.94165
537414	Croatia	Ghana	GROUP_L	GROUP_STAGE	3	2026-06-27 21:00:00	TIMED	2026-06-09 08:33:37.94165
537407	Colombia	Portugal	GROUP_K	GROUP_STAGE	3	2026-06-27 23:30:00	TIMED	2026-06-09 08:33:37.94165
537408	Congo DR	Uzbekistan	GROUP_K	GROUP_STAGE	3	2026-06-27 23:30:00	TIMED	2026-06-09 08:33:37.94165
537401	Jordan	Argentina	GROUP_J	GROUP_STAGE	3	2026-06-28 02:00:00	TIMED	2026-06-09 08:33:37.94165
537402	Algeria	Austria	GROUP_J	GROUP_STAGE	3	2026-06-28 02:00:00	TIMED	2026-06-09 08:33:37.94165
537417	\N	\N	\N	LAST_32	\N	2026-06-28 19:00:00	TIMED	2026-06-09 08:33:37.94165
537423	\N	\N	\N	LAST_32	\N	2026-06-29 17:00:00	TIMED	2026-06-09 08:33:37.94165
537415	\N	\N	\N	LAST_32	\N	2026-06-29 20:30:00	TIMED	2026-06-09 08:33:37.94165
537418	\N	\N	\N	LAST_32	\N	2026-06-30 01:00:00	TIMED	2026-06-09 08:33:37.94165
537424	\N	\N	\N	LAST_32	\N	2026-06-30 17:00:00	TIMED	2026-06-09 08:33:37.94165
537416	\N	\N	\N	LAST_32	\N	2026-06-30 21:00:00	TIMED	2026-06-09 08:33:37.94165
537425	\N	\N	\N	LAST_32	\N	2026-07-01 01:00:00	TIMED	2026-06-09 08:33:37.94165
537328	South Korea	Czechia	GROUP_A	GROUP_STAGE	1	2026-06-12 02:00:00	completed	2026-06-09 08:33:37.94165
537333	Canada	Bosnia-Herzegovina	GROUP_B	GROUP_STAGE	1	2026-06-12 19:00:00	completed	2026-06-09 08:33:37.94165
537345	United States	Paraguay	GROUP_D	GROUP_STAGE	1	2026-06-13 01:00:00	completed	2026-06-09 08:33:37.94165
537426	\N	\N	\N	LAST_32	\N	2026-07-01 16:00:00	TIMED	2026-06-09 08:33:37.94165
537422	\N	\N	\N	LAST_32	\N	2026-07-01 20:00:00	TIMED	2026-06-09 08:33:37.94165
537421	\N	\N	\N	LAST_32	\N	2026-07-02 00:00:00	TIMED	2026-06-09 08:33:37.94165
537420	\N	\N	\N	LAST_32	\N	2026-07-02 19:00:00	TIMED	2026-06-09 08:33:37.94165
537419	\N	\N	\N	LAST_32	\N	2026-07-02 23:00:00	TIMED	2026-06-09 08:33:37.94165
537429	\N	\N	\N	LAST_32	\N	2026-07-03 03:00:00	TIMED	2026-06-09 08:33:37.94165
537428	\N	\N	\N	LAST_32	\N	2026-07-03 18:00:00	TIMED	2026-06-09 08:33:37.94165
537427	\N	\N	\N	LAST_32	\N	2026-07-03 22:00:00	TIMED	2026-06-09 08:33:37.94165
537430	\N	\N	\N	LAST_32	\N	2026-07-04 01:30:00	TIMED	2026-06-09 08:33:37.94165
537376	\N	\N	\N	LAST_16	\N	2026-07-04 17:00:00	TIMED	2026-06-09 08:33:37.94165
537375	\N	\N	\N	LAST_16	\N	2026-07-04 21:00:00	TIMED	2026-06-09 08:33:37.94165
537377	\N	\N	\N	LAST_16	\N	2026-07-05 20:00:00	TIMED	2026-06-09 08:33:37.94165
537378	\N	\N	\N	LAST_16	\N	2026-07-06 00:00:00	TIMED	2026-06-09 08:33:37.94165
537379	\N	\N	\N	LAST_16	\N	2026-07-06 19:00:00	TIMED	2026-06-09 08:33:37.94165
537380	\N	\N	\N	LAST_16	\N	2026-07-07 00:00:00	TIMED	2026-06-09 08:33:37.94165
537381	\N	\N	\N	LAST_16	\N	2026-07-07 16:00:00	TIMED	2026-06-09 08:33:37.94165
537382	\N	\N	\N	LAST_16	\N	2026-07-07 20:00:00	TIMED	2026-06-09 08:33:37.94165
537383	\N	\N	\N	QUARTER_FINALS	\N	2026-07-09 20:00:00	TIMED	2026-06-09 08:33:37.94165
537384	\N	\N	\N	QUARTER_FINALS	\N	2026-07-10 19:00:00	TIMED	2026-06-09 08:33:37.94165
537385	\N	\N	\N	QUARTER_FINALS	\N	2026-07-11 21:00:00	TIMED	2026-06-09 08:33:37.94165
537386	\N	\N	\N	QUARTER_FINALS	\N	2026-07-12 01:00:00	TIMED	2026-06-09 08:33:37.94165
537387	\N	\N	\N	SEMI_FINALS	\N	2026-07-14 19:00:00	TIMED	2026-06-09 08:33:37.94165
537388	\N	\N	\N	SEMI_FINALS	\N	2026-07-15 19:00:00	TIMED	2026-06-09 08:33:37.94165
537389	\N	\N	\N	THIRD_PLACE	\N	2026-07-18 21:00:00	TIMED	2026-06-09 08:33:37.94165
537390	\N	\N	\N	FINAL	\N	2026-07-19 19:00:00	TIMED	2026-06-09 08:33:37.94165
537327	Mexico	South Africa	GROUP_A	GROUP_STAGE	1	2026-06-11 19:00:00	completed	2026-06-09 08:33:37.94165
\.


--
-- Data for Name: match_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.match_events (id, event_type, minute, team_name, player_name, created_at, match_id) FROM stdin;
146	GOAL	9	Mexico	Julian Quinones	2026-06-16 11:34:59.983529	537327
147	ASSIST	9	Mexico	Erik Lira	2026-06-16 11:34:59.983529	537327
148	YELLOW_CARD	17	South Africa	Teboho Mokoena	2026-06-16 11:34:59.983529	537327
149	YELLOW_CARD	23	Mexico	Brian Gutierrez	2026-06-16 11:34:59.983529	537327
150	RED_CARD	50	South Africa	Sphephelo Sithole	2026-06-16 11:34:59.983529	537327
151	GOAL	67	Mexico	Raul Jimenez	2026-06-16 11:34:59.983529	537327
152	ASSIST	67	Mexico	Roberto Alvarado	2026-06-16 11:34:59.983529	537327
153	YELLOW_CARD	74	South Africa	Nkosinathi Sibisi	2026-06-16 11:34:59.983529	537327
154	RED_CARD	84	South Africa	Themba Zwane	2026-06-16 11:34:59.983529	537327
155	RED_CARD	92	Mexico	Cesar Montes	2026-06-16 11:34:59.983529	537327
156	GOAL	59	Czechia	Ladislav Krejci	2026-06-16 11:54:57.447647	537328
157	ASSIST	59	Czechia	Vladimir Coufal	2026-06-16 11:54:57.447647	537328
158	GOAL	67	South Korea	Hwang In-beom	2026-06-16 11:54:57.447647	537328
159	ASSIST	67	South Korea	Lee Kang-in	2026-06-16 11:54:57.447647	537328
160	GOAL	80	South Korea	Oh Hyeon-gyu	2026-06-16 11:54:57.447647	537328
161	ASSIST	80	South Korea	Hwang In-beom	2026-06-16 11:54:57.447647	537328
162	YELLOW_CARD	96	South Korea	Lee Gi-hyuk	2026-06-16 11:54:57.447647	537328
163	YELLOW_CARD	11	Canada	Alistair Johnston	2026-06-16 12:04:02.287983	537333
164	GOAL	21	Bosnia-Herzegovina	Jovo Lukic	2026-06-16 12:04:02.287983	537333
165	ASSIST	21	Bosnia-Herzegovina	Sead Kolasinac	2026-06-16 12:04:02.287983	537333
166	YELLOW_CARD	41	Bosnia-Herzegovina	Jovo Lukic	2026-06-16 12:04:02.287983	537333
167	YELLOW_CARD	45	Bosnia-Herzegovina	Ermedin Demirovic	2026-06-16 12:04:02.287983	537333
168	YELLOW_CARD	53	Canada	Luc De Fougerolles	2026-06-16 12:04:02.287983	537333
169	GOAL	78	Canada	Cyle Larin	2026-06-16 12:04:02.287983	537333
170	ASSIST	78	Canada	Promise David	2026-06-16 12:04:02.287983	537333
171	YELLOW_CARD	93	Bosnia-Herzegovina	Nikola Katic	2026-06-16 12:04:02.287983	537333
173	GOAL	7	United States	Christian Pulisic	2026-06-16 12:20:37.65415	537345
174	YELLOW_CARD	10	Paraguay	Juan Jose Caceres	2026-06-16 12:20:37.65415	537345
175	GOAL	31	United States	Folarin Balogun	2026-06-16 12:20:37.65415	537345
176	ASSIST	31	United States	Christian Pulisic	2026-06-16 12:20:37.65415	537345
177	GOAL	50	United States	Folarin Balogun	2026-06-16 12:20:37.65415	537345
178	ASSIST	50	United States	Malik Tillman	2026-06-16 12:20:37.65415	537345
179	YELLOW_CARD	53	Paraguay	Miguel Almiron	2026-06-16 12:20:37.65415	537345
180	YELLOW_CARD	59	United States	Tyler Adams	2026-06-16 12:20:37.65415	537345
181	GOAL	73	Paraguay	Mauricio	2026-06-16 12:20:37.65415	537345
182	ASSIST	73	Paraguay	Julio Enciso	2026-06-16 12:20:37.65415	537345
183	YELLOW_CARD	79	Paraguay	Diego Gomez	2026-06-16 12:20:37.65415	537345
184	YELLOW_CARD	88	Paraguay	Alex Arce	2026-06-16 12:20:37.65415	537345
185	YELLOW_CARD	93	Paraguay	Junior Alonso	2026-06-16 12:20:37.65415	537345
186	GOAL	98	United States	Gio Reyna	2026-06-16 12:20:37.65415	537345
187	ASSIST	98	United States	Alex Freeman	2026-06-16 12:20:37.65415	537345
\.


--
-- Data for Name: match_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.match_results (id, event_id, home_team, away_team, home_score, away_score, result, winner_team, created_at) FROM stdin;
583	537327	Mexico	South Africa	2	0	HOME_WIN	Mexico	2026-06-16 11:34:59.983529
584	537328	South Korea	Czechia	2	1	HOME_WIN	South Korea	2026-06-16 11:54:57.447647
585	537333	Canada	Bosnia-Herzegovina	1	1	DRAW	\N	2026-06-16 12:04:02.287983
586	537345	United States	Paraguay	4	1	HOME_WIN	United States	2026-06-16 12:20:37.65415
\.


--
-- Data for Name: player_rankings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.player_rankings (id, player_id, rank, points, goals, assists, updated_at) FROM stdin;
27	1258	1	8	2	0	2026-06-16 12:20:37.65415
5	1247	2	7	1	1	2026-06-16 12:20:37.65415
29	1256	2	7	1	1	2026-06-16 12:20:37.65415
8	1249	4	4	1	0	2026-06-16 12:20:37.65415
19	838	4	4	1	0	2026-06-16 12:20:37.65415
2	1244	4	4	1	0	2026-06-16 12:20:37.65415
7	1246	4	4	1	0	2026-06-16 12:20:37.65415
34	1264	4	4	1	0	2026-06-16 12:20:37.65415
35	93	4	4	1	0	2026-06-16 12:20:37.65415
1	1242	4	4	1	0	2026-06-16 12:20:37.65415
20	1251	11	3	1	0	2026-06-16 12:20:37.65415
38	1259	12	3	0	1	2026-06-16 12:20:37.65415
39	102	12	3	0	1	2026-06-16 12:20:37.65415
4	255	12	3	0	1	2026-06-16 12:20:37.65415
41	1265	12	3	0	1	2026-06-16 12:20:37.65415
11	548	12	3	0	1	2026-06-16 12:20:37.65415
3	248	12	3	0	1	2026-06-16 12:20:37.65415
21	1253	12	3	0	1	2026-06-16 12:20:37.65415
10	1248	12	3	0	1	2026-06-16 12:20:37.65415
22	1252	12	3	0	1	2026-06-16 12:20:37.65415
\.


--
-- Data for Name: player_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.player_stats (id, player_name, goals, assists, yellow_cards, red_cards, matches_played, updated_at, points, team_name) FROM stdin;
1	Messi	2	0	0	0	0	2026-06-05 10:58:15.124388	10	Argentina
2	Bellingham	0	0	1	0	0	2026-06-05 10:58:15.124388	-1	\N
3	Griezmann	3	0	0	0	0	2026-06-05 10:58:15.124388	15	France
4	Mbappe	3	0	0	0	0	2026-06-05 10:58:15.124388	15	France
5	Ronaldo	1	0	0	0	0	2026-06-05 10:58:15.124388	5	Portugal
7	Ferran Torres	1	0	0	0	0	2026-06-05 10:58:15.124388	5	Spain
8	Pedri	1	0	0	0	0	2026-06-05 10:58:15.124388	5	Spain
9	Otamendi	0	0	2	0	0	2026-06-05 10:58:15.124388	-2	Argentina
10	Rashford	0	0	0	1	0	2026-06-05 10:58:15.124388	-3	\N
11	Pepe	0	0	1	0	0	2026-06-05 10:58:15.124388	-1	\N
12	Kimmich	0	0	3	0	0	2026-06-05 10:58:15.124388	-3	\N
13	Musiala	3	0	0	0	0	2026-06-05 10:58:15.124388	15	Germany
14	Rodrygo	2	0	0	0	0	2026-06-05 10:58:15.124388	10	Brazil
15	Vinicius Jr	2	0	0	0	0	2026-06-05 10:58:15.124388	10	Brazil
6	Chiesa	1	0	0	0	0	2026-06-05 10:58:15.124388	8	Italy
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.players (id, name, "position", team_name, nationality, created_at, goals, yellow_cards, red_cards, points, updated_at, name_norm, assists) FROM stdin;
938	José Fajardo	Offence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jose fajardo	0
939	Ismael Díaz	Offence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ismael diaz	0
941	Azarias Londoño	Offence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	azarias londono	0
942	Márcio Rosa	Goalkeeper	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marcio rosa	0
943	Vózinha	Goalkeeper	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	vozinha	0
1034	Yusuf Abdurisag	Midfield	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yusuf abdurisag	0
1035	Ahmed Al Ganehi	Midfield	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed al ganehi	0
1036	Tahsin Jamshid	Midfield	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tahsin jamshid	0
1037	Mohamed Al Banna	Midfield	Qatar	Bahrain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohamed al banna	0
1040	Mohammed Muntari	Offence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohammed muntari	0
1041	Hassan Al Haydos	Offence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hassan al haydos	0
1042	Ahmed Alaa Eldin	Offence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed alaa eldin	0
1044	Yazeed Abulaila	Goalkeeper	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yazeed abulaila	0
25	Agustín Canobbio	Offence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	agustin canobbio	0
184	Rui Silva	Goalkeeper	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rui silva	0
185	Diogo Costa	Goalkeeper	Portugal	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	diogo costa	0
186	João Cancelo	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joao cancelo	0
187	Rúben Dias	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ruben dias	0
1242	Julian Quinones	MF	Mexico	\N	2026-06-16 11:34:59.983529	1	0	0	4	2026-06-16 11:34:59.983529	\N	0
1243	Brian Gutierrez	MF	Mexico	\N	2026-06-16 11:34:59.983529	0	1	0	-1	2026-06-16 11:34:59.983529	\N	0
1244	Raul Jimenez	MF	Mexico	\N	2026-06-16 11:34:59.983529	1	0	0	4	2026-06-16 11:34:59.983529	\N	0
1245	Cesar Montes	MF	Mexico	\N	2026-06-16 11:34:59.983529	0	0	1	-3	2026-06-16 11:34:59.983529	\N	0
1246	Ladislav Krejci	MF	Czechia	\N	2026-06-16 11:54:57.447647	1	0	0	4	2026-06-16 11:54:57.447647	\N	0
1248	Lee Kang-in	MF	South Korea	\N	2026-06-16 11:54:57.447647	0	0	0	3	2026-06-16 11:54:57.447647	\N	1
1249	Oh Hyeon-gyu	MF	South Korea	\N	2026-06-16 11:54:57.447647	1	0	0	4	2026-06-16 11:54:57.447647	\N	0
1247	Hwang In-beom	MF	South Korea	\N	2026-06-16 11:54:57.447647	1	0	0	7	2026-06-16 11:54:57.447647	\N	1
1250	Lee Gi-hyuk	MF	South Korea	\N	2026-06-16 11:54:57.447647	0	1	0	-1	2026-06-16 11:54:57.447647	\N	0
1252	Sead Kolasinac	MF	Bosnia-Herzegovina	\N	2026-06-16 12:04:02.287983	0	0	0	3	2026-06-16 12:04:02.287983	\N	1
1251	Jovo Lukic	MF	Bosnia-Herzegovina	\N	2026-06-16 12:04:02.287983	1	1	0	3	2026-06-16 12:04:02.287983	\N	0
827	Luc De Fougerolles	Defence	Canada	England	2026-06-04 14:35:02.161848	0	1	0	-1	2026-06-16 12:04:02.287983	luc de fougerolles	0
1253	Promise David	MF	Canada	\N	2026-06-16 12:04:02.287983	0	0	0	3	2026-06-16 12:04:02.287983	\N	1
1254	Nikola Katic	MF	Bosnia-Herzegovina	\N	2026-06-16 12:04:02.287983	0	1	0	-1	2026-06-16 12:04:02.287983	\N	0
1257	Juan Jose Caceres	MF	Paraguay	\N	2026-06-16 12:20:37.65415	0	1	0	-1	2026-06-16 12:20:37.65415	\N	0
1256	Christian Pulisic	MF	United States	\N	2026-06-16 12:20:37.65415	1	0	0	7	2026-06-16 12:20:37.65415	\N	1
1258	Folarin Balogun	MF	United States	\N	2026-06-16 12:20:37.65415	2	0	0	8	2026-06-16 12:20:37.65415	\N	0
1259	Malik Tillman	MF	United States	\N	2026-06-16 12:20:37.65415	0	0	0	3	2026-06-16 12:20:37.65415	\N	1
298	Alex Freeman	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alex freeman	0
1260	Miguel Almiron	MF	Paraguay	\N	2026-06-16 12:20:37.65415	0	1	0	-1	2026-06-16 12:20:37.65415	\N	0
1261	Tyler Adams	MF	United States	\N	2026-06-16 12:20:37.65415	0	1	0	-1	2026-06-16 12:20:37.65415	\N	0
102	Julio Enciso	Offence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	3	2026-06-16 12:20:37.65415	julio enciso	1
1262	Diego Gomez	MF	Paraguay	\N	2026-06-16 12:20:37.65415	0	1	0	-1	2026-06-16 12:20:37.65415	\N	0
1263	Junior Alonso	MF	Paraguay	\N	2026-06-16 12:20:37.65415	0	1	0	-1	2026-06-16 12:20:37.65415	\N	0
1264	Gio Reyna	MF	United States	\N	2026-06-16 12:20:37.65415	1	0	0	4	2026-06-16 12:20:37.65415	\N	0
1265	Alex Freeman	MF	United States	\N	2026-06-16 12:20:37.65415	0	0	0	3	2026-06-16 12:20:37.65415	\N	1
300	Alejandro Zendejas	Midfield	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alejandro zendejas	0
190	Matheus Nunes	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matheus nunes	0
911	Ermedin Demirovic	Offence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	1	0	-1	2026-06-16 12:04:02.287983	ermedin demirovic	0
191	Nuno Mendes	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nuno mendes	0
192	Gonçalo Inácio	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	goncalo inacio	0
193	Tomas Araujo	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tomas araujo	0
194	Renato Veiga	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	renato veiga	0
195	Bernardo Silva	Midfield	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bernardo silva	0
196	Rúben Neves	Midfield	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ruben neves	0
197	Bruno Fernandes	Midfield	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bruno fernandes	0
198	Gonçalo Guedes	Midfield	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	goncalo guedes	0
199	Samuel Almeida Costa	Midfield	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	samuel almeida costa	0
201	Joao Neves	Midfield	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joao neves	0
45	Aleksandar Pavlović	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aleksandar pavlovic	0
46	Lennart Karl	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lennart karl	0
47	Kai Havertz	Offence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kai havertz	0
48	Leroy Sané	Offence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leroy sane	0
188	Nélson Semedo	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nelson semedo	0
189	Diogo Dalot	Defence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	diogo dalot	0
337	Ji-sung Eom	Offence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jisung eom	0
338	Brice Samba	Goalkeeper	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brice samba	0
339	Mike Maignan	Goalkeeper	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mike maignan	0
340	Robin Risser	Goalkeeper	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	robin risser	0
341	Theo Hernández	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	theo hernandez	0
342	Lucas Digne	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lucas digne	0
343	Lucas Hernández	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lucas hernandez	0
344	Jules Koundé	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jules kounde	0
346	Ibrahima Konaté	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrahima konate	0
347	William Saliba	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	william saliba	0
348	Maxence Lacroix	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	maxence lacroix	0
349	Malo Gusto	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	malo gusto	0
350	N'Golo Kanté	Midfield	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ngolo kante	0
351	Adrien Rabiot	Midfield	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	adrien rabiot	0
137	Abdul Mumin	Defence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdul mumin	0
352	Aurélien Tchouameni	Midfield	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aurelien tchouameni	0
353	Manu Koné	Midfield	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	manu kone	0
354	Rayan Cherki	Midfield	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rayan cherki	0
355	Maghnes Akliouche	Midfield	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	maghnes akliouche	0
356	Desire Doue	Midfield	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	desire doue	0
357	Warren Zaïre-Emery	Midfield	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	warren zaireemery	0
358	Jean-Philippe Mateta	Offence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jeanphilippe mateta	0
301	Cristian Roldan	Midfield	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cristian roldan	0
302	Tyler Adams	Midfield	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tyler adams	0
52	Maximilian Beier	Offence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	maximilian beier	0
359	Ousmane Dembélé	Offence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ousmane dembele	0
910	Jovo Lukić	Offence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jovo lukic	0
912	Haris Tabaković	Offence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	haris tabakovic	0
309	Haji Wright	Offence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	haji wright	0
310	Ricardo Pepi	Offence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ricardo pepi	0
58	Alejandro Grimaldo	Defence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alejandro grimaldo	0
913	Samed Bazdar	Offence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	samed bazdar	0
368	Nkosinathi Sibisi	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	1	0	-1	2026-06-16 11:34:59.983529	nkosinathi sibisi	0
361	Marcus Thuram-Ulien	Offence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marcus thuramulien	0
362	Michael Olise	Offence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	michael olise	0
363	Bradley Barcola	Offence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bradley barcola	0
364	Ronwen Williams	Goalkeeper	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ronwen williams	0
365	Sipho Chaine	Goalkeeper	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sipho chaine	0
366	Ricardo Goss	Goalkeeper	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ricardo goss	0
367	Aubrey Modiba	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aubrey modiba	0
369	Khuliso Mudau	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	khuliso mudau	0
370	Olwethu Makhanya	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	olwethu makhanya	0
200	Vitinha	Midfield	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	vitinha	0
378	Teboho Mokoena	Midfield	South Africa	South Africa	2026-06-04 14:35:02.161848	0	1	0	-1	2026-06-16 11:34:59.983529	teboho mokoena	0
379	Sphephelo Sithole	Midfield	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	1	-3	2026-06-16 11:34:59.983529	sphephelo sithole	0
377	Themba Zwane	Midfield	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	1	-3	2026-06-16 11:34:59.983529	themba zwane	0
371	Bradley Cross	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bradley cross	0
372	Samukelo Kabini	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	samukelo kabini	0
373	Ime Okon	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ime okon	0
374	Mbekezeli Mbokazi	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mbekezeli mbokazi	0
375	Khulumani Ndamane	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	khulumani ndamane	0
376	Tholo Matuludi	Defence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tholo matuludi	0
380	Jayden Adams	Midfield	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jayden adams	0
381	Thapelo Maseko	Midfield	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	thapelo maseko	0
382	Thalente Mbatha	Midfield	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	thalente mbatha	0
383	Kamogelo Sebelebele	Midfield	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kamogelo sebelebele	0
384	Lyle Foster	Offence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lyle foster	0
385	Oswin Appollis	Offence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	oswin appollis	0
386	Iqraam Rayners	Offence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	iqraam rayners	0
387	Evidence Makgopa	Offence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	evidence makgopa	0
388	Relebohile Mofokeng	Offence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	relebohile mofokeng	0
390	Luca Zidane	Goalkeeper	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luca zidane	0
389	Tshepang Moremi	Offence	South Africa	South Africa	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tshepang moremi	0
391	Oussama Benbout	Goalkeeper	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	oussama benbout	0
392	Melvin Mastil	Goalkeeper	Algeria	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	melvin mastil	0
393	Aïssa Mandi	Defence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aissa mandi	0
394	Rayan Aït Nouri	Defence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rayan ait nouri	0
395	Ramy Bensebaini	Defence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ramy bensebaini	0
396	Samir Chergui	Defence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	samir chergui	0
397	Jaouen Hadjam	Defence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jaouen hadjam	0
398	Rafik Belghali	Defence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rafik belghali	0
399	Zinédine Belaïd	Defence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zinedine belaid	0
400	Amine Tougai	Defence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amine tougai	0
401	Nabil Bentaleb	Midfield	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nabil bentaleb	0
402	Houssem Aouar	Midfield	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	houssem aouar	0
403	Hicham Boudaoui	Midfield	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hicham boudaoui	0
404	Ramiz Zerrouki	Midfield	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ramiz zerrouki	0
405	Fares Chaïbi	Midfield	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fares chaibi	0
914	Esmir Bajraktarevic	Offence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	esmir bajraktarevic	0
915	Kerim Alajbegović	Offence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kerim alajbegovic	0
916	Luis Mejía	Goalkeeper	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luis mejia	0
917	Orlando Mosquera	Goalkeeper	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	orlando mosquera	0
918	Cesar Samudio	Goalkeeper	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cesar samudio	0
919	Roderick Miller	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	roderick miller	0
920	Fidel Escobar	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fidel escobar	0
921	Éric Davis	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	eric davis	0
922	Andrés Andrade	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	andres andrade	0
923	César Blackman	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cesar blackman	0
406	Ibrahim Maza	Midfield	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrahim maza	0
407	Yacine Titraoui	Midfield	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yacine titraoui	0
408	Riyad Mahrez	Offence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	riyad mahrez	0
409	Amine Gouiri	Offence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amine gouiri	0
410	Mohammed Amoura	Offence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohammed amoura	0
411	Nadhir Benbouali	Offence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nadhir benbouali	0
412	Anis Moussa	Offence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	anis moussa	0
413	Farés Ghedjemis	Offence	Algeria	Algeria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fares ghedjemis	0
414	Maty Ryan	Goalkeeper	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	maty ryan	0
415	Paul Izzo	Goalkeeper	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	paul izzo	0
417	Miloš Degenek	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	milos degenek	0
305	Sebastian Berhalter	Midfield	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sebastian berhalter	0
53	David Raya	Goalkeeper	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david raya	0
418	Kye Rowles	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kye rowles	0
419	Jacob Italiano	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jacob italiano	0
420	Cameron Burgess	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cameron burgess	0
421	Jason Geria	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jason geria	0
422	Jordan Bos	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jordan bos	0
423	Alessandro Circati	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alessandro circati	0
424	Lucas Herrington	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lucas herrington	0
425	Riley McGree	Midfield	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	riley mcgree	0
426	Kai Trewin	Midfield	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kai trewin	0
427	Connor Metcalfe	Midfield	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	connor metcalfe	0
428	Ajdin Hrustic	Midfield	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ajdin hrustic	0
429	Aiden O'Neill	Midfield	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aiden oneill	0
430	Patrick Yazbek	Midfield	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	patrick yazbek	0
431	Alex Robertson	Midfield	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alex robertson	0
432	Paul Okon-Engstler	Midfield	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	paul okonengstler	0
433	Martin Boyle	Offence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	martin boyle	0
434	Awer Mabil	Offence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	awer mabil	0
435	Deni Jurić	Offence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	deni juric	0
436	Nishan Velupillay	Offence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nishan velupillay	0
437	Nestory Irankunda	Offence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nestory irankunda	0
438	Ante Šuto	Offence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ante suto	0
439	Max Crocombe	Goalkeeper	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	max crocombe	0
440	Michael Woud	Goalkeeper	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	michael woud	0
441	Alex Paulsen	Goalkeeper	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alex paulsen	0
442	Liberato Cacace	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	liberato cacace	0
443	Tommy Smith	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tommy smith	0
444	Michael Boxall	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	michael boxall	0
445	Francis De Vries	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	francis de vries	0
446	Callan Elliot	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	callan elliot	0
447	Tim Payne	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tim payne	0
448	Nando Pijnaker	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nando pijnaker	0
449	Finn Surman	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	finn surman	0
450	Tyler Bindon	Defence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tyler bindon	0
451	Alex Rufer	Midfield	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alex rufer	0
452	Sarpreet Singh	Midfield	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sarpreet singh	0
453	Ryan Thomas	Midfield	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ryan thomas	0
454	Callum McCowatt	Midfield	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	callum mccowatt	0
455	Joe Bell	Midfield	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joe bell	0
456	Marko Stamenic	Midfield	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marko stamenic	0
457	Ben Old	Midfield	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ben old	0
458	Kosta Barbarouses	Offence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kosta barbarouses	0
460	Ben Waine	Offence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ben waine	0
461	Elijah Just	Offence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	elijah just	0
462	Matthew Garbett	Offence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matthew garbett	0
463	Lachlan Bayliss	Offence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lachlan bayliss	0
464	Jesse Randall	Offence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jesse randall	0
465	Gregor Kobel	Goalkeeper	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gregor kobel	0
466	Yvon Mvogo	Goalkeeper	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yvon mvogo	0
467	Marvin Keller	Goalkeeper	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marvin keller	0
468	Manuel Akanji	Defence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	manuel akanji	0
470	Silvan Widmer	Defence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	silvan widmer	0
471	Nico Elvedi	Defence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nico elvedi	0
472	Eray Cömert	Defence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	eray comert	0
473	Miro Muheim	Defence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	miro muheim	0
474	Aurele Amenda	Defence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aurele amenda	0
475	Luca Jaquez	Defence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luca jaquez	0
476	Remo Freuler	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	remo freuler	0
477	Granit Xhaka	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	granit xhaka	0
459	Chris Wood	Offence	New Zealand	New Zealand	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	chris wood	0
479	Michel Aebischer	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	michel aebischer	0
480	Djibril Sow	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	djibril sow	0
481	Christian Fassnacht	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	christian fassnacht	0
482	Ruben Vargas	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ruben vargas	0
483	Ardon Jasari	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ardon jasari	0
484	Fabian Rieder	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fabian rieder	0
485	Johan Manzambi	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	johan manzambi	0
486	Breel Embolo	Offence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	breel embolo	0
487	Noah Okafor	Offence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	noah okafor	0
488	Cédric Itten	Offence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cedric itten	0
489	Dan Ndoye	Offence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dan ndoye	0
490	Zeki Amdouni	Offence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zeki amdouni	0
491	Hernán Galíndez	Goalkeeper	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hernan galindez	0
492	Gonzalo Valle	Goalkeeper	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gonzalo valle	0
493	Moisés Ramírez	Goalkeeper	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	moises ramirez	0
494	Ángelo Preciado	Defence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	angelo preciado	0
495	Félix Torres	Defence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	felix torres	0
496	Pervis Estupiñán	Defence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pervis estupinan	0
497	William Pacho	Defence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	william pacho	0
498	Jackson Porozo	Defence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jackson porozo	0
499	Piero Hincapié	Defence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	piero hincapie	0
500	Joel Ordoñez	Defence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joel ordonez	0
548	Vladimir Coufal	Defence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	3	2026-06-16 11:54:57.447647	vladimir coufal	1
501	Yaimar Medina	Defence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yaimar medina	0
502	Alan Franco	Midfield	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alan franco	0
503	Jordy Alcívar	Midfield	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jordy alcivar	0
504	Gonzalo Plata	Midfield	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gonzalo plata	0
505	Moisés Caicedo	Midfield	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	moises caicedo	0
506	Pedro Vite	Midfield	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pedro vite	0
507	Alan Minda	Midfield	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alan minda	0
508	Kendry Paez	Midfield	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kendry paez	0
509	Denil Castillo	Midfield	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	denil castillo	0
510	Jordy Caicedo	Offence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jordy caicedo	0
511	Enner Valencia	Offence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	enner valencia	0
512	John Yeboah	Offence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	john yeboah	0
513	Anthony Valencia	Offence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	anthony valencia	0
514	Nilson Angulo	Offence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nilson angulo	0
515	Kevin Rodríguez	Offence	Ecuador	Ecuador	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kevin rodriguez	0
516	Jeremy	Offence	Ecuador	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jeremy	0
517	Kristoffer Nordfeldt	Goalkeeper	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kristoffer nordfeldt	0
518	Viktor Johansson	Goalkeeper	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	viktor johansson	0
519	Jacob Widell Zetterström	Goalkeeper	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jacob widell zetterstrom	0
520	Victor Nilsson-Lindelöf	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	victor nilssonlindelof	0
521	Carl Starfelt	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	carl starfelt	0
522	Gabriel Gudmundsson	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gabriel gudmundsson	0
523	Hjalmar Ekdal	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hjalmar ekdal	0
524	Eric Smith	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	eric smith	0
525	Daniel Svensson	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	daniel svensson	0
526	Gustaf Lagerbielke	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gustaf lagerbielke	0
527	Isak Hien	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	isak hien	0
528	Herman Johansson	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	herman johansson	0
529	Elliot Stroud	Defence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	elliot stroud	0
530	Ken Sema	Midfield	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ken sema	0
531	Mattias Svanberg	Midfield	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mattias svanberg	0
532	Jesper Karlström	Midfield	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jesper karlstrom	0
533	Yasin Ayari	Midfield	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yasin ayari	0
534	Besfort Zeneli	Midfield	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	besfort zeneli	0
535	Taha Ali	Midfield	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	taha ali	0
536	Lucas Bergvall	Midfield	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lucas bergvall	0
306	Malik Tillman	Midfield	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	malik tillman	0
540	Benjamin Nygren	Offence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	benjamin nygren	0
541	Alexander Bernhardsson	Offence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexander bernhardsson	0
542	Anthony Elanga	Offence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	anthony elanga	0
543	Jindřich Staněk	Goalkeeper	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jindrich stanek	0
544	Matej Kovar	Goalkeeper	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matej kovar	0
545	Lukáš Horníček	Goalkeeper	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lukas hornicek	0
546	Ladislav Krejčí	Defence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ladislav krejci	0
547	Jaroslav Zelený	Defence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jaroslav zeleny	0
549	Tomáš Holeš	Defence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tomas holes	0
550	David Zima	Defence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david zima	0
551	David Jurásek	Defence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david jurasek	0
552	Robin Hranac	Defence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	robin hranac	0
553	Štěpán Chaloupek	Defence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	stepan chaloupek	0
554	Vladimír Darida	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	vladimir darida	0
555	Tomáš Souček	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tomas soucek	0
556	David Douděra	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david doudera	0
557	Michal Sadílek	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	michal sadilek	0
558	Lukáš Provod	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lukas provod	0
559	Pavel Šulc	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pavel sulc	0
560	Lukáš Červ	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lukas cerv	0
561	Denis Višinský	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	denis visinsky	0
562	Alexandr Sojka	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexandr sojka	0
563	Hugo Sochůrek	Midfield	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hugo sochurek	0
564	Patrik Schick	Offence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	patrik schick	0
565	Tomáš Chorý	Offence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tomas chory	0
566	Jan Kuchta	Offence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jan kuchta	0
567	Adam Hložek	Offence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	adam hlozek	0
568	Mojmír Chytil	Offence	Czechia	Czech Republic	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mojmir chytil	0
569	Dominik Livaković	Goalkeeper	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dominik livakovic	0
570	Ivor Pandur	Goalkeeper	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ivor pandur	0
571	Dominik Kotarski	Goalkeeper	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dominik kotarski	0
572	Duje Ćaleta-Car	Defence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	duje caletacar	0
573	Marin Pongračić	Defence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marin pongracic	0
574	Martin Erlic	Defence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	martin erlic	0
575	Josip Stanišić	Defence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	josip stanisic	0
576	Joško Gvardiol	Defence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	josko gvardiol	0
577	Josip Šutalo	Defence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	josip sutalo	0
578	Luka Vušković	Defence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luka vuskovic	0
579	Luka Modrić	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luka modric	0
580	Mateo Kovačić	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mateo kovacic	0
581	Mario Pašalić	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mario pasalic	0
582	Nikola Vlašić	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nikola vlasic	0
583	Nikola Moro	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nikola moro	0
584	Kristijan Jakić	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kristijan jakic	0
585	Luka Sučić	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luka sucic	0
586	Petar Sucic	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	petar sucic	0
587	Martin Baturina	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	martin baturina	0
588	Toni Fruk	Midfield	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	toni fruk	0
589	Andrej Kramarić	Offence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	andrej kramaric	0
590	Ivan Perišić	Offence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ivan perisic	0
591	Ante Budimir	Offence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ante budimir	0
592	Petar Musa	Offence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	petar musa	0
593	Marco Pašalić	Offence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marco pasalic	0
594	Igor Matanovic	Offence	Croatia	Croatia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	igor matanovic	0
595	Mohammed Al Owais	Goalkeeper	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohammed al owais	0
596	Nawaf Al Aqidi	Goalkeeper	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nawaf al aqidi	0
597	Ahmed Al Kassar	Goalkeeper	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed al kassar	0
598	Abdulelah Al Amri	Defence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdulelah al amri	0
599	Saud Abdulhamid	Defence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	saud abdulhamid	0
600	Ali Lajami	Defence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ali lajami	0
601	Hassan Al Tambakti	Defence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hassan al tambakti	0
604	Salem Al Dawsari	Midfield	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	salem al dawsari	0
605	Abdullah Al Khaibari	Midfield	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdullah al khaibari	0
606	Nasser Al Dawsari	Midfield	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nasser al dawsari	0
607	Ayman Yahya	Midfield	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ayman yahya	0
608	Musab Al Juwayr	Midfield	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	musab al juwayr	0
609	Mohammed Kanno	Midfield	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohammed kanno	0
610	Sultan Mandash	Offence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sultan mandash	0
611	Saleh Al Shehri	Offence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	saleh al shehri	0
612	Abdullah Al-Hamdan	Offence	Saudi Arabia	\N	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdullah alhamdan	0
613	Khalid Al Ghannam	Offence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	khalid al ghannam	0
614	Firas Al Brikan	Offence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	firas al brikan	0
615	Aymen Dahmen	Goalkeeper	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aymen dahmen	0
616	Dylan Bronn	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dylan bronn	0
617	Ali El Abdi	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ali el abdi	0
618	Yan Valery	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yan valery	0
619	Mortadha Ben Ouanes	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mortadha ben ouanes	0
620	Omar Rekik	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	omar rekik	0
621	Yassine Chikhaoui	Defence	Tunisia	\N	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yassine chikhaoui	0
622	Montassar Talbi	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	montassar talbi	0
623	Moutaz Neffati	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	moutaz neffati	0
624	Mohamed Amine Ben Hamida	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohamed amine ben hamida	0
625	Adem Arous	Defence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	adem arous	0
626	Ellyes Skhiri	Midfield	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ellyes skhiri	0
627	Rani Khedira	Midfield	Tunisia	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rani khedira	0
628	Anis Ben Slimane	Midfield	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	anis ben slimane	0
629	Ismaël Gharbi	Midfield	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ismael gharbi	0
630	Hannibal Mejbri	Midfield	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hannibal mejbri	0
631	Elias Achouri	Midfield	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	elias achouri	0
632	Hadj Mahmoud	Midfield	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hadj mahmoud	0
633	Sebastian Tounekti	Offence	Tunisia	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sebastian tounekti	0
634	Firas Chaouat	Offence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	firas chaouat	0
635	Elias Saad	Offence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	elias saad	0
636	Hazem Mastouri	Offence	Tunisia	Tunisia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hazem mastouri	0
637	Rayan Elloumi	Offence	Tunisia	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rayan elloumi	0
638	Mert Günok	Goalkeeper	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mert gunok	0
639	Altay Bayındır	Goalkeeper	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	altay bayndr	0
640	Uğurcan Çakır	Goalkeeper	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ugurcan cakr	0
644	Mert Müldür	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mert muldur	0
645	Zeki Çelik	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zeki celik	0
646	Abdülkerim Bardakcı	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdulkerim bardakc	0
647	Ozan Kabak	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ozan kabak	0
648	Merih Demiral	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	merih demiral	0
649	Samet Akaydın	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	samet akaydn	0
650	Evren Eren Elmalı	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	evren eren elmal	0
651	Salih Özcan	Midfield	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	salih ozcan	0
652	Hakan Çalhanoğlu	Midfield	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hakan calhanoglu	0
653	Orkun Kökçü	Midfield	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	orkun kokcu	0
654	İsmail Yüksek	Midfield	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ismail yuksek	0
655	Barış Alper Yılmaz	Midfield	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bars alper ylmaz	0
656	Arda Guler	Midfield	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	arda guler	0
657	Oguz Aydin	Midfield	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	oguz aydin	0
658	İrfan Kahveci	Midfield	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	irfan kahveci	0
659	Yunus Akgün	Offence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yunus akgun	0
660	Muhammed Kerem Aktürkoğlu	Offence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	muhammed kerem akturkoglu	0
662	Kenan Yıldız	Offence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kenan yldz	0
664	Edouard Mendy	Goalkeeper	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	edouard mendy	0
665	Yehvann Diouf	Goalkeeper	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yehvann diouf	0
308	Tim Weah	Offence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tim weah	0
54	Unai Simón	Goalkeeper	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	unai simon	0
667	Ismail Jakobs	Defence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ismail jakobs	0
668	Kalidou Koulibaly	Defence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kalidou koulibaly	0
669	Moussa Niakhaté	Defence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	moussa niakhate	0
670	Abdoulaye Seck	Defence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdoulaye seck	0
671	Antoine Mendy	Defence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	antoine mendy	0
672	Nobel Mendy	Defence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nobel mendy	0
673	Mamadou Sarr	Defence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mamadou sarr	0
674	El Hadji Malick Diouf	Defence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	el hadji malick diouf	0
661	Deniz Gul	Offence	Turkey	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	deniz gul	0
675	Pape Gueye	Midfield	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pape gueye	0
676	Idrissa Gana Guèye	Midfield	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	idrissa gana gueye	0
677	Krépin Diatta	Midfield	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	krepin diatta	0
678	Pathé Ciss	Midfield	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pathe ciss	0
679	Pape Sarr	Midfield	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pape sarr	0
680	Habib Diarra	Midfield	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	habib diarra	0
681	Lamine Camara	Midfield	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lamine camara	0
682	Habib Diallo	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	habib diallo	0
683	Ismaïla Sarr	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ismaila sarr	0
684	Cherif Ndiaye	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cherif ndiaye	0
685	Iliman Ndiaye	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	iliman ndiaye	0
686	Boulaye Dia	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	boulaye dia	0
687	Nicolas Jackson	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nicolas jackson	0
688	Cheikh Ahmadou Dieng	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cheikh ahmadou dieng	0
689	Mamadou Diakhon	Offence	Senegal	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mamadou diakhon	0
690	Assane Diao	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	assane diao	0
691	Ibrahim M'Baye	Offence	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrahim mbaye	0
692	Thibaut Courtois	Goalkeeper	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	thibaut courtois	0
693	Senne Lammens	Goalkeeper	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	senne lammens	0
694	Mike Penders	Goalkeeper	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mike penders	0
695	Timothy Castagne	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	timothy castagne	0
696	Thomas Meunier	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	thomas meunier	0
697	Brandon Mechele	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brandon mechele	0
698	Maxim De Cuyper	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	maxim de cuyper	0
699	Arthur Theate	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	arthur theate	0
700	Koni De Winter	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	koni de winter	0
701	Zeno Debast	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zeno debast	0
702	Nathan Ngoy	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nathan ngoy	0
703	Joaquin Seys	Defence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joaquin seys	0
706	Youri Tielemans	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	youri tielemans	0
707	Dodi Lukebakio	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dodi lukebakio	0
708	Alexis Saelemaekers	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexis saelemaekers	0
709	Hans Vanaken	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hans vanaken	0
710	Nicolas Raskin	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nicolas raskin	0
711	Jeremy Doku	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jeremy doku	0
712	Amadou Onana	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amadou onana	0
713	Diego Moreira	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	diego moreira	0
715	Leandro Trossard	Offence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leandro trossard	0
716	Charles De Ketelaere	Offence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	charles de ketelaere	0
717	Matias Fernandez-Pardo	Offence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matias fernandezpardo	0
718	Munir Mohamedi	Goalkeeper	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	munir mohamedi	0
719	Yassine Bounou	Goalkeeper	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yassine bounou	0
720	Ahmed Reda Tagnaouti	Goalkeeper	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed reda tagnaouti	0
721	Achraf Hakimi	Defence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	achraf hakimi	0
798	Karim Hafez	Defence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	karim hafez	0
722	Noussair Mazraoui	Defence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	noussair mazraoui	0
723	Issa Diop	Defence	Morocco	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	issa diop	0
724	Nayef Aguerd	Defence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nayef aguerd	0
725	Anass Salah-Eddine	Defence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	anass salaheddine	0
726	Chadi Riad	Defence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	chadi riad	0
727	Redouane Halhal	Defence	Morocco	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	redouane halhal	0
729	Youssef Belammari	Defence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	youssef belammari	0
730	Sofyan Amrabat	Midfield	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sofyan amrabat	0
731	Brahim Diaz	Midfield	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brahim diaz	0
732	Azzedine Ounahi	Midfield	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	azzedine ounahi	0
733	Ismael Saibari	Midfield	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ismael saibari	0
734	Neil El Aynaoui	Midfield	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	neil el aynaoui	0
735	Chemsdine Talbi	Midfield	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	chemsdine talbi	0
736	Ayyoub Bouaddi	Midfield	Morocco	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ayyoub bouaddi	0
737	Samir El Mourabet	Midfield	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	samir el mourabet	0
738	Ayoub El Kaabi	Offence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ayoub el kaabi	0
739	Soufiane Rahimi	Offence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	soufiane rahimi	0
740	Abdessamad Ezzalzouli	Offence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdessamad ezzalzouli	0
741	Gessime Yassine	Offence	Morocco	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gessime yassine	0
742	Ayoube Amaimouni-Echghouyab	Offence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ayoube amaimouniechghouyab	0
743	Alexander Schlager	Goalkeeper	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexander schlager	0
744	Patrick Pentz	Goalkeeper	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	patrick pentz	0
745	Florian Wiegele	Goalkeeper	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	florian wiegele	0
746	David Alaba	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david alaba	0
747	Stefan Posch	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	stefan posch	0
748	Philipp Mwene	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	philipp mwene	0
749	Kevin Danso	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kevin danso	0
750	Marco Friedl	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marco friedl	0
751	Philipp Lienhart	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	philipp lienhart	0
752	Michael Svoboda	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	michael svoboda	0
753	Alexander Prass	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexander prass	0
754	David Affengruber	Defence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david affengruber	0
755	Florian Grillitsch	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	florian grillitsch	0
756	Alessandro Schöpf	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alessandro schopf	0
757	Konrad Laimer	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	konrad laimer	0
758	Marcel Sabitzer	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marcel sabitzer	0
759	Xaver Schlager	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	xaver schlager	0
760	Romano Schmid	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	romano schmid	0
761	Christoph Baumgartner	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	christoph baumgartner	0
762	Nicolas  Seiwald	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nicolas seiwald	0
763	Patrick Wimmer	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	patrick wimmer	0
764	Carney Chukwuemeka	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	carney chukwuemeka	0
765	Paul Wanner	Midfield	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	paul wanner	0
766	Michael Gregoritsch	Offence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	michael gregoritsch	0
767	Marko Arnautovic	Offence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marko arnautovic	0
768	Saša Kalajdžić	Offence	Austria	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sasa kalajdzic	0
769	Camilo Vargas	Goalkeeper	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	camilo vargas	0
770	David Ospina	Goalkeeper	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david ospina	0
771	Álvaro Montero	Goalkeeper	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alvaro montero	0
772	Santiago Arias	Defence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	santiago arias	0
773	Johan Mojica	Defence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	johan mojica	0
774	Yerry Mina	Defence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yerry mina	0
775	Davinson Sánchez	Defence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	davinson sanchez	0
776	Deiver Machado	Defence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	deiver machado	0
777	Daniel Muñoz	Defence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	daniel munoz	0
778	Jhon Lucumí	Defence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jhon lucumi	0
779	Willer Ditta	Defence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	willer ditta	0
780	James Rodríguez	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	james rodriguez	0
781	Jefferson Lerma	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jefferson lerma	0
782	Jhon Arias	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jhon arias	0
783	Jorge Carrascal	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jorge carrascal	0
784	Kevin Castaño	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kevin castano	0
785	Juan Quintero	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	juan quintero	0
786	Jaminton Campaz	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jaminton campaz	0
787	Richard Rios	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	richard rios	0
788	Juan Portilla	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	juan portilla	0
789	Gustavo Puerta	Midfield	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gustavo puerta	0
790	Jhon Córdoba	Offence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jhon cordoba	0
791	Luis Díaz	Offence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luis diaz	0
792	Luis Suárez	Offence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luis suarez	0
793	Cucho Hernández	Offence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cucho hernandez	0
794	Carlos Andrés Gómez	Offence	Colombia	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	carlos andres gomez	0
795	Mohamed El Shenawy	Goalkeeper	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohamed el shenawy	0
796	Mohamed Alaa	Goalkeeper	Egypt	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohamed alaa	0
797	Oufa Shobeir	Goalkeeper	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	oufa shobeir	0
799	Mohamed Hany	Defence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohamed hany	0
800	Yasser Ibrahim	Defence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yasser ibrahim	0
801	Ahmed El Fotouh	Defence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed el fotouh	0
802	Mohamed Abdelmonem	Defence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohamed abdelmonem	0
803	Rami Rabia	Defence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rami rabia	0
804	Hossam Abdelmaguid	Defence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hossam abdelmaguid	0
805	Nabil Dunga	Midfield	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nabil dunga	0
806	Hamdy Fathy	Midfield	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hamdy fathy	0
825	Alistair Johnston	Defence	Canada	Canada	2026-06-04 14:35:02.161848	0	1	0	-1	2026-06-16 12:04:02.287983	alistair johnston	0
807	Trezeguet	Midfield	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	trezeguet	0
808	Emam Ashour	Midfield	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	emam ashour	0
809	Mohanad Lashin	Midfield	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohanad lashin	0
810	Marwan Attia	Midfield	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marwan attia	0
811	Mahmoud Saber	Midfield	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mahmoud saber	0
812	Mohamed Salah	Offence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohamed salah	0
813	Omar Marmoush	Offence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	omar marmoush	0
814	Haissem Hassan	Offence	Egypt	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	haissem hassan	0
815	Ibrahim Adel	Offence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrahim adel	0
816	Hamza Abdelkarim	Offence	Egypt	Egypt	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hamza abdelkarim	0
817	Maxime Crépeau	Goalkeeper	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	maxime crepeau	0
818	Dayne St. Clair	Goalkeeper	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dayne st clair	0
819	Owen Goodman	Goalkeeper	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	owen goodman	0
820	Alphonso Davies	Defence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alphonso davies	0
821	Richie Laryea	Defence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	richie laryea	0
822	Alfie Jones	Defence	Canada	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alfie jones	0
823	Joel Waterman	Defence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joel waterman	0
824	Derek Cornelius	Defence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	derek cornelius	0
826	Moise Bombito	Defence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	moise bombito	0
216	Ko Itakura	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ko itakura	0
217	Shogo Taniguchi	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	shogo taniguchi	0
218	Ayumu Seko	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ayumu seko	0
219	Tsuyoshi Watanabe	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tsuyoshi watanabe	0
220	Junnosuke Suzuki	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	junnosuke suzuki	0
221	Wataru Endō	Midfield	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	wataru endo	0
222	Daichi Kamada	Midfield	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	daichi kamada	0
223	Takefusa Kubo	Midfield	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	takefusa kubo	0
224	Keito Nakamura	Midfield	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	keito nakamura	0
225	Ao Tanaka	Midfield	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ao tanaka	0
226	Kaishu Sano	Midfield	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kaishu sano	0
839	Liam Millar	Offence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	liam millar	0
840	Jacob Shaffelburg	Offence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jacob shaffelburg	0
841	Tani Oluwaseyi	Offence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tani oluwaseyi	0
842	Promise Akinpelu	Offence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	promise akinpelu	0
843	Alexandre Pierre	Goalkeeper	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexandre pierre	0
844	Johny Placide	Goalkeeper	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	johny placide	0
845	Carlens Arcus	Defence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	carlens arcus	0
846	Jean-Kevin Duverne	Defence	Haiti	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jeankevin duverne	0
847	Hannes Delcroix	Defence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hannes delcroix	0
848	Martin Expérience	Defence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	martin experience	0
850	Duke LaCroix	Defence	Haiti	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	duke lacroix	0
851	Keeto Thermoncy	Defence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	keeto thermoncy	0
852	Wilguens Paugain	Defence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	wilguens paugain	0
853	Leverton Pierre	Midfield	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leverton pierre	0
854	Jean-Ricner Bellegarde	Midfield	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jeanricner bellegarde	0
855	Derrick Etienne	Midfield	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	derrick etienne	0
856	Danley Jean Jacques	Midfield	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	danley jean jacques	0
55	Joan García	Goalkeeper	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joan garcia	0
56	Aymeric Laporte	Defence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aymeric laporte	0
857	Dominique Simon	Midfield	Haiti	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dominique simon	0
858	Carl Sainté	Midfield	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	carl sainte	0
859	Duckens Nazon	Offence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	duckens nazon	0
860	Frantzdy Pierrot	Offence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	frantzdy pierrot	0
861	Yassin Fortune	Offence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yassin fortune	0
862	Wilson Isidor	Offence	Haiti	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	wilson isidor	0
863	Lenny Joseph	Offence	Haiti	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lenny joseph	0
864	Louicius Don Deedson	Offence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	louicius don deedson	0
865	Josué Casimir	Offence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	josue casimir	0
866	Ruben Providence	Offence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ruben providence	0
867	Hossein Hosseini	Goalkeeper	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hossein hosseini	0
868	Payam Niazmand	Goalkeeper	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	payam niazmand	0
869	Alireza Beiranvand	Goalkeeper	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alireza beiranvand	0
870	Ehsan Hajsafi	Defence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ehsan hajsafi	0
871	Ramin Rezaeian	Defence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ramin rezaeian	0
872	Milad Mohammadi	Defence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	milad mohammadi	0
873	Hossein Kanaanizadegan	Defence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hossein kanaanizadegan	0
874	Shojae Khalilzadeh	Defence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	shojae khalilzadeh	0
875	Rouzbeh Cheshmi	Defence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rouzbeh cheshmi	0
876	Saleh Hardani	Defence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	saleh hardani	0
877	Saeid Ezatolahi	Midfield	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	saeid ezatolahi	0
878	Mehdi Torabi	Midfield	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mehdi torabi	0
879	Mohammad Ghorbani	Midfield	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohammad ghorbani	0
880	Ariya Yousefi	Midfield	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ariya yousefi	0
881	Medhi Ghayedi	Midfield	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	medhi ghayedi	0
882	Alireza Jahanbakhsh	Offence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alireza jahanbakhsh	0
883	Mehdi Taremi	Offence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mehdi taremi	0
884	Dennis Eckert	Offence	Iran	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dennis eckert	0
885	Ali Alipour	Offence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ali alipour	0
886	Shahriar Moghanlou	Offence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	shahriar moghanlou	0
887	Mohammad Mohebi	Offence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohammad mohebi	0
888	Saman Ghoddos	Offence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	saman ghoddos	0
889	Amir Hosseinzadeh	Offence	Iran	Iran	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amir hosseinzadeh	0
890	Martin Zlomislić	Goalkeeper	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	martin zlomislic	0
891	Nikola Vasilj	Goalkeeper	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nikola vasilj	0
892	Mladen Jurkas	Goalkeeper	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mladen jurkas	0
893	Sead Kolašinac	Defence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sead kolasinac	0
894	Dennis Hadžikadunić	Defence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dennis hadzikadunic	0
895	Nihad Mujakić	Defence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nihad mujakic	0
896	Nikola Katić	Defence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nikola katic	0
897	Stjepan Radeljić	Defence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	stjepan radeljic	0
898	Amar Dedić	Defence	Bosnia-Herzegovina	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amar dedic	0
899	Tarik Muharemović	Defence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tarik muharemovic	0
900	Nidal Čelik	Defence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nidal celik	0
901	Dženis Burnić	Midfield	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dzenis burnic	0
902	Ivan Šunjić	Midfield	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ivan sunjic	0
903	Amir Hadžiahmetović	Midfield	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amir hadziahmetovic	0
904	Armin Gigovic	Midfield	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	armin gigovic	0
905	Ivan Bašić	Midfield	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ivan basic	0
906	Benjamin Tahirovic	Midfield	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	benjamin tahirovic	0
907	Ermin Mahmic	Midfield	Bosnia-Herzegovina	Austria	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ermin mahmic	0
908	Amar Memić	Midfield	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amar memic	0
909	Edin Džeko	Offence	Bosnia-Herzegovina	Bosnia-Herzegovina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	edin dzeko	0
1045	Abdallah Al Fakhouri	Goalkeeper	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdallah al fakhouri	0
1046	Saleem Obaid	Defence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	saleem obaid	0
1047	Yazan Al Arab	Defence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yazan al arab	0
1049	Abdallah Naseeb	Defence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdallah naseeb	0
1050	Mohammad Abu Hasheesh	Defence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohammad abu hasheesh	0
1051	Mohannad Abu Taha	Defence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohannad abu taha	0
1052	Yousef Abu Al Jazar	Defence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yousef abu al jazar	0
1053	Ahmad Assaf	Midfield	Jordan	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmad assaf	0
1054	Yousef Qashi	Midfield	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yousef qashi	0
1055	Nizar Al Rashdan	Midfield	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nizar al rashdan	0
1056	Noor Al Rawabdeh	Midfield	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	noor al rawabdeh	0
1057	Ibrahim Saadeh	Midfield	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrahim saadeh	0
1058	Musa Al Taamari	Offence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	musa al taamari	0
1	Fernando Muslera	Goalkeeper	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fernando muslera	0
2	Santiago Mele	Goalkeeper	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	santiago mele	0
3	Sergio Rochet	Goalkeeper	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sergio rochet	0
4	Guillermo Varela	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	guillermo varela	0
5	Ronald Araújo	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ronald araujo	0
6	Sebastían Cáceres	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sebastian caceres	0
7	Matías Viña	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matias vina	0
8	Joaquín Piquerez	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joaquin piquerez	0
9	Maximiliano Araújo	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	maximiliano araujo	0
1077	Ibrahim Bayesh	Midfield	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrahim bayesh	0
1078	Youssef Amyn	Midfield	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	youssef amyn	0
1079	Ahmed Qasem	Midfield	Iraq	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed qasem	0
80	Roberto Fernández	Goalkeeper	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	roberto fernandez	0
81	Orlando Gill	Goalkeeper	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	orlando gill	0
82	Fabián Balbuena	Defence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fabian balbuena	0
83	Gustavo Gómez	Defence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gustavo gomez	0
84	Júnior Alonso	Defence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	junior alonso	0
85	Omar Alderete	Defence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	omar alderete	0
86	Juan Cáceres	Defence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	juan caceres	0
87	Gustavo Velázquez	Defence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gustavo velazquez	0
88	José Canale	Defence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jose canale	0
89	Alexandro Maidana	Defence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexandro maidana	0
90	Andrés Cubas	Midfield	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	andres cubas	0
1096	Sherzod Nasrullayev	Defence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sherzod nasrullayev	0
1097	Mukhammadkodir Khamraliev	Defence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mukhammadkodir khamraliev	0
1098	Otabek Shukurov	Midfield	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	otabek shukurov	0
1099	Jamshid Iskanderov	Midfield	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jamshid iskanderov	0
1100	Akmal Mozgovoy	Midfield	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	akmal mozgovoy	0
1101	Umarali Rahmonaliyev	Midfield	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	umarali rahmonaliyev	0
1102	Azizjon Ganiev	Midfield	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	azizjon ganiev	0
1103	Odiljon Hamrobekov	Midfield	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	odiljon hamrobekov	0
99	Gabriel Ávalos	Offence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gabriel avalos	0
924	Jiovany Ramos	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jiovany ramos	0
100	Isidro Pitta	Offence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	isidro pitta	0
101	Ramón Sosa	Offence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ramon sosa	0
103	Gustavo Caballero	Offence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gustavo caballero	0
105	Géronimo Rulli	Goalkeeper	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	geronimo rulli	0
107	Juan Musso	Goalkeeper	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	juan musso	0
109	Nicolás Tagliafico	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nicolas tagliafico	0
110	Gonzalo Montiel	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gonzalo montiel	0
111	Christian Romero	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	christian romero	0
112	Facundo Medina	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	facundo medina	0
114	Nahuel Molina	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nahuel molina	0
115	Leonardo Balerdi	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leonardo balerdi	0
116	Valentin Barco	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	valentin barco	0
118	Leandro Paredes	Midfield	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leandro paredes	0
119	Giovani Lo Celso	Midfield	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	giovani lo celso	0
120	Exequiel Palacios	Midfield	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	exequiel palacios	0
1104	Ibrokhim Ibrokhimov	Midfield	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrokhim ibrokhimov	0
1105	Dostonbek Xamdamov	Offence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dostonbek xamdamov	0
1106	Eldor Shomurodov	Offence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	eldor shomurodov	0
1107	Oston Urunov	Offence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	oston urunov	0
1108	Igor Sergeev	Offence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	igor sergeev	0
1109	Alisher Odilov	Offence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alisher odilov	0
1110	Mark Flekken	Goalkeeper	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mark flekken	0
1111	Bart Verbruggen	Goalkeeper	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bart verbruggen	0
1112	Robin Roefs	Goalkeeper	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	robin roefs	0
1113	Denzel Dumfries	Defence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	denzel dumfries	0
1114	Virgil van Dijk	Defence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	virgil van dijk	0
1115	Nathan Aké	Defence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nathan ake	0
1116	Jan Paul van Hecke	Defence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jan paul van hecke	0
1117	Jurrien Timber	Defence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jurrien timber	0
1118	Mickey van de Ven	Defence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mickey van de ven	0
1119	Jorrel Hato	Defence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jorrel hato	0
1120	Marten de Roon	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marten de roon	0
1121	Donyell Malen	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	donyell malen	0
1122	Frenkie de Jong	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	frenkie de jong	0
312	Max Arfsten	Offence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	max arfsten	0
59	Pedro Porro	Defence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pedro porro	0
60	Eric García	Defence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	eric garcia	0
61	Marc Pubill	Defence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marc pubill	0
62	Pau Cubarsí	Defence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pau cubarsi	0
63	Fabián Ruiz	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fabian ruiz	0
64	Marcos Llorente	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marcos llorente	0
66	Mikel Merino	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mikel merino	0
67	Dani Olmo	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dani olmo	0
69	Martín Zubimendi	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	martin zubimendi	0
71	Pablo Gavira	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pablo gavira	0
72	Mikel Oyarzabal	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mikel oyarzabal	0
73	Álex Baena	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alex baena	0
158	Alisson Becker	Goalkeeper	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alisson becker	0
297	Chris Richards	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	chris richards	0
1123	Noa Lang	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	noa lang	0
1124	Guus Til	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	guus til	0
1125	Teun Koopmeiners	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	teun koopmeiners	0
1126	Tijjani Reijnders	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tijjani reijnders	0
1127	Ryan Gravenberch	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ryan gravenberch	0
287	Matt Turner	Goalkeeper	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matt turner	0
288	Matt Freese	Goalkeeper	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matt freese	0
289	Chris Brady	Goalkeeper	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	chris brady	0
290	Antonee Robinson	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	antonee robinson	0
291	Tim Ream	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tim ream	0
292	Miles Robinson	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	miles robinson	0
1128	Mats Wieffer	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mats wieffer	0
1129	Quinten Timber	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	quinten timber	0
1130	Crysencio Summerville	Midfield	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	crysencio summerville	0
1131	Cody Gakpo	Offence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cody gakpo	0
1132	Justin Kluivert	Offence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	justin kluivert	0
1133	Wout Weghorst	Offence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	wout weghorst	0
1134	Memphis Depay	Offence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	memphis depay	0
1135	Brian Brobbey	Offence	Netherlands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brian brobbey	0
1136	Ørjan Nyland	Goalkeeper	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rjan nyland	0
1137	Egil Selvik	Goalkeeper	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	egil selvik	0
1138	Sander Tangvik	Goalkeeper	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sander tangvik	0
1140	Torbjørn Heggem	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	torbjrn heggem	0
1141	Fredrik Bjørkan	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fredrik bjrkan	0
1142	Marcus Pedersen	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marcus pedersen	0
1143	Julian Ryerson	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	julian ryerson	0
1144	Leo Østigård	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leo stigard	0
1145	Henrik Falchener	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	henrik falchener	0
1146	Sondre Langås	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sondre langas	0
42	Felix Kalu Nmecha	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	felix kalu nmecha	0
43	Angelo Stiller	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	angelo stiller	0
121	Alexis Mac Allister	Midfield	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexis mac allister	0
1019	Yan Diomandé	Offence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yan diomande	0
1020	Salah Zakaria	Goalkeeper	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	salah zakaria	0
1021	Meshaal Barsham	Goalkeeper	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	meshaal barsham	0
1022	Mahmoud Abunada	Goalkeeper	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mahmoud abunada	0
1023	Boualem Khoukhi	Defence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	boualem khoukhi	0
1024	Jassem Gaber Abdulsallam	Defence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jassem gaber abdulsallam	0
1025	Homam Ahmed	Defence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	homam ahmed	0
1027	Lucas Mendes	Defence	Qatar	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lucas mendes	0
1028	Sultan Al Brake	Defence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sultan al brake	0
1065	Hussein Ali	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hussein ali	0
641	Çağlar Söyüncü	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	caglar soyuncu	0
642	Kaan Ayhan	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kaan ayhan	0
643	Ferdi Kadıoğlu	Defence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ferdi kadoglu	0
1039	Almoez Ali	Offence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	almoez ali	0
1159	Erling Haaland	Offence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	erling haaland	0
1160	Andreas Schjelderup	Offence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	andreas schjelderup	0
1161	Jørgen Strand Larsen	Offence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jrgen strand larsen	0
1162	Angus Gunn	Goalkeeper	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	angus gunn	0
1163	Craig Gordon	Goalkeeper	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	craig gordon	0
1164	Liam Kelly	Goalkeeper	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	liam kelly	0
1165	Grant Hanley	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	grant hanley	0
1166	Dominic Hyam	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dominic hyam	0
1167	Andrew Robertson	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	andrew robertson	0
1168	Kieran Tierney	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kieran tierney	0
1169	Jack Hendry	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jack hendry	0
134	Abdul Rahman Baba	Defence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdul rahman baba	0
135	Derrick Luckassen	Defence	Ghana	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	derrick luckassen	0
136	Gideon Mensah	Defence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gideon mensah	0
138	Jerome Opoku	Defence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jerome opoku	0
139	Alidu Seidu	Defence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alidu seidu	0
140	Marvin Senaya	Defence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marvin senaya	0
141	Jonas Adjei Adjetey	Defence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jonas adjei adjetey	0
1184	George Hirst	Offence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	george hirst	0
1185	Ross Stewart	Offence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ross stewart	0
1186	Lyndon Dykes	Offence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lyndon dykes	0
1187	Lawrence Shankland	Offence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lawrence shankland	0
1202	Leandro Bacuna	Midfield	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leandro bacuna	0
1203	Godfried Roemeratoe	Midfield	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	godfried roemeratoe	0
1204	Juninho Bacuna	Midfield	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	juninho bacuna	0
925	José Cordoba	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jose cordoba	0
926	Michael Murillo	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	michael murillo	0
927	Edgardo Fariña	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	edgardo farina	0
928	Jorge Gutiérrez	Defence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jorge gutierrez	0
929	Adalberto Carrasquilla	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	adalberto carrasquilla	0
930	José Luis Rodríguez	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jose luis rodriguez	0
931	Cecilio Waterman	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cecilio waterman	0
932	Édgar Bárcenas	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	edgar barcenas	0
933	Aníbal Godoy	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	anibal godoy	0
934	Alberto Quintero	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alberto quintero	0
935	Carlos Harvey	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	carlos harvey	0
936	César Yanis	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cesar yanis	0
937	Christian Martinez	Midfield	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	christian martinez	0
203	Pedro Neto	Offence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pedro neto	0
205	Trincão	Offence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	trincao	0
227	Yuito Suzuki	Midfield	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yuito suzuki	0
1205	Kevin Felida	Midfield	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kevin felida	0
1206	Gervane Kastaneer	Offence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gervane kastaneer	0
1207	Kenji Gorré	Offence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kenji gorre	0
1208	Jürgen Locadia	Offence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jurgen locadia	0
206	João Félix	Offence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joao felix	0
207	Gonçalo Ramos	Offence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	goncalo ramos	0
208	Francisco Conceição	Offence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	francisco conceicao	0
940	Tomas Rodriguez	Offence	Panama	Panama	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tomas rodriguez	0
954	Garry Rodrigues	Midfield	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	garry rodrigues	0
15	Rodrigo Bentancur	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rodrigo bentancur	0
19	Facundo Pellistri	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	facundo pellistri	0
20	Emiliano Martínez	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	emiliano martinez	0
21	Juan Sanabria	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	juan sanabria	0
22	Nicolas de la Cruz	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nicolas de la cruz	0
24	Darwin Núñez	Offence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	darwin nunez	0
27	Oliver Baumann	Goalkeeper	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	oliver baumann	0
28	Manuel Neuer	Goalkeeper	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	manuel neuer	0
29	Alexander Nübel	Goalkeeper	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexander nubel	0
30	Jonathan Tah	Defence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jonathan tah	0
31	Waldemar Anton	Defence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	waldemar anton	0
33	David Raum	Defence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david raum	0
34	Nico Schlotterbeck	Defence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nico schlotterbeck	0
35	Malick Thiaw	Defence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	malick thiaw	0
36	Nathaniel Brown	Defence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nathaniel brown	0
37	Nadiem Amiri	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nadiem amiri	0
39	Leon Goretzka	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leon goretzka	0
40	Pascal Groß	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pascal gro	0
41	Florian Wirtz	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	florian wirtz	0
1194	Sheral Floranus	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sheral floranus	0
18	Rodrigo Zalazar	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rodrigo zalazar	0
183	José Sá	Goalkeeper	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jose sa	0
159	Ederson	Goalkeeper	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ederson	0
160	Roger Ibañez	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	roger ibanez	0
161	Bremer	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bremer	0
162	Alex Sandro	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alex sandro	0
166	Léo Pereira	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	leo pereira	0
167	Gabriel Magalhães	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gabriel magalhaes	0
168	Wesley	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	wesley	0
169	Lucas Paquetá	Midfield	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lucas paqueta	0
170	Bruno Guimarães	Midfield	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bruno guimaraes	0
172	Fabinho	Midfield	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fabinho	0
173	Danilo dos Santos de Oliveira	Midfield	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	danilo dos santos de oliveira	0
175	Neymar	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	neymar	0
176	Matheus Cunha	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matheus cunha	0
177	Raphinha	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	raphinha	0
178	Martinelli	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	martinelli	0
179	Thiago	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	thiago	0
228	Ritsu Doan	Offence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ritsu doan	0
229	Daizen Maeda	Offence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	daizen maeda	0
230	Koki Ogawa	Offence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	koki ogawa	0
231	Junya Ito	Offence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	junya ito	0
232	Ayase Ueda	Offence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ayase ueda	0
233	Kento Shiogai	Offence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kento shiogai	0
234	Keisuke Goto	Offence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	keisuke goto	0
235	Guillermo Ochoa	Goalkeeper	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	guillermo ochoa	0
236	Carlos Acevedo	Goalkeeper	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	carlos acevedo	0
237	José Rangel	Goalkeeper	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jose rangel	0
1026	Ró-Ró	Defence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	roro	0
239	César Montes	Defence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cesar montes	0
240	Johan Vásquez	Defence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	johan vasquez	0
241	Jorge Sánchez	Defence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jorge sanchez	0
242	Israel Reyes	Defence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	israel reyes	0
243	Mateo Chávez	Defence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mateo chavez	0
245	Orbelín Pineda	Midfield	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	orbelin pineda	0
246	Luis Chávez	Midfield	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luis chavez	0
180	Luiz Henrique	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luiz henrique	0
181	Endrick	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	endrick	0
182	Rayan	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rayan	0
238	Jesús Gallardo	Defence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jesus gallardo	0
416	Aziz Behich	Defence	Australia	Australia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aziz behich	0
537	Alexander Isak	Offence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexander isak	0
538	Viktor Gyökeres	Offence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	viktor gyokeres	0
539	Gustaf Nilsson	Offence	Sweden	Sweden	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gustaf nilsson	0
663	Can Uzun	Offence	Turkey	Turkey	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	can uzun	0
849	Ricardo Adé	Defence	Haiti	Haiti	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ricardo ade	0
965	Nuno Da Costa	Offence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nuno da costa	0
966	Dailon Rocha Livramento	Offence	Cape Verde Islands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dailon rocha livramento	0
967	Hélio Varela	Offence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	helio varela	0
968	Timothy Fayulu	Goalkeeper	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	timothy fayulu	0
969	Lionel Mpasi	Goalkeeper	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lionel mpasi	0
970	Matthieu Epolo	Goalkeeper	Congo DR	Congo DR	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matthieu epolo	0
971	Axel Tuanzebe	Defence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	axel tuanzebe	0
311	Folarin Balogun	Offence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	folarin balogun	0
74	Borja Iglesias	Offence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	borja iglesias	0
75	Yeremi Pino	Offence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yeremi pino	0
76	Nico Williams	Offence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nico williams	0
77	Lamine Yamal	Offence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lamine yamal	0
78	Víctor Muñoz	Offence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	victor munoz	0
972	Chancel Mbemba	Defence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	chancel mbemba	0
974	Arthur Masuaku	Defence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	arthur masuaku	0
975	Joris Kayembe	Defence	Congo DR	Congo DR	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joris kayembe	0
124	Nico Paz	Midfield	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nico paz	0
248	Erik Lira	Midfield	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	3	2026-06-16 11:34:59.983529	erik lira	1
255	Roberto Alvarado	Offence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	3	2026-06-16 11:34:59.983529	roberto alvarado	1
976	Dylan Batubinsika	Defence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dylan batubinsika	0
977	Gédéon Kalulu	Defence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gedeon kalulu	0
978	Steve Kapuadi	Defence	Congo DR	Congo DR	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	steve kapuadi	0
249	Álvaro Fidalgo	Midfield	Mexico	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alvaro fidalgo	0
250	Brian Gutiérrez	Midfield	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brian gutierrez	0
251	Obed Vargas	Midfield	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	obed vargas	0
252	Gilberto Mora	Midfield	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gilberto mora	0
254	Julián Quiñones	Offence	Mexico	Colombia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	julian quinones	0
256	Santiago Giménez	Offence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	santiago gimenez	0
257	Alexis Vega	Offence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexis vega	0
258	Guillermo Martínez	Offence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	guillermo martinez	0
259	César Huerta	Offence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cesar huerta	0
260	Armando González	Offence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	armando gonzalez	0
293	Auston Trusty	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	auston trusty	0
294	Mark McKenzie	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mark mckenzie	0
295	Joseph Scally	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joseph scally	0
296	Sergiño Dest	Defence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sergino dest	0
980	Samuel Moutoussamy	Midfield	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	samuel moutoussamy	0
981	Edo Kayembe	Midfield	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	edo kayembe	0
982	Aaron Tshibola	Midfield	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aaron tshibola	0
983	Charles Pickel	Midfield	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	charles pickel	0
984	Noah Sadiki	Midfield	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	noah sadiki	0
985	Ngal'ayel Mukau	Midfield	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ngalayel mukau	0
986	Yoane Wissa	Offence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yoane wissa	0
987	Theo Bongonda	Offence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	theo bongonda	0
988	Cédric Bakambu	Offence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cedric bakambu	0
993	Fiston Mayele	Offence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fiston mayele	0
994	Yahia Fofana	Goalkeeper	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yahia fofana	0
995	Alban Lafont	Goalkeeper	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alban lafont	0
996	Mohamed Kone	Goalkeeper	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohamed kone	0
997	Evan N'Dicka	Defence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	evan ndicka	0
998	Christopher Operi	Defence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	christopher operi	0
999	Ghislain Konan	Defence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ghislain konan	0
1000	Wilfried Singo	Defence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	wilfried singo	0
1001	Guela Doué	Defence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	guela doue	0
93	Mauricio	Midfield	Paraguay	Paraguay	2026-06-04 14:35:02.161848	1	0	0	4	2026-06-16 12:20:37.65415	mauricio	0
1002	Emmanuel Agbadou	Defence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	emmanuel agbadou	0
79	Gastón Olveira	Goalkeeper	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gaston olveira	0
1003	Odilon Kossounou	Defence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	odilon kossounou	0
1004	Ousmane Diomande	Defence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ousmane diomande	0
1005	Franck Kessié	Midfield	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	franck kessie	0
1043	Edmílson	Offence	Qatar	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	edmilson	0
10	Mathías Olivera	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mathias olivera	0
11	Santiago Bueno	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	santiago bueno	0
12	José Giménez	Defence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jose gimenez	0
13	Federico Valverde	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	federico valverde	0
14	Giorgian De Arrascaeta	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	giorgian de arrascaeta	0
320	Jin-seob Park	Defence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jinseob park	0
321	Tae-hyeon Kim	Defence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	taehyeon kim	0
322	Gi-hyuk Lee	Defence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gihyuk lee	0
323	Tae-seok Lee	Defence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	taeseok lee	0
324	Jens Castrop	Midfield	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jens castrop	0
325	In-beom Hwang	Midfield	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	inbeom hwang	0
326	Dong-gyeong Lee	Midfield	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	donggyeong lee	0
327	Jae-sung Lee	Midfield	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jaesung lee	0
16	Manuel Ugarte	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	manuel ugarte	0
1059	Mahmoud Al Mardi	Offence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mahmoud al mardi	0
1060	Baha' Faisal	Offence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	baha faisal	0
1061	Ibrahim Sabra	Offence	Jordan	Jordan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrahim sabra	0
1062	Jalal Hassan	Goalkeeper	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jalal hassan	0
1063	Fahad Talib	Goalkeeper	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fahad talib	0
1064	Ahmed Basil	Goalkeeper	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed basil	0
1066	Merchas Doski	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	merchas doski	0
1067	Rebin Sulaka	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rebin sulaka	0
1068	Mustafa Saadoun	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mustafa saadoun	0
1069	Ahmed Yahya	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed yahya	0
1070	Frans Putros	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	frans putros	0
1071	Zaid Tahseen	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zaid tahseen	0
1072	Manaf Younis	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	manaf younis	0
1073	Akam Hashem	Defence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	akam hashem	0
1074	Amir Al Ammari	Midfield	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amir al ammari	0
1075	Kevin Yakob	Midfield	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kevin yakob	0
1076	Aimar Sher	Midfield	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aimar sher	0
92	Miguel Almirón	Midfield	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	miguel almiron	0
94	Braian Ojeda	Midfield	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	braian ojeda	0
95	Matías Galarza	Midfield	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	matias galarza	0
96	Damian Bobadilla	Midfield	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	damian bobadilla	0
97	Diego Gómez	Midfield	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	diego gomez	0
98	Antonio Sanabria	Offence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	antonio sanabria	0
1080	Zidane Iqbal	Midfield	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zidane iqbal	0
1081	Zaid Ismail	Midfield	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zaid ismail	0
1082	Aymen Hussein	Offence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aymen hussein	0
1083	Ali Al-Hamadi	Offence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ali alhamadi	0
1084	Marko Farji	Offence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marko farji	0
1085	Ali Jassim El-Aibi	Offence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ali jassim elaibi	0
299	Weston McKennie	Midfield	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	weston mckennie	0
125	Lionel Messi	Offence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lionel messi	0
117	Rodrigo de Paul	Midfield	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rodrigo de paul	0
113	Lisandro Martínez	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lisandro martinez	0
704	Kevin De Bruyne	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kevin de bruyne	0
360	Kylian Mbappé	Offence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kylian mbappe	0
1012	Nicolas Pépé	Offence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nicolas pepe	0
307	Christian Pulisic	Offence	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	christian pulisic	0
202	Cristiano Ronaldo	Offence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cristiano ronaldo	0
150	Jordan Ayew	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jordan ayew	0
143	Thomas Partey	Midfield	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	thomas partey	0
345	Dayot Upamecano	Defence	France	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dayot upamecano	0
32	Antonio Rüdiger	Defence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	antonio rudiger	0
204	Rafael Leão	Offence	Portugal	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rafael leao	0
253	Raúl Jiménez	Offence	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	raul jimenez	0
328	Jin-Gyu Kim	Midfield	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jingyu kim	0
329	Seung-Ho Paik	Midfield	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	seungho paik	0
330	Kang-in Lee	Midfield	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kangin lee	0
49	Deniz Undav	Offence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	deniz undav	0
50	Jamie Leweling	Offence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jamie leweling	0
51	Nick Woltemade	Offence	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nick woltemade	0
313	Seung-Gyu Kim	Goalkeeper	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	seunggyu kim	0
314	Bum-keun Song	Goalkeeper	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bumkeun song	0
315	Hyeon-woo Jo	Goalkeeper	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hyeonwoo jo	0
316	Min-Jae Kim	Defence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	minjae kim	0
317	Moon-hwan Kim	Defence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	moonhwan kim	0
318	Han-bum Lee	Defence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hanbum lee	0
319	Young-woo Seol	Defence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	youngwoo seol	0
331	Joon-ho Bae	Midfield	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joonho bae	0
332	Hwang Heechan	Offence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hwang heechan	0
333	Heung-min Son	Offence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	heungmin son	0
334	Hyun-jun Yang	Offence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hyunjun yang	0
335	Gue-Sung Cho	Offence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	guesung cho	0
336	Hyun-Gyu Oh	Offence	South Korea	South Korea	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hyungyu oh	0
303	Brenden Aaronson	Midfield	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brenden aaronson	0
304	Gio Reyna	Midfield	USA	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gio reyna	0
478	Denis Zakaria	Midfield	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	denis zakaria	0
602	Hassan Kadesh	Defence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hassan kadesh	0
603	Moteb Al Harbi	Defence	Saudi Arabia	Saudi Arabia	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	moteb al harbi	0
666	Mory Diaw	Goalkeeper	Senegal	Senegal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mory diaw	0
728	Zakaria El Ouahdi	Defence	Morocco	Morocco	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zakaria el ouahdi	0
1048	Mohammad Abualnadi	Defence	Jordan	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohammad abualnadi	0
1147	David Wolfe	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	david wolfe	0
1148	Morten Thorsby	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	morten thorsby	0
1149	Martin Ødegaard	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	martin degaard	0
1150	Sander Berge	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sander berge	0
1151	Patrick Berg	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	patrick berg	0
1152	Fredrik Aursnes	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	fredrik aursnes	0
1153	Kristian Thorstvedt	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kristian thorstvedt	0
1155	Antonio Nusa	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	antonio nusa	0
1156	Oscar Bobb	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	oscar bobb	0
1157	Alexander Sørloth	Offence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	alexander srloth	0
1158	Jens Hauge	Offence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jens hauge	0
1188	Trevor Doornbusch	Goalkeeper	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	trevor doornbusch	0
1189	Eloy Room	Goalkeeper	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	eloy room	0
1190	Tyrick Bodak	Goalkeeper	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tyrick bodak	0
1191	Roshon van Eijma	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	roshon van eijma	0
1192	Joshua Brenet	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joshua brenet	0
1193	Armando Obispo	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	armando obispo	0
1006	Seko Fofana	Midfield	Ivory Coast	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	seko fofana	0
1007	Ibrahim Sangaré	Midfield	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ibrahim sangare	0
1008	Jean Michaël Seri	Midfield	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jean michael seri	0
1009	Amad Diallo	Midfield	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	amad diallo	0
1010	Parfait Guiagon	Midfield	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	parfait guiagon	0
1011	Christ Ravynel Inao Oulaï	Midfield	Ivory Coast	Cote d'Ivoire	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	christ ravynel inao oulai	0
1013	Evann Guessand	Offence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	evann guessand	0
1014	Ange-Yoan Bonny	Offence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	angeyoan bonny	0
1015	Sepe Elye Wahi	Offence	Ivory Coast	France	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sepe elye wahi	0
17	Brian Rodríguez	Midfield	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brian rodriguez	0
122	Thiago Almada	Midfield	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	thiago almada	0
123	Enzo Fernández	Midfield	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	enzo fernandez	0
126	Lautaro Martínez	Offence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lautaro martinez	0
127	Nicolás González	Offence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nicolas gonzalez	0
128	Julián Álvarez	Offence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	julian alvarez	0
129	José Manuel López	Offence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jose manuel lopez	0
130	Giuliano Simeone	Offence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	giuliano simeone	0
131	Lawrence Ati-Zigi	Goalkeeper	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lawrence atizigi	0
132	Joseph Anang	Goalkeeper	Ghana	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joseph anang	0
133	Benjamin Asare	Goalkeeper	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	benjamin asare	0
91	Kaku	Midfield	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kaku	0
1016	Simon Adingra	Offence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	simon adingra	0
1017	Oumar Diakite	Offence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	oumar diakite	0
1018	Bazoumana Touré	Offence	Ivory Coast	Ivory Coast	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bazoumana toure	0
142	Kojo Peprah Oppong	Defence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kojo peprah oppong	0
144	Elisha Owusu	Midfield	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	elisha owusu	0
145	Kwasi Sibo	Midfield	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kwasi sibo	0
146	Augustine Boakye	Midfield	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	augustine boakye	0
147	Caleb Yirenkyi	Midfield	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	caleb yirenkyi	0
148	Antoine Semenyo	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	antoine semenyo	0
149	Brandon Thomas-Asante	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brandon thomasasante	0
151	Iñaki Williams	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	inaki williams	0
152	Kamal Deen Sulemana	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kamal deen sulemana	0
153	Ernest Nuamah	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ernest nuamah	0
1170	Anthony Ralston	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	anthony ralston	0
1171	John Souttar	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	john souttar	0
1172	Scott McKenna	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	scott mckenna	0
1173	Aaron Hickey	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aaron hickey	0
1174	Nathan Patterson	Defence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nathan patterson	0
1175	Scott McTominay	Midfield	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	scott mctominay	0
1176	Kenny McLean	Midfield	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kenny mclean	0
1177	Ryan Christie	Midfield	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ryan christie	0
1178	Lewis Ferguson	Midfield	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	lewis ferguson	0
1179	John McGinn	Midfield	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	john mcginn	0
1180	Ben Doak	Midfield	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ben doak	0
1181	Findlay Curtis	Midfield	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	findlay curtis	0
1182	Tyler Fletcher	Midfield	Scotland	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tyler fletcher	0
1183	Che Adams	Offence	Scotland	Scotland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	che adams	0
209	Keisuke Ōsako	Goalkeeper	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	keisuke osako	0
157	Weverton	Goalkeeper	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	weverton	0
164	Douglas Santos	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	douglas santos	0
165	Danilo Luiz da Silva	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	danilo luiz da silva	0
104	Alex Arce	Offence	Paraguay	Paraguay	2026-06-04 14:35:02.161848	0	1	0	-1	2026-06-16 12:20:37.65415	alex arce	0
154	Abdul Issahaku	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdul issahaku	0
155	Christopher Bonsu Baah	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	christopher bonsu baah	0
156	Prince Adu	Offence	Ghana	Ghana	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	prince adu	0
210	Zion Suzuki	Goalkeeper	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	zion suzuki	0
211	Tomoki Hayakawa	Goalkeeper	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tomoki hayakawa	0
212	Yūto Nagatomo	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yuto nagatomo	0
213	Takehiro Tomiyasu	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	takehiro tomiyasu	0
1029	Ayoub Al-Oui	Defence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ayoub aloui	0
1030	Assim Madibo	Midfield	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	assim madibo	0
1031	Abdulaziz Hatem	Midfield	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdulaziz hatem	0
1032	Karim Boudiaf	Midfield	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	karim boudiaf	0
1033	Ahmed Fathy	Midfield	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ahmed fathy	0
1038	Akram Afif	Offence	Qatar	Qatar	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	akram afif	0
973	Aaron Wan-Bissaka	Defence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	aaron wanbissaka	0
469	Ricardo Rodriguez	Defence	Switzerland	Switzerland	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ricardo rodriguez	0
26	Federico Viñas	Offence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	federico vinas	0
979	Gaël Kakuta	Midfield	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gael kakuta	0
1086	Mohanad Ali	Offence	Iraq	Iraq	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mohanad ali	0
1087	Botirali Ergashev	Goalkeeper	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	botirali ergashev	0
1088	Abduvakhid Nematov	Goalkeeper	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abduvakhid nematov	0
1089	Utkir Yusupov	Goalkeeper	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	utkir yusupov	0
1090	Rustam Ashurmatov	Defence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rustam ashurmatov	0
1091	Umar Eshmurodov	Defence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	umar eshmurodov	0
1092	Abdukodir Khusanov	Defence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	abdukodir khusanov	0
1093	Jakhongir O'rozov	Defence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jakhongir orozov	0
1094	Farrukh Sayfiyev	Defence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	farrukh sayfiyev	0
1095	Khodjiakbar Alijonov	Defence	Uzbekistan	Uzbekistan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	khodjiakbar alijonov	0
57	Cucurella	Defence	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cucurella	0
1139	Kristoffer Ajer	Defence	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kristoffer ajer	0
1154	Thelo Aasgaard	Midfield	Norway	Norway	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	thelo aasgaard	0
714	Romelu Lukaku	Offence	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	romelu lukaku	0
38	Joshua Kimmich	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joshua kimmich	0
44	Jamal Musiala	Midfield	Germany	Germany	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jamal musiala	0
705	Axel Witsel	Midfield	Belgium	Belgium	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	axel witsel	0
108	Nicolás Otamendi	Defence	Argentina	Argentina	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nicolas otamendi	0
174	Vinicius Junior	Offence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	vinicius junior	0
944	C.J. dos Santos	Goalkeeper	Cape Verde Islands	USA	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	cj dos santos	0
945	Steven Moreira	Defence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	steven moreira	0
946	Logan Costa	Defence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	logan costa	0
947	Roberto Lopes	Defence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	roberto lopes	0
948	Diney Borges	Defence	Cape Verde Islands	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	diney borges	0
949	Stopira	Defence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	stopira	0
950	Sidny Lopes Cabral	Defence	Cape Verde Islands	Netherlands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sidny lopes cabral	0
951	Wagner Pina	Defence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	wagner pina	0
952	Kelvin Pires	Defence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kelvin pires	0
953	Deroy Duarte	Midfield	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	deroy duarte	0
955	Kevin Pina	Midfield	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kevin pina	0
956	Laros Duarte	Midfield	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	laros duarte	0
957	Yannick Semedo	Midfield	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yannick semedo	0
958	Telmo Arcanjo	Midfield	Cape Verde Islands	Portugal	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	telmo arcanjo	0
959	Jamiro Monteiro	Midfield	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jamiro monteiro	0
960	João Paulo	Midfield	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	joao paulo	0
961	Willy Semedo	Offence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	willy semedo	0
962	Ryan Mendes	Offence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ryan mendes	0
963	Jovane Cabral	Offence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jovane cabral	0
964	Gilson Tavares	Offence	Cape Verde Islands	Cape Verde Islands	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	gilson tavares	0
989	Simon Banza	Offence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	simon banza	0
990	Nathanael Mbuku	Offence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nathanael mbuku	0
991	Meschack Elia	Offence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	meschack elia	0
992	Brian Cipenga	Offence	Congo DR	DR Congo	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brian cipenga	0
1195	Riechedly Bazoer	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	riechedly bazoer	0
838	Cyle Larin	Offence	Canada	Canada	2026-06-04 14:35:02.161848	1	0	0	4	2026-06-16 12:04:02.287983	cyle larin	0
828	Jonathan Osorio	Midfield	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jonathan osorio	0
829	Stephen Eustáquio	Midfield	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	stephen eustaquio	0
830	Mathieu Choinière	Midfield	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	mathieu choiniere	0
831	Tajon Buchanan	Midfield	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tajon buchanan	0
832	Marcelo Flores	Midfield	Canada	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marcelo flores	0
833	Nathan-Dylan Saliba	Midfield	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nathandylan saliba	0
834	Ismael Kone	Midfield	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ismael kone	0
835	Ali Ahmed	Midfield	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ali ahmed	0
836	Niko Sigur	Midfield	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	niko sigur	0
837	Jonathan David	Offence	Canada	Canada	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jonathan david	0
1196	Juriën Gaari	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jurien gaari	0
1197	Shurandy Sambo	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	shurandy sambo	0
1198	Ar'jany Martha	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	arjany martha	0
1199	Livano Comenencia	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	livano comenencia	0
1200	Deveron Fonville	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	deveron fonville	0
1201	Tyrese Noslin	Defence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tyrese noslin	0
214	Hiroki Ito	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	hiroki ito	0
215	Yukinari Sugawara	Defence	Japan	Japan	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	yukinari sugawara	0
1209	Tahith Chong	Offence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	tahith chong	0
1210	Sontje Hansen	Offence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	sontje hansen	0
1211	Jearl Margaritha	Offence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jearl margaritha	0
1212	Jeremy Antonisse	Offence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jeremy antonisse	0
1213	Brandley Kuwas	Offence	Curaçao	Curaçao	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	brandley kuwas	0
261	Jordan Pickford	Goalkeeper	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jordan pickford	0
262	Dean Henderson	Goalkeeper	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dean henderson	0
263	James Trafford	Goalkeeper	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	james trafford	0
264	John Stones	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	john stones	0
265	Dan Burn	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	dan burn	0
266	Ezri Konsa	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ezri konsa	0
267	Reece James	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	reece james	0
268	Djed Spence	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	djed spence	0
269	Marc Guéhi	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marc guehi	0
270	Valentino Livramento	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	valentino livramento	0
271	Jarell Quansah	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jarell quansah	0
272	Nico O'Reilly	Defence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	nico oreilly	0
273	Jordan Henderson	Midfield	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jordan henderson	0
274	Eberechi Eze	Midfield	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	eberechi eze	0
275	Anthony Gordon	Midfield	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	anthony gordon	0
276	Declan Rice	Midfield	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	declan rice	0
277	Morgan Rogers	Midfield	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	morgan rogers	0
278	Elliot Anderson	Midfield	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	elliot anderson	0
280	Kobbie Mainoo	Midfield	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	kobbie mainoo	0
282	Ollie Watkins	Offence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ollie watkins	0
283	Ivan Toney	Offence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ivan toney	0
286	Noni Madueke	Offence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	noni madueke	0
279	Jude Bellingham	Midfield	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	jude bellingham	0
285	Bukayo Saka	Offence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	bukayo saka	0
23	Rodrigo Aguirre	Offence	Uruguay	Uruguay	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rodrigo aguirre	0
247	Luis Romo	Midfield	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	luis romo	0
65	Rodri	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	rodri	0
171	Casemiro	Midfield	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	casemiro	0
163	Marquinhos	Defence	Brazil	Brazil	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marquinhos	0
68	Ferrán Torres	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	ferran torres	0
70	Pedri	Midfield	Spain	Spain	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	pedri	0
284	Harry Kane	Offence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	harry kane	0
244	Edson Álvarez	Midfield	Mexico	Mexico	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	edson alvarez	0
281	Marcus Rashford	Offence	England	England	2026-06-04 14:35:02.161848	0	0	0	0	2026-06-16 07:51:41.483136	marcus rashford	0
\.


--
-- Data for Name: team_rankings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_rankings (id, team_id, rank, points, goal_difference, updated_at) FROM stdin;
13	30	1	3	3	2026-06-16 12:20:37.65415
1	24	2	3	2	2026-06-16 12:20:37.65415
4	42	3	3	1	2026-06-16 12:20:37.65415
9	40	4	1	0	2026-06-16 12:20:37.65415
10	11	4	1	0	2026-06-16 12:20:37.65415
5	33	6	0	-1	2026-06-16 12:20:37.65415
2	39	7	0	-2	2026-06-16 12:20:37.65415
20	26	8	0	-3	2026-06-16 12:20:37.65415
\.


--
-- Data for Name: team_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_stats (id, team_name, goals_scored, goals_conceded, wins, losses, draws, matches_played, created_at, updated_at, points) FROM stdin;
43	Belgium	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
44	Japan	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
45	Argentina	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
46	Portugal	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
47	Jordan	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
48	Norway	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
42	South Korea	2	1	1	0	0	1	2026-06-09 00:24:36.052549	2026-06-16 11:54:57.447647	3
1	Qatar	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
2	Austria	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
3	Senegal	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
4	Haiti	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
5	Ecuador	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
6	Uruguay	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
7	Panama	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
8	Algeria	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
9	Tunisia	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
10	Congo DR	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
12	Turkey	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
13	Ghana	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
14	Saudi Arabia	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
15	Uzbekistan	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
16	England	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
17	Morocco	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
18	Scotland	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
19	Ivory Coast	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
20	Curaçao	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
21	Colombia	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
22	Australia	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
23	Iraq	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
25	Spain	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
27	Iran	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
28	Cape Verde Islands	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
29	Egypt	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
31	Brazil	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
32	Netherlands	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
34	Germany	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
35	France	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
36	Croatia	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
37	Sweden	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
38	Switzerland	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
41	New Zealand	0	0	0	0	0	0	2026-06-09 00:24:36.052549	2026-06-09 00:24:36.052549	0
24	Mexico	2	0	1	0	0	1	2026-06-09 00:24:36.052549	2026-06-16 11:34:59.983529	3
39	South Africa	0	2	0	1	0	1	2026-06-09 00:24:36.052549	2026-06-16 11:34:59.983529	0
33	Czechia	1	2	0	1	0	1	2026-06-09 00:24:36.052549	2026-06-16 11:54:57.447647	0
40	Canada	1	1	0	0	1	1	2026-06-09 00:24:36.052549	2026-06-16 12:04:02.287983	1
11	Bosnia-Herzegovina	1	1	0	0	1	1	2026-06-09 00:24:36.052549	2026-06-16 12:04:02.287983	1
30	United States	4	1	1	0	0	1	2026-06-09 00:24:36.052549	2026-06-16 12:20:37.65415	3
26	Paraguay	1	4	0	1	0	1	2026-06-09 00:24:36.052549	2026-06-16 12:20:37.65415	0
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (id, name, created_at) FROM stdin;
1	Qatar	2026-06-04 14:52:39.038865
2	Austria	2026-06-04 14:52:39.038865
3	Senegal	2026-06-04 14:52:39.038865
4	Haiti	2026-06-04 14:52:39.038865
5	Ecuador	2026-06-04 14:52:39.038865
6	Uruguay	2026-06-04 14:52:39.038865
7	Panama	2026-06-04 14:52:39.038865
8	Algeria	2026-06-04 14:52:39.038865
9	Tunisia	2026-06-04 14:52:39.038865
10	Congo DR	2026-06-04 14:52:39.038865
11	Bosnia-Herzegovina	2026-06-04 14:52:39.038865
12	Turkey	2026-06-04 14:52:39.038865
13	Ghana	2026-06-04 14:52:39.038865
14	Saudi Arabia	2026-06-04 14:52:39.038865
15	Uzbekistan	2026-06-04 14:52:39.038865
16	England	2026-06-04 14:52:39.038865
17	Morocco	2026-06-04 14:52:39.038865
18	Scotland	2026-06-04 14:52:39.038865
19	Ivory Coast	2026-06-04 14:52:39.038865
20	Curaçao	2026-06-04 14:52:39.038865
21	Colombia	2026-06-04 14:52:39.038865
22	Australia	2026-06-04 14:52:39.038865
23	Iraq	2026-06-04 14:52:39.038865
24	Mexico	2026-06-04 14:52:39.038865
25	Spain	2026-06-04 14:52:39.038865
26	Paraguay	2026-06-04 14:52:39.038865
27	Iran	2026-06-04 14:52:39.038865
28	Cape Verde Islands	2026-06-04 14:52:39.038865
29	Egypt	2026-06-04 14:52:39.038865
30	United States	2026-06-04 14:52:39.038865
31	Brazil	2026-06-04 14:52:39.038865
32	Netherlands	2026-06-04 14:52:39.038865
33	Czechia	2026-06-04 14:52:39.038865
34	Germany	2026-06-04 14:52:39.038865
35	France	2026-06-04 14:52:39.038865
36	Croatia	2026-06-04 14:52:39.038865
37	Sweden	2026-06-04 14:52:39.038865
38	Switzerland	2026-06-04 14:52:39.038865
39	South Africa	2026-06-04 14:52:39.038865
40	Canada	2026-06-04 14:52:39.038865
41	New Zealand	2026-06-04 14:52:39.038865
42	South Korea	2026-06-04 14:52:39.038865
43	Belgium	2026-06-04 14:52:39.038865
44	Japan	2026-06-04 14:52:39.038865
45	Argentina	2026-06-04 14:52:39.038865
46	Portugal	2026-06-04 14:52:39.038865
47	Jordan	2026-06-04 14:52:39.038865
48	Norway	2026-06-04 14:52:39.038865
\.


--
-- Name: match_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.match_events_id_seq', 187, true);


--
-- Name: match_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.match_results_id_seq', 586, true);


--
-- Name: player_rankings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.player_rankings_id_seq', 46, true);


--
-- Name: player_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.player_stats_id_seq', 15, true);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.players_id_seq', 1265, true);


--
-- Name: team_rankings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.team_rankings_id_seq', 20, true);


--
-- Name: team_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.team_stats_id_seq', 48, true);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teams_id_seq', 48, true);


--
-- Name: fixtures fixtures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixtures
    ADD CONSTRAINT fixtures_pkey PRIMARY KEY (id);


--
-- Name: match_events match_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_events
    ADD CONSTRAINT match_events_pkey PRIMARY KEY (id);


--
-- Name: match_results match_results_event_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_results
    ADD CONSTRAINT match_results_event_id_key UNIQUE (event_id);


--
-- Name: match_results match_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_results
    ADD CONSTRAINT match_results_pkey PRIMARY KEY (id);


--
-- Name: player_rankings player_rankings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_rankings
    ADD CONSTRAINT player_rankings_pkey PRIMARY KEY (id);


--
-- Name: player_rankings player_rankings_player_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_rankings
    ADD CONSTRAINT player_rankings_player_id_key UNIQUE (player_id);


--
-- Name: player_stats player_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_stats
    ADD CONSTRAINT player_stats_pkey PRIMARY KEY (id);


--
-- Name: players players_name_team_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_name_team_unique UNIQUE (name, team_name);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: team_rankings team_rankings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_rankings
    ADD CONSTRAINT team_rankings_pkey PRIMARY KEY (id);


--
-- Name: team_rankings team_rankings_team_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_rankings
    ADD CONSTRAINT team_rankings_team_id_key UNIQUE (team_id);


--
-- Name: team_stats team_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_stats
    ADD CONSTRAINT team_stats_pkey PRIMARY KEY (id);


--
-- Name: team_stats team_stats_team_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_stats
    ADD CONSTRAINT team_stats_team_name_key UNIQUE (team_name);


--
-- Name: teams teams_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_name_key UNIQUE (name);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: player_rankings player_rankings_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_rankings
    ADD CONSTRAINT player_rankings_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id) ON DELETE CASCADE;


--
-- Name: team_rankings team_rankings_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_rankings
    ADD CONSTRAINT team_rankings_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.team_stats(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 8JrPIm29pUGeXwYsXmcpUfI2YzTEBGun5Y94dvfKippK1ISllxdnhW6N6igQBzt

