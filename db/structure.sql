--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: check_allocation_percentages(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION check_allocation_percentages() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
              IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
                IF sum_allocation_percentages(NEW.portfolio_id) != 1.0 THEN
                  RAISE EXCEPTION 'Portfolio % allocation weights must equal 1.0', NEW.portfolio_id;
                END IF;
              END IF;

              IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
                IF sum_allocation_percentages(OLD.portfolio_id) != 1.0 THEN
                  RAISE EXCEPTION 'Portfolio % allocation weights must equal 1.0', OLD.portfolio_id;
                END IF;
              END IF;

              RETURN NULL;
            END;
          $$;


--
-- Name: sum_allocation_percentages(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sum_allocation_percentages(selected_portfolio_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
            BEGIN
              RETURN (
                SELECT sum(weight)
                  FROM allocations
                  WHERE allocations.portfolio_id = selected_portfolio_id
              );
            END;
          $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: allocations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE allocations (
    id integer NOT NULL,
    asset_class_id integer NOT NULL,
    portfolio_id integer NOT NULL,
    weight numeric(3,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: allocations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE allocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: allocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE allocations_id_seq OWNED BY allocations.id;


--
-- Name: asset_classes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE asset_classes (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: asset_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE asset_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: asset_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE asset_classes_id_seq OWNED BY asset_classes.id;


--
-- Name: funds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE funds (
    id integer NOT NULL,
    asset_class_id integer NOT NULL,
    name character varying NOT NULL,
    symbol character varying NOT NULL,
    expense_ratio numeric(4,4) NOT NULL,
    price money NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    price_updated_at timestamp without time zone
);


--
-- Name: funds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE funds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: funds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE funds_id_seq OWNED BY funds.id;


--
-- Name: lots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lots (
    id integer NOT NULL,
    fund_id integer,
    portfolio_id integer,
    acquired_at timestamp without time zone,
    sold_at timestamp without time zone,
    proceeds money,
    quantity numeric(15,6),
    share_cost money,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lots_id_seq OWNED BY lots.id;


--
-- Name: portfolios; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE portfolios (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: portfolios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE portfolios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portfolios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE portfolios_id_seq OWNED BY portfolios.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY allocations ALTER COLUMN id SET DEFAULT nextval('allocations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY asset_classes ALTER COLUMN id SET DEFAULT nextval('asset_classes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY funds ALTER COLUMN id SET DEFAULT nextval('funds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lots ALTER COLUMN id SET DEFAULT nextval('lots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY portfolios ALTER COLUMN id SET DEFAULT nextval('portfolios_id_seq'::regclass);


--
-- Name: allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY allocations
    ADD CONSTRAINT allocations_pkey PRIMARY KEY (id);


--
-- Name: asset_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY asset_classes
    ADD CONSTRAINT asset_classes_pkey PRIMARY KEY (id);


--
-- Name: funds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY funds
    ADD CONSTRAINT funds_pkey PRIMARY KEY (id);


--
-- Name: lots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lots
    ADD CONSTRAINT lots_pkey PRIMARY KEY (id);


--
-- Name: portfolios_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY portfolios
    ADD CONSTRAINT portfolios_pkey PRIMARY KEY (id);


--
-- Name: index_allocations_on_portfolio_id_and_asset_class_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_allocations_on_portfolio_id_and_asset_class_id ON allocations USING btree (portfolio_id, asset_class_id);


--
-- Name: index_funds_on_symbol; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_funds_on_symbol ON funds USING btree (symbol);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: allocation_percentage_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER allocation_percentage_trigger AFTER INSERT OR DELETE OR UPDATE ON allocations DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE check_allocation_percentages();


--
-- Name: fk_rails_0a75dde822; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY allocations
    ADD CONSTRAINT fk_rails_0a75dde822 FOREIGN KEY (portfolio_id) REFERENCES portfolios(id) ON DELETE RESTRICT;


--
-- Name: fk_rails_403df16721; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY funds
    ADD CONSTRAINT fk_rails_403df16721 FOREIGN KEY (asset_class_id) REFERENCES asset_classes(id) ON DELETE RESTRICT;


--
-- Name: fk_rails_c50121b9d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY allocations
    ADD CONSTRAINT fk_rails_c50121b9d5 FOREIGN KEY (asset_class_id) REFERENCES asset_classes(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

