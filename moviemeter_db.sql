--
-- PostgreSQL database dump
--

-- Dumped from database version 17.1
-- Dumped by pg_dump version 17.1

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
-- Name: discussions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discussions (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    user_id integer NOT NULL,
    content text NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.discussions OWNER TO postgres;

--
-- Name: discussions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discussions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.discussions_id_seq OWNER TO postgres;

--
-- Name: discussions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discussions_id_seq OWNED BY public.discussions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: discussions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions ALTER COLUMN id SET DEFAULT nextval('public.discussions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: discussions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussions (id, movie_id, user_id, content, "timestamp") FROM stdin;
21	1	1	This is a test comment	2024-11-22 00:28:51.602155
22	1084736	2	trying	2024-11-22 01:09:54.059993
23	1084736	3	trying harder	2024-11-22 02:11:13.734201
24	1184918	3	This movie cured my depression!	2024-11-22 14:18:26.372682
25	912649	3	Great Movie!!!	2024-11-22 15:42:29.023051
26	1241982	5	its alright:/	2024-12-03 00:46:07.112577
27	1241982	6	I heard it is terrible!	2024-12-03 00:50:48.00332
28	889737	6	This movie was horrible! I wish i could get my money back!	2024-12-03 00:51:39.708221
29	533535	6	Movie of the year! Ryan Reynolds saved marvel!	2024-12-03 00:53:26.381928
30	360920	6	Perfect Christmas movie!	2024-12-03 00:54:04.790487
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash) FROM stdin;
1	test_user	test_user@example.com	scrypt:32768:8:1$XtSvblqM3mfzTX6m$38c451932e8dfae0647f1759f75b11f0a1536e8228e8dc78d112464cb9714f5aaffe32dcec8310dfcb6747fdd1b8c90f1510f423ff679c180614e71c9f9f54cd
2	test_userr	test_uoser@example.com	scrypt:32768:8:1$SyknR4WtdQuJOZeP$3ceaae308cf978e36f14a14b37e4a8ec5cfd301283cbf440af818d19276ae649924606e839bdaa1bebc4138ec800c15669296e259dc3da80c4dd3e7321c90d0a
3	testuser2	testuser2@gmail.com	scrypt:32768:8:1$hy3wYnAIn3t9e0t4$d46234752b6853835f35ce0a6b4e8efeaa2b6bb76f508b3ad121d2e931607bada0b621f92724f67d262a7da0c10864e70063c4780b6897ed7ee33a313b7a8557
5	matthewA	matthewA@gmail.com	scrypt:32768:8:1$ClsInQXQ2Gb8teXx$5e261457040bf119ebca15ebdc214bf5a981dc645deeb3e77cb9920915ba2e7e9b446f8dc1a02e999e93ee4e0ef70b40ec3cd015bd547638ff00297ba6aea7e9
6	CSC184	CSC184@gmail.com	scrypt:32768:8:1$I6sIoek8BeDrmyuD$2773e30982cd9aa209ca560182710dcccec99c8fef984d26abf66c43e57050d033531d90f68e03fe9b9dd9ab5b3cf4cd1581efb3dbeb2f2d37e1c2ad517bed9a
\.


--
-- Name: discussions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discussions_id_seq', 30, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: discussions discussions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT discussions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: discussions fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussions
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

