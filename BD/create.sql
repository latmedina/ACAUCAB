--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-26 02:13:34

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

--
-- Name: asignar_privilegio_a_rol(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.asignar_privilegio_a_rol(p_id_privilegio integer, p_id_rol integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO rol_privilegio (fk_privilegio, fk_rol)
    VALUES (p_id_privilegio, p_id_rol)
    ON CONFLICT DO NOTHING;
END;
$$;


--
-- Name: asignar_rol_a_usuario(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.asignar_rol_a_usuario(p_id_usuario integer, p_id_rol integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE usuario
    SET fk_rol = p_id_rol
    WHERE id = p_id_usuario;
END;
$$;


--
-- Name: crear_privilegio(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.crear_privilegio(p_nombre character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO privilegio (privilegio_nombre) VALUES (p_nombre);
END;
$$;


--
-- Name: crear_rol(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.crear_rol(p_nombre character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO rol (rol_nombre) VALUES (p_nombre);
END;
$$;


--
-- Name: eliminar_privilegio(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.eliminar_privilegio(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM privilegio
    WHERE privilegio_id = p_id;
END;
$$;


--
-- Name: eliminar_rol(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.eliminar_rol(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM rol
    WHERE rol_id = p_id;
END;
$$;


--
-- Name: eliminar_usuario(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.eliminar_usuario(p_id_usuario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE usuario
    SET is_active = FALSE
    WHERE id = p_id_usuario;
END;
$$;


--
-- Name: fn_descuento_inventario_venta_fisica(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_descuento_inventario_venta_fisica() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad_disponible INTEGER;
    v_producto_nombre VARCHAR(255);
BEGIN
    -- Validar que la cantidad a vender sea positiva
    IF NEW.det_ven_fis_cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad vendida debe ser mayor a cero. Cantidad recibida: %', NEW.det_ven_fis_cantidad;
    END IF;

    -- Obtener la cantidad disponible actual en inventario
    SELECT inv_cantidad 
    INTO v_cantidad_disponible
    FROM inventario 
    WHERE inv_id = NEW.fk_inventario;
    
    -- Verificar que el inventario existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró el inventario con ID: %', NEW.fk_inventario;
    END IF;
    
    -- Obtener nombre del producto para mensajes más descriptivos
    SELECT p.prese_nombre
    INTO v_producto_nombre
    FROM inventario i
    INNER JOIN presentacion p ON i.fk_presentacion = p.prese_id
    WHERE i.inv_id = NEW.fk_inventario;
    
    -- Verificar que hay suficiente inventario disponible
    IF v_cantidad_disponible < NEW.det_ven_fis_cantidad THEN
        RAISE EXCEPTION 'Inventario insuficiente para el producto "%" (ID: %). Disponible: %, Solicitado: %', 
            COALESCE(v_producto_nombre, 'Producto'), 
            NEW.fk_inventario, 
            v_cantidad_disponible, 
            NEW.det_ven_fis_cantidad;
    END IF;
    
    -- Descontar la cantidad vendida del inventario
    UPDATE inventario 
    SET inv_cantidad = inv_cantidad - NEW.det_ven_fis_cantidad
    WHERE inv_id = NEW.fk_inventario;
    
    -- Verificar que el update fue exitoso
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Error al actualizar el inventario con ID: %', NEW.fk_inventario;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: modificar_privilegio(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.modificar_privilegio(p_id integer, p_nuevo_nombre character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE privilegio
    SET privilegio_nombre = p_nuevo_nombre
    WHERE privilegio_id = p_id;
END;
$$;


--
-- Name: modificar_rol(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.modificar_rol(p_id integer, p_nuevo_nombre character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE rol
    SET rol_nombre = p_nuevo_nombre
    WHERE rol_id = p_id;
END;
$$;


--
-- Name: modificar_usuario(integer, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.modificar_usuario(p_id_usuario integer, p_username text, p_email text, p_password text, p_first_name text, p_last_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE usuario
    SET 
        username = p_username,
        email = p_email,
        first_name = p_first_name,
        last_name = p_last_name,
        password = CASE 
            WHEN p_password IS NOT NULL AND p_password != '' 
            THEN p_password
            ELSE password
        END
    WHERE id = p_id_usuario;
END;
$$;


--
-- Name: obtener_datos_orden_compra(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.obtener_datos_orden_compra(p_solicitud_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    SELECT
        json_build_object(
            'orden_info', json_build_object(
                'id', sc.sol_com_id,
                'fecha', TO_CHAR(sc.sol_com_fecha, 'DD/MM/YYYY')
            ),
            'proveedor_info', json_build_object(
                'nombre', COALESCE(p.pro_razon_social, 'N/A'),
                'telefono', (SELECT tel_numero::text FROM public.telefono WHERE fk_proveedor = p.pro_id LIMIT 1),
                'direccion', COALESCE(p.pro_direccion_fiscal, 'N/A')
            ),
            'enviar_a_info', json_build_object(
                'local', COALESCE(t.tie_nombre, 'Almacén Principal'),
                'telefono', '0412-1234567', -- Teléfono de la empresa (puede ser dinámico si lo tienes en la tabla tienda)
                'direccion', COALESCE(t.tie_direccion, 'Dirección de la empresa')
            ),
            'detalles', (
                SELECT COALESCE(json_agg(
                    json_build_object(
                        'id', pr.prese_id,
                        'producto', pr.prese_nombre,
                        'cantidad', dc.det_com_cantidad,
                        'precio_unitario', dc.det_com_precio_unitario,
                        'total_linea', dc.det_com_cantidad * dc.det_com_precio_unitario
                    )
                ), '[]'::json)
                FROM public.detalle_compra dc
                JOIN public.presentacion pr ON dc.fk_presentacion = pr.prese_id
                WHERE dc.fk_sol_com = sc.sol_com_id
            ),
            'totales', json_build_object(
                'subtotal', sc.sol_com_total / 1.16,
                'impuestos', sc.sol_com_total - (sc.sol_com_total / 1.16),
                'total', sc.sol_com_total
            )
        )
    INTO v_reporte_data
    FROM public.solicitud_compra sc
    LEFT JOIN public.proveedor p ON sc.fk_proveedor = p.pro_id
    LEFT JOIN public.pre_alm pa ON sc.fk_pre_alm = pa.pre_alm_id
    LEFT JOIN public.almacen a ON pa.fk_almacen = a.alm_id
    LEFT JOIN public.tienda t ON a.fk_tienda = t.tie_id
    WHERE sc.sol_com_id = p_solicitud_id;

    RETURN v_reporte_data;
END;
$$;


--
-- Name: obtener_datos_productores_eventos(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.obtener_datos_productores_eventos() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    SELECT
        -- json_agg agrupa todas las filas de eventos en un solo array JSON
        COALESCE(json_agg(
            json_build_object(
                'evento_nombre', e.eve_nombre,
                'evento_fecha', TO_CHAR(e.eve_fecha_hora, 'DD/MM/YYYY'),
                'evento_lugar', l.lug_nombre,
                -- Subconsulta para obtener los proveedores de cada evento
                'proveedores', (
                    SELECT COALESCE(json_agg(
                        json_build_object(
                            'proveedor_nombre', p.pro_razon_social,
                            -- Subconsulta para obtener las cervezas de cada proveedor en este evento
                            'cervezas_presentadas', (
                                SELECT COALESCE(json_agg(
                                    json_build_object(
                                        'cerveza_nombre', pr.prese_nombre,
                                        'cantidad', ee.exi_eve_cantidad
                                    )
                                ), '[]'::json)
                                FROM public.existencia_evento ee
                                JOIN public.presentacion pr ON ee.fk_presentacion = pr.prese_id
                                -- CORRECCIÓN FINAL: Se une la existencia directamente con la tabla
                                -- de relación evento-proveedor usando la clave foránea correcta.
                                WHERE ee.fk_evento_proveedor = ep.eve_pro_id
                            )
                        )
                    ), '[]'::json)
                    FROM public.eve_pro ep
                    JOIN public.proveedor p ON ep.fk_proveedor = p.pro_id
                    WHERE ep.fk_evento = e.eve_id
                )
            )
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.evento e
    LEFT JOIN public.lugar l ON e.fk_lugar = l.lug_id;

    RETURN v_reporte_data;
END;
$$;


--
-- Name: obtener_datos_reporte_venta(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.obtener_datos_reporte_venta(p_venta_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    SELECT
        -- Construye el objeto JSON principal
        json_build_object(
            -- Sección 'venta': contiene datos generales y totales de la factura
            'venta', json_build_object(
                'id', vf.ven_fis_id,
                'fecha', TO_CHAR(vf.ven_fis_fecha, 'DD/MM/YYYY'),
                'subtotal', vf.ven_fis_total / 1.16, -- Calcula la base imponible (asumiendo IVA 16%)
                'iva', vf.ven_fis_total - (vf.ven_fis_total / 1.16), -- Calcula el monto del IVA
                'total', vf.ven_fis_total
            ),
            -- Sección 'cliente': información del cliente que realizó la compra
            'cliente', json_build_object(
                'nombre', COALESCE(c.cli_nat_pnombre || ' ' || c.cli_nat_papellido, c.cli_jur_razon_social, 'No disponible'),
                'rif', COALESCE(c.cli_rif, 'N/A'),
                'direccion', COALESCE(c.cli_direccion_fisica, 'N/A'),
                'telefono', (SELECT tel_numero::text FROM public.telefono WHERE fk_cliente = c.cli_id LIMIT 1) -- Subconsulta para obtener un teléfono
            ),
            -- Sección 'tienda': datos de la tienda donde se realizó la venta
            'tienda', json_build_object(
                'nombre', COALESCE(t.tie_nombre, 'No disponible'),
                'direccion', COALESCE(t.tie_direccion, 'N/A')
            ),
            -- Sección 'detalles': una lista (array) de todos los productos en la venta
            'detalles', (
                SELECT COALESCE(json_agg(
                    json_build_object(
                        'id', p.prese_id, -- ID del producto/presentación
                        'producto', p.prese_nombre,
                        'cantidad', dvf.det_ven_fis_cantidad,
                        'precio_unitario', dvf.det_ven_fis_precio_unitario,
                        'total_linea', dvf.det_ven_fis_cantidad * dvf.det_ven_fis_precio_unitario
                    )
                ), '[]'::json) -- Si no hay detalles, devuelve un array JSON vacío
                FROM public.detalle_venta_fisica dvf
                JOIN public.inventario i ON dvf.fk_inventario = i.inv_id
                JOIN public.presentacion p ON i.fk_presentacion = p.prese_id
                WHERE dvf.fk_venta_fisica = vf.ven_fis_id
            )
        )
    INTO v_reporte_data
    FROM public.venta_fisica vf
    -- Usamos LEFT JOIN para ser más robustos
    LEFT JOIN public.cliente c ON vf.fk_cliente = c.cli_id
    LEFT JOIN public.tienda t ON vf.fk_tienda = t.tie_id
    WHERE vf.ven_fis_id = p_venta_id;

    RETURN v_reporte_data;
END;
$$;


--
-- Name: quitar_privilegio_de_rol(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.quitar_privilegio_de_rol(p_id_privilegio integer, p_id_rol integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM rol_privilegio
    WHERE fk_privilegio = p_id_privilegio AND fk_rol = p_id_rol;
END;
$$;


--
-- Name: registrar_usuario(text, text, text, text, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.registrar_usuario(p_username text, p_email text, p_password text, p_tipo text, p_id_entidad integer, p_emp_car_id integer, p_first_name text, p_last_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO usuario (
        username,
        email,
        password,
        is_active,
        is_staff,
        is_superuser,
        date_joined,
        fk_cliente,
        fk_proveedor,
        fk_emp_car,
        first_name,
        last_name
    )
    VALUES (
        p_username,
        p_email,
        p_password,
        TRUE, FALSE, FALSE, NOW(),
        CASE WHEN p_tipo = 'cliente' THEN p_id_entidad ELSE NULL END,
        CASE WHEN p_tipo = 'proveedor' THEN p_id_entidad ELSE NULL END,
        CASE WHEN p_tipo = 'empleado' THEN p_emp_car_id ELSE NULL END,
        p_first_name,
        p_last_name
    );
END;
$$;


--
-- Name: registrar_venta_fisica(integer, integer, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.registrar_venta_fisica(cliente_id integer, tienda_id integer, total numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    nueva_venta_id INTEGER;
BEGIN
    INSERT INTO venta_fisica (ven_fis_fecha, ven_fis_total, fk_cliente, fk_tienda)
    VALUES (CURRENT_DATE, total, cliente_id, tienda_id)
    RETURNING ven_fis_id INTO nueva_venta_id;

    RETURN nueva_venta_id;
END;
$$;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 22664)
-- Name: admin_interface_theme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_interface_theme (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    active boolean NOT NULL,
    title character varying(50) NOT NULL,
    title_color character varying(10) NOT NULL,
    title_visible boolean NOT NULL,
    logo character varying(100) NOT NULL,
    logo_color character varying(10) NOT NULL,
    logo_max_width smallint NOT NULL,
    logo_max_height smallint NOT NULL,
    logo_visible boolean NOT NULL,
    favicon character varying(100) NOT NULL,
    env_name character varying(50) NOT NULL,
    env_color character varying(10) NOT NULL,
    env_visible_in_header boolean NOT NULL,
    env_visible_in_favicon boolean NOT NULL,
    language_chooser_active boolean NOT NULL,
    language_chooser_control character varying(20) NOT NULL,
    language_chooser_display character varying(10) NOT NULL,
    css_header_background_color character varying(10) NOT NULL,
    css_header_text_color character varying(10) NOT NULL,
    css_header_link_color character varying(10) NOT NULL,
    css_header_link_hover_color character varying(10) NOT NULL,
    css_module_background_color character varying(10) NOT NULL,
    css_module_background_selected_color character varying(10) NOT NULL,
    css_module_text_color character varying(10) NOT NULL,
    css_module_link_color character varying(10) NOT NULL,
    css_module_link_selected_color character varying(10) NOT NULL,
    css_module_link_hover_color character varying(10) NOT NULL,
    css_module_rounded_corners boolean NOT NULL,
    css_generic_link_color character varying(10) NOT NULL,
    css_generic_link_hover_color character varying(10) NOT NULL,
    css_generic_link_active_color character varying(10) NOT NULL,
    css_save_button_background_color character varying(10) NOT NULL,
    css_save_button_background_hover_color character varying(10) NOT NULL,
    css_save_button_text_color character varying(10) NOT NULL,
    css_delete_button_background_color character varying(10) NOT NULL,
    css_delete_button_background_hover_color character varying(10) NOT NULL,
    css_delete_button_text_color character varying(10) NOT NULL,
    related_modal_active boolean NOT NULL,
    related_modal_background_color character varying(10) NOT NULL,
    related_modal_background_opacity character varying(5) NOT NULL,
    related_modal_rounded_corners boolean NOT NULL,
    related_modal_close_button_visible boolean NOT NULL,
    list_filter_highlight boolean NOT NULL,
    list_filter_dropdown boolean NOT NULL,
    list_filter_sticky boolean NOT NULL,
    list_filter_removal_links boolean NOT NULL,
    foldable_apps boolean NOT NULL,
    show_fieldsets_as_tabs boolean NOT NULL,
    show_inlines_as_tabs boolean NOT NULL,
    collapsible_stacked_inlines boolean NOT NULL,
    collapsible_stacked_inlines_collapsed boolean NOT NULL,
    collapsible_tabular_inlines boolean NOT NULL,
    collapsible_tabular_inlines_collapsed boolean NOT NULL,
    recent_actions_visible boolean NOT NULL,
    form_submit_sticky boolean NOT NULL,
    form_pagination_sticky boolean NOT NULL,
    CONSTRAINT admin_interface_theme_logo_max_height_check CHECK ((logo_max_height >= 0)),
    CONSTRAINT admin_interface_theme_logo_max_width_check CHECK ((logo_max_width >= 0))
);


ALTER TABLE public.admin_interface_theme OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 22671)
-- Name: admin_interface_theme_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.admin_interface_theme ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.admin_interface_theme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 22672)
-- Name: afi_est; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.afi_est (
    afi_est_id integer NOT NULL,
    afi_est_fecha_inicio date NOT NULL,
    afi_est_fecha_fin date,
    fk_afiliacion integer NOT NULL,
    fk_estatus integer NOT NULL
);


ALTER TABLE public.afi_est OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 22675)
-- Name: afi_est_afi_est_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.afi_est ALTER COLUMN afi_est_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.afi_est_afi_est_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 22676)
-- Name: afiliacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.afiliacion (
    afi_id integer NOT NULL,
    afi_nombre character varying(50) NOT NULL,
    afi_monto integer NOT NULL,
    fk_proveedor integer NOT NULL,
    fk_tienda integer NOT NULL
);


ALTER TABLE public.afiliacion OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 22679)
-- Name: afiliacion_afi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.afiliacion ALTER COLUMN afi_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.afiliacion_afi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 22680)
-- Name: almacen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.almacen (
    alm_id integer NOT NULL,
    alm_nombre character varying(100) NOT NULL,
    alm_descripcion text NOT NULL,
    fk_tienda integer NOT NULL
);


ALTER TABLE public.almacen OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 22685)
-- Name: almacen_alm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.almacen ALTER COLUMN alm_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.almacen_alm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 22686)
-- Name: anaquel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.anaquel (
    ana_id integer NOT NULL,
    ana_numero integer NOT NULL,
    fk_lugar_tienda integer NOT NULL
);


ALTER TABLE public.anaquel OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 22689)
-- Name: anaquel_ana_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.anaquel ALTER COLUMN ana_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.anaquel_ana_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 22690)
-- Name: asistencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asistencia (
    asi_id integer NOT NULL,
    asi_fecha_hora_inico timestamp with time zone NOT NULL,
    asi_fecha_hora_fin timestamp with time zone,
    fk_empleado integer NOT NULL
);


ALTER TABLE public.asistencia OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 22693)
-- Name: asistencia_asi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.asistencia ALTER COLUMN asi_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.asistencia_asi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 22694)
-- Name: asistencia_evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asistencia_evento (
    asi_eve_id integer NOT NULL,
    asi_eve_fecha_hora timestamp with time zone NOT NULL,
    fk_cliente integer NOT NULL,
    fk_evento integer NOT NULL,
    fk_ven_bol_eve integer NOT NULL
);


ALTER TABLE public.asistencia_evento OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 22697)
-- Name: asistencia_evento_asi_eve_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.asistencia_evento ALTER COLUMN asi_eve_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.asistencia_evento_asi_eve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 22698)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 22701)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 22702)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 22705)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 22706)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 22709)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 22710)
-- Name: car_tip_cer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_tip_cer (
    id bigint NOT NULL,
    carac_tip_cer_valor character varying(255) NOT NULL,
    fk_caracteristica integer NOT NULL,
    fk_tipo_cerveza integer NOT NULL
);


ALTER TABLE public.car_tip_cer OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 22713)
-- Name: car_tip_cer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.car_tip_cer ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.car_tip_cer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 22714)
-- Name: caracteristica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caracteristica (
    car_id integer NOT NULL,
    car_nombre character varying(255) NOT NULL,
    car_descripcion character varying(255) NOT NULL
);


ALTER TABLE public.caracteristica OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 22719)
-- Name: caracteristica_car_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.caracteristica ALTER COLUMN car_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.caracteristica_car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 241 (class 1259 OID 22720)
-- Name: cargo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cargo (
    car_id integer NOT NULL,
    car_nombre character varying(100) NOT NULL,
    car_descripcion text NOT NULL,
    car_salario integer NOT NULL
);


ALTER TABLE public.cargo OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 22725)
-- Name: cargo_car_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cargo ALTER COLUMN car_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.cargo_car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 22726)
-- Name: cerv_car; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cerv_car (
    id bigint NOT NULL,
    carac_cer_valor character varying(255) NOT NULL,
    fk_caracteristica integer NOT NULL,
    fk_cerveza integer NOT NULL
);


ALTER TABLE public.cerv_car OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 22729)
-- Name: cerv_car_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cerv_car ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.cerv_car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 245 (class 1259 OID 22730)
-- Name: cerveza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cerveza (
    cer_id integer NOT NULL,
    cer_nombre character varying(255) NOT NULL,
    cer_descripcion character varying(255) NOT NULL,
    cer_grado_alcohol numeric(5,2) NOT NULL,
    fk_tipo_estilo_cerveza integer NOT NULL
);


ALTER TABLE public.cerveza OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 22735)
-- Name: cerveza_cer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cerveza ALTER COLUMN cer_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.cerveza_cer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 247 (class 1259 OID 22736)
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    cli_id integer NOT NULL,
    cli_rif character varying(12) NOT NULL,
    cli_direccion_fisica character varying(255) NOT NULL,
    cli_tipo_cliente character varying(10) NOT NULL,
    cli_nat_ci character varying(12),
    cli_nat_pnombre character varying(50),
    cli_nat_snombre character varying(50),
    cli_nat_papellido character varying(50),
    cli_nat_sapellido character varying(50),
    cli_nat_sexo character varying(1),
    cli_jur_denom_comercial character varying(70),
    cli_jur_razon_social character varying(70),
    cli_jur_url_web character varying(255),
    cli_jur_capital integer,
    cli_jur_dir_fiscal character varying(255),
    cli_cantidad_puntos integer,
    fk_lugar integer NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 22741)
-- Name: cliente_cli_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cliente ALTER COLUMN cli_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.cliente_cli_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 249 (class 1259 OID 22742)
-- Name: contacto_cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contacto_cliente (
    con_cli_id integer NOT NULL,
    con_cli_nombre character varying(50) NOT NULL,
    con_cli_apellido character varying(50) NOT NULL,
    fk_cliente integer NOT NULL
);


ALTER TABLE public.contacto_cliente OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 22745)
-- Name: contacto_cliente_con_cli_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.contacto_cliente ALTER COLUMN con_cli_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contacto_cliente_con_cli_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 251 (class 1259 OID 22746)
-- Name: contacto_proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contacto_proveedor (
    con_pro_id integer NOT NULL,
    con_pro_nombre character varying(50) NOT NULL,
    con_pro_apellido character varying(50) NOT NULL,
    fk_proveedor integer NOT NULL
);


ALTER TABLE public.contacto_proveedor OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 22749)
-- Name: contacto_proveedor_con_pro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.contacto_proveedor ALTER COLUMN con_pro_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contacto_proveedor_con_pro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 253 (class 1259 OID 22750)
-- Name: correo_electronico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.correo_electronico (
    cor_ele_id integer NOT NULL,
    cor_ele_direccion character varying(70) NOT NULL,
    fk_cliente integer,
    fk_contacto_cliente integer,
    fk_contacto_proveedor integer,
    fk_empleado integer,
    fk_proveedor integer
);


ALTER TABLE public.correo_electronico OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 22753)
-- Name: correo_electronico_cor_ele_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.correo_electronico ALTER COLUMN cor_ele_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.correo_electronico_cor_ele_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 255 (class 1259 OID 22754)
-- Name: cuenta_punto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuenta_punto (
    cue_pun_id integer NOT NULL,
    cue_pun_cantidad numeric(12,2) NOT NULL,
    fk_venta_fisica integer NOT NULL,
    fk_cliente integer NOT NULL
);


ALTER TABLE public.cuenta_punto OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 22757)
-- Name: cuenta_punto_cue_pun_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cuenta_punto ALTER COLUMN cue_pun_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.cuenta_punto_cue_pun_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 257 (class 1259 OID 22758)
-- Name: dep_tie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dep_tie (
    id bigint NOT NULL,
    dep_tie_fecha_inicio date NOT NULL,
    dep_tie_fecha_fin date,
    fk_departamento integer NOT NULL,
    fk_tienda integer NOT NULL
);


ALTER TABLE public.dep_tie OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 22761)
-- Name: dep_tie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dep_tie ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.dep_tie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 259 (class 1259 OID 22762)
-- Name: departamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departamento (
    dep_id integer NOT NULL,
    dep_nombre character varying(100) NOT NULL,
    dep_descripcion text NOT NULL
);


ALTER TABLE public.departamento OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 22767)
-- Name: departamento_dep_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.departamento ALTER COLUMN dep_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.departamento_dep_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 261 (class 1259 OID 22768)
-- Name: detalle_compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_compra (
    det_com_id integer NOT NULL,
    det_com_cantidad integer NOT NULL,
    det_com_precio_unitario numeric(10,2) NOT NULL,
    fk_presentacion integer NOT NULL,
    fk_sol_com integer NOT NULL
);


ALTER TABLE public.detalle_compra OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 22771)
-- Name: detalle_compra_det_com_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.detalle_compra ALTER COLUMN det_com_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.detalle_compra_det_com_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 263 (class 1259 OID 22772)
-- Name: detalle_venta_evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_venta_evento (
    det_ven_eve_id integer NOT NULL,
    det_ven_eve_cantidad integer NOT NULL,
    det_ven_eve_precio_unitario numeric(10,2) NOT NULL,
    fk_exi_eve integer NOT NULL,
    fk_venta_evento integer NOT NULL
);


ALTER TABLE public.detalle_venta_evento OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 22775)
-- Name: detalle_venta_evento_det_ven_eve_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.detalle_venta_evento ALTER COLUMN det_ven_eve_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.detalle_venta_evento_det_ven_eve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 265 (class 1259 OID 22776)
-- Name: detalle_venta_fisica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_venta_fisica (
    det_ven_fis_id integer NOT NULL,
    det_ven_fis_cantidad integer NOT NULL,
    det_ven_fis_precio_unitario numeric(10,2) NOT NULL,
    fk_inventario integer NOT NULL,
    fk_venta_fisica integer NOT NULL
);


ALTER TABLE public.detalle_venta_fisica OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 22779)
-- Name: detalle_venta_fisica_det_ven_fis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.detalle_venta_fisica ALTER COLUMN det_ven_fis_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.detalle_venta_fisica_det_ven_fis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 267 (class 1259 OID 22780)
-- Name: detalle_venta_online; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_venta_online (
    det_ven_onl_id integer NOT NULL,
    det_ven_onl_cantidad integer NOT NULL,
    det_ven_onl_precio numeric(10,2) NOT NULL,
    fk_pre_alm integer NOT NULL,
    fk_venta_online integer NOT NULL
);


ALTER TABLE public.detalle_venta_online OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 22783)
-- Name: detalle_venta_online_det_ven_onl_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.detalle_venta_online ALTER COLUMN det_ven_onl_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.detalle_venta_online_det_ven_onl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 269 (class 1259 OID 22784)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id bigint NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 22790)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 271 (class 1259 OID 22791)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 22794)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 273 (class 1259 OID 22795)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 22800)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 275 (class 1259 OID 22801)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 22806)
-- Name: emp_car; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_car (
    id integer NOT NULL,
    fk_departamento integer NOT NULL,
    fk_tienda integer NOT NULL,
    emp_car_fecha_inicio date NOT NULL,
    emp_car_fecha_fin date,
    fk_cargo integer NOT NULL,
    fk_empleado integer NOT NULL
);


ALTER TABLE public.emp_car OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 22809)
-- Name: emp_car_hor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_car_hor (
    id bigint NOT NULL,
    fk_cargo integer NOT NULL,
    fk_departamento integer NOT NULL,
    fk_empleado integer NOT NULL,
    fk_horario integer NOT NULL,
    fk_tienda integer NOT NULL
);


ALTER TABLE public.emp_car_hor OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 22812)
-- Name: emp_car_hor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.emp_car_hor ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.emp_car_hor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 279 (class 1259 OID 22813)
-- Name: emp_car_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.emp_car ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.emp_car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 280 (class 1259 OID 22814)
-- Name: emp_tip_ben; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_tip_ben (
    id bigint NOT NULL,
    emp_tip_ben_monto integer NOT NULL,
    fk_empleado integer NOT NULL,
    fk_tipo_beneficio integer NOT NULL
);


ALTER TABLE public.emp_tip_ben OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 22817)
-- Name: emp_tip_ben_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.emp_tip_ben ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.emp_tip_ben_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 282 (class 1259 OID 22818)
-- Name: empleado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleado (
    emp_id integer NOT NULL,
    emp_ci character varying(12) NOT NULL,
    emp_pnombre character varying(30) NOT NULL,
    emp_snombre character varying(30),
    emp_papellido character varying(30) NOT NULL,
    emp_sapellido character varying(30),
    emp_direccion character varying(70) NOT NULL,
    emp_fecha_nacimiento date NOT NULL,
    emp_sexo character varying(1) NOT NULL,
    fk_lugar integer NOT NULL
);


ALTER TABLE public.empleado OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 22821)
-- Name: empleado_emp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.empleado ALTER COLUMN emp_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.empleado_emp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 284 (class 1259 OID 22822)
-- Name: estatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estatus (
    est_id integer NOT NULL,
    est_tipo_estatus character varying(50) NOT NULL,
    est_descripcion character varying(255) NOT NULL
);


ALTER TABLE public.estatus OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 22825)
-- Name: estatus_est_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.estatus ALTER COLUMN est_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.estatus_est_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 286 (class 1259 OID 22826)
-- Name: estilo_cerveza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estilo_cerveza (
    est_cer_id integer NOT NULL,
    est_cer_nombre character varying(255) NOT NULL,
    est_cer_descripcion character varying(255) NOT NULL
);


ALTER TABLE public.estilo_cerveza OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 22831)
-- Name: estilo_cerveza_est_cer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.estilo_cerveza ALTER COLUMN est_cer_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.estilo_cerveza_est_cer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 288 (class 1259 OID 22832)
-- Name: eve_pro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eve_pro (
    eve_pro_id integer NOT NULL,
    fk_evento integer NOT NULL,
    fk_proveedor integer NOT NULL
);


ALTER TABLE public.eve_pro OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 22835)
-- Name: eve_pro_eve_pro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.eve_pro ALTER COLUMN eve_pro_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.eve_pro_eve_pro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 290 (class 1259 OID 22836)
-- Name: evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evento (
    eve_id integer NOT NULL,
    eve_nombre character varying(255) NOT NULL,
    eve_descripcion character varying(255) NOT NULL,
    eve_fecha_hora timestamp with time zone NOT NULL,
    eve_nro_boletos integer NOT NULL,
    fk_lugar integer NOT NULL,
    fk_tip_eve integer NOT NULL
);


ALTER TABLE public.evento OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 22841)
-- Name: evento_eve_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.evento ALTER COLUMN eve_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.evento_eve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 292 (class 1259 OID 22842)
-- Name: existencia_evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.existencia_evento (
    exi_eve_id integer NOT NULL,
    exi_eve_cantidad integer NOT NULL,
    fk_evento_proveedor integer NOT NULL,
    fk_presentacion integer NOT NULL
);


ALTER TABLE public.existencia_evento OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 22845)
-- Name: existencia_evento_exi_eve_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.existencia_evento ALTER COLUMN exi_eve_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.existencia_evento_exi_eve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 294 (class 1259 OID 22846)
-- Name: historico_moneda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historico_moneda (
    his_mon_id integer NOT NULL,
    his_mon_fecha_hora timestamp with time zone NOT NULL,
    his_valor_cambio numeric(12,2) NOT NULL,
    fk_moneda integer NOT NULL
);


ALTER TABLE public.historico_moneda OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 22849)
-- Name: historico_moneda_his_mon_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.historico_moneda ALTER COLUMN his_mon_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.historico_moneda_his_mon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 296 (class 1259 OID 22850)
-- Name: historico_precio_punto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historico_precio_punto (
    his_pre_pun_id integer NOT NULL,
    his_pre_pun_fecha_hora timestamp with time zone NOT NULL,
    his_pre_pun_valor integer NOT NULL
);


ALTER TABLE public.historico_precio_punto OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 22853)
-- Name: historico_precio_punto_his_pre_pun_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.historico_precio_punto ALTER COLUMN his_pre_pun_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.historico_precio_punto_his_pre_pun_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 298 (class 1259 OID 22854)
-- Name: horario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.horario (
    hor_id integer NOT NULL,
    hor_dia character varying(10) NOT NULL,
    hor_hora_inicio time without time zone NOT NULL,
    hor_hora_fin time without time zone NOT NULL
);


ALTER TABLE public.horario OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 22857)
-- Name: horario_hor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.horario ALTER COLUMN hor_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.horario_hor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 300 (class 1259 OID 22858)
-- Name: ingrediente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingrediente (
    ing_id integer NOT NULL,
    ing_nombre character varying(255) NOT NULL,
    ing_descripcion character varying(255) NOT NULL
);


ALTER TABLE public.ingrediente OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 22863)
-- Name: ingrediente_ing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ingrediente ALTER COLUMN ing_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ingrediente_ing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 302 (class 1259 OID 22864)
-- Name: instruccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instruccion (
    ins_id integer NOT NULL,
    ins_descripcion character varying(1000) NOT NULL
);


ALTER TABLE public.instruccion OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 22869)
-- Name: instruccion_ins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instruccion ALTER COLUMN ins_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.instruccion_ins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 304 (class 1259 OID 22870)
-- Name: inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario (
    inv_id integer NOT NULL,
    inv_cantidad integer NOT NULL,
    inv_precio_unitario numeric(10,2) NOT NULL,
    fk_anaquel integer NOT NULL,
    fk_oferta integer,
    fk_presentacion integer NOT NULL
);


ALTER TABLE public.inventario OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 22873)
-- Name: inventario_inv_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.inventario ALTER COLUMN inv_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventario_inv_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 306 (class 1259 OID 22874)
-- Name: lugar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lugar (
    lug_id integer NOT NULL,
    lug_nombre character varying(90) NOT NULL,
    lug_tipo character varying(20),
    fk_lugar integer
);


ALTER TABLE public.lugar OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 22877)
-- Name: lugar_lug_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lugar ALTER COLUMN lug_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.lugar_lug_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 308 (class 1259 OID 22878)
-- Name: lugar_tienda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lugar_tienda (
    lug_tie_id integer NOT NULL,
    lug_tie_nombre character varying(255) NOT NULL,
    lug_tie_tipo character varying(255) NOT NULL,
    fk_lugar_tienda integer,
    fk_tienda integer NOT NULL
);


ALTER TABLE public.lugar_tienda OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 22883)
-- Name: lugar_tienda_lug_tie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lugar_tienda ALTER COLUMN lug_tie_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.lugar_tienda_lug_tie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 310 (class 1259 OID 22884)
-- Name: metodo_pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metodo_pago (
    met_pag_id integer NOT NULL,
    efe_denominacion integer,
    che_num_cheque character varying(50),
    tar_deb_numero bigint,
    tar_deb_vencimiento date,
    tar_deb_banco character varying(50),
    tar_cre_numero bigint,
    tar_cre_vencimiento date,
    pun_cantidad integer,
    met_pag_tipo_pago character varying(50) NOT NULL,
    fk_usuario integer NOT NULL,
    fk_his_pre_pun integer
);


ALTER TABLE public.metodo_pago OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 22887)
-- Name: metodo_pago_met_pag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.metodo_pago ALTER COLUMN met_pag_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.metodo_pago_met_pag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 312 (class 1259 OID 22888)
-- Name: moneda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moneda (
    mon_id integer NOT NULL,
    mon_tipo character varying(50) NOT NULL
);


ALTER TABLE public.moneda OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 22891)
-- Name: moneda_mon_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.moneda ALTER COLUMN mon_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.moneda_mon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 314 (class 1259 OID 22892)
-- Name: oferta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oferta (
    ofe_id integer NOT NULL,
    ofe_nombre character varying(100) NOT NULL,
    ofe_descripcion text NOT NULL,
    ofe_fecha_inicio date NOT NULL,
    ofe_fecha_fin date,
    of_procentaje integer NOT NULL
);


ALTER TABLE public.oferta OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 22897)
-- Name: oferta_ofe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.oferta ALTER COLUMN ofe_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.oferta_ofe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 316 (class 1259 OID 22898)
-- Name: pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pago (
    pag_id integer NOT NULL,
    pag_monto numeric(12,2) NOT NULL,
    pag_fecha timestamp with time zone NOT NULL,
    fk_afiliacion integer,
    fk_metodo_pago integer NOT NULL,
    fk_moneda integer NOT NULL,
    fk_venta_evento integer,
    fk_venta_fisica integer,
    fk_venta_online integer
);


ALTER TABLE public.pago OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 22901)
-- Name: pago_efectivo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pago_efectivo (
    pag_efe_id integer NOT NULL,
    pag_efe_monto numeric(10,2) NOT NULL,
    pag_efe_fecha timestamp with time zone NOT NULL,
    fk_sol_com integer NOT NULL,
    fk_metodo_pago integer NOT NULL
);


ALTER TABLE public.pago_efectivo OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 22904)
-- Name: pago_efectivo_pag_efe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pago_efectivo ALTER COLUMN pag_efe_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.pago_efectivo_pag_efe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 319 (class 1259 OID 22905)
-- Name: pago_pag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pago ALTER COLUMN pag_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.pago_pag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 320 (class 1259 OID 22906)
-- Name: pre_alm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pre_alm (
    pre_alm_id integer NOT NULL,
    pre_alm_precio numeric(10,2) NOT NULL,
    pre_alm_cantidad integer NOT NULL,
    fk_almacen integer NOT NULL,
    fk_oferta integer,
    fk_presentacion integer NOT NULL
);


ALTER TABLE public.pre_alm OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 22909)
-- Name: pre_alm_pre_alm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pre_alm ALTER COLUMN pre_alm_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.pre_alm_pre_alm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 322 (class 1259 OID 22910)
-- Name: presentacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.presentacion (
    prese_id integer NOT NULL,
    prese_nombre character varying(100) NOT NULL,
    prese_volumen numeric(10,2) NOT NULL,
    prese_recipiente character varying(255) NOT NULL,
    prese_imagen character varying(100),
    prese_precio numeric(10,2) NOT NULL,
    prese_alto numeric(10,2),
    prese_ancho numeric(10,2),
    fk_cerveza integer
);


ALTER TABLE public.presentacion OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 22913)
-- Name: presentacion_prese_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.presentacion ALTER COLUMN prese_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.presentacion_prese_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 371 (class 1259 OID 23987)
-- Name: privilegio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.privilegio (
    privilegio_id integer NOT NULL,
    privilegio_nombre character varying(50) NOT NULL
);


ALTER TABLE public.privilegio OWNER TO postgres;

--
-- TOC entry 370 (class 1259 OID 23986)
-- Name: privilegio_privilegio_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.privilegio ALTER COLUMN privilegio_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.privilegio_privilegio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 324 (class 1259 OID 22914)
-- Name: proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedor (
    pro_id integer NOT NULL,
    pro_rif character varying(12) NOT NULL,
    pro_denominacion_comercial character varying(70),
    pro_razon_social character varying(70),
    pro_url_web character varying(255),
    pro_direccion_fiscal character varying(255),
    fk_lugar integer NOT NULL
);


ALTER TABLE public.proveedor OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 22919)
-- Name: proveedor_pro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.proveedor ALTER COLUMN pro_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.proveedor_pro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 326 (class 1259 OID 22920)
-- Name: rec_ing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rec_ing (
    rec_ing_id integer NOT NULL,
    rec_ing_cantidad numeric(10,3) NOT NULL,
    fk_ingrediente integer NOT NULL,
    fk_receta integer NOT NULL
);


ALTER TABLE public.rec_ing OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 22923)
-- Name: rec_ing_rec_ing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rec_ing ALTER COLUMN rec_ing_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rec_ing_rec_ing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 328 (class 1259 OID 22924)
-- Name: rec_ins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rec_ins (
    rec_ins_id integer NOT NULL,
    fk_instruccion integer NOT NULL,
    fk_receta integer NOT NULL
);


ALTER TABLE public.rec_ins OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 22927)
-- Name: rec_ins_rec_ins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rec_ins ALTER COLUMN rec_ins_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rec_ins_rec_ins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 330 (class 1259 OID 22928)
-- Name: receta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receta (
    rec_id integer NOT NULL,
    rec_nombre character varying(255) NOT NULL,
    rec_descripcion character varying(255) NOT NULL
);


ALTER TABLE public.receta OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 22933)
-- Name: receta_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.receta ALTER COLUMN rec_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.receta_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 373 (class 1259 OID 23995)
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol (
    rol_id integer NOT NULL,
    rol_nombre character varying(50) NOT NULL
);


ALTER TABLE public.rol OWNER TO postgres;

--
-- TOC entry 375 (class 1259 OID 24008)
-- Name: rol_privilegio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol_privilegio (
    id integer NOT NULL,
    fk_privilegio integer NOT NULL,
    fk_rol integer NOT NULL
);


ALTER TABLE public.rol_privilegio OWNER TO postgres;

--
-- TOC entry 374 (class 1259 OID 24007)
-- Name: rol_privilegio_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rol_privilegio ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rol_privilegio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 372 (class 1259 OID 23994)
-- Name: rol_rol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rol ALTER COLUMN rol_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rol_rol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 332 (class 1259 OID 22934)
-- Name: sol_com_est; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sol_com_est (
    sol_com_est_id integer NOT NULL,
    sol_com_est_fecha_inicio date NOT NULL,
    sol_com_est_fecha_fin date,
    fk_estatus integer NOT NULL,
    fk_sol_com integer NOT NULL
);


ALTER TABLE public.sol_com_est OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 22937)
-- Name: sol_com_est_sol_com_est_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sol_com_est ALTER COLUMN sol_com_est_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.sol_com_est_sol_com_est_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 334 (class 1259 OID 22938)
-- Name: sol_rep_est; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sol_rep_est (
    sol_rep_est_id integer NOT NULL,
    sol_rep_est_fecha_inicio date NOT NULL,
    sol_rep_est_fecha_fin date,
    fk_estatus integer NOT NULL,
    fk_sol_rep integer NOT NULL
);


ALTER TABLE public.sol_rep_est OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 22941)
-- Name: sol_rep_est_sol_rep_est_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sol_rep_est ALTER COLUMN sol_rep_est_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.sol_rep_est_sol_rep_est_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 336 (class 1259 OID 22942)
-- Name: solicitud_compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solicitud_compra (
    sol_com_id integer NOT NULL,
    sol_com_fecha timestamp with time zone NOT NULL,
    sol_com_total numeric(10,2) NOT NULL,
    fk_pre_alm integer NOT NULL,
    fk_proveedor integer NOT NULL,
    fk_usuario bigint
);


ALTER TABLE public.solicitud_compra OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 22945)
-- Name: solicitud_compra_sol_com_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.solicitud_compra ALTER COLUMN sol_com_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.solicitud_compra_sol_com_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 338 (class 1259 OID 22946)
-- Name: solicitud_reposicion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solicitud_reposicion (
    sol_rep_id integer NOT NULL,
    sol_rep_fecha_hora timestamp with time zone NOT NULL,
    sol_rep_descripcion character varying(255) NOT NULL,
    fk_inv integer NOT NULL,
    fk_pre_alm integer NOT NULL,
    fk_usuario bigint
);


ALTER TABLE public.solicitud_reposicion OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 22949)
-- Name: solicitud_reposicion_sol_rep_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.solicitud_reposicion ALTER COLUMN sol_rep_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.solicitud_reposicion_sol_rep_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 340 (class 1259 OID 22950)
-- Name: telefono; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telefono (
    tel_id integer NOT NULL,
    tel_codigo_area character varying(30) NOT NULL,
    tel_numero bigint NOT NULL,
    fk_cliente integer,
    fk_contacto_cliente integer,
    fk_contacto_proveedor integer,
    fk_empleado integer,
    fk_proveedor integer
);


ALTER TABLE public.telefono OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 22953)
-- Name: telefono_tel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.telefono ALTER COLUMN tel_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.telefono_tel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 342 (class 1259 OID 22954)
-- Name: tienda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tienda (
    tie_id integer NOT NULL,
    tie_nombre character varying(150) NOT NULL,
    tie_direccion character varying(255) NOT NULL,
    tie_tipo character varying(20) NOT NULL,
    fk_lugar integer NOT NULL
);


ALTER TABLE public.tienda OWNER TO postgres;

--
-- TOC entry 343 (class 1259 OID 22957)
-- Name: tienda_tie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tienda ALTER COLUMN tie_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tienda_tie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 344 (class 1259 OID 22958)
-- Name: tipo_beneficio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_beneficio (
    tip_ben_id integer NOT NULL,
    tip_ben_nombre character varying(255) NOT NULL,
    tip_ben_descripcion text NOT NULL
);


ALTER TABLE public.tipo_beneficio OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 22963)
-- Name: tipo_beneficio_tip_ben_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tipo_beneficio ALTER COLUMN tip_ben_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tipo_beneficio_tip_ben_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 346 (class 1259 OID 22964)
-- Name: tipo_cerveza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_cerveza (
    tip_cer_id integer NOT NULL,
    tip_cer_familia character varying(255) NOT NULL
);


ALTER TABLE public.tipo_cerveza OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 22967)
-- Name: tipo_cerveza_tip_cer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tipo_cerveza ALTER COLUMN tip_cer_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tipo_cerveza_tip_cer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 348 (class 1259 OID 22968)
-- Name: tipo_estilo_cerveza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_estilo_cerveza (
    tip_est_cer_id integer NOT NULL,
    tip_est_cer_nombre character varying(255) NOT NULL,
    tip_est_cer_descripcion character varying(255) NOT NULL,
    fk_estilo_cerveza integer NOT NULL,
    fk_tipo_cerveza integer NOT NULL
);


ALTER TABLE public.tipo_estilo_cerveza OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 22973)
-- Name: tipo_estilo_cerveza_tip_est_cer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tipo_estilo_cerveza ALTER COLUMN tip_est_cer_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tipo_estilo_cerveza_tip_est_cer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 350 (class 1259 OID 22974)
-- Name: tipo_evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_evento (
    tip_eve_id integer NOT NULL,
    tip_eve_nombre character varying(255) NOT NULL,
    tip_eve_descripcion character varying(255) NOT NULL,
    fk_tipo_evento integer
);


ALTER TABLE public.tipo_evento OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 22979)
-- Name: tipo_evento_tip_eve_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tipo_evento ALTER COLUMN tip_eve_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tipo_evento_tip_eve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 352 (class 1259 OID 22980)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id bigint NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    fk_cliente integer,
    fk_proveedor integer,
    fk_emp_car integer,
    fk_rol integer
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 22985)
-- Name: usuario_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_groups (
    id bigint NOT NULL,
    usuario_id bigint NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.usuario_groups OWNER TO postgres;

--
-- TOC entry 354 (class 1259 OID 22988)
-- Name: usuario_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usuario_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 355 (class 1259 OID 22989)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 356 (class 1259 OID 22990)
-- Name: usuario_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_user_permissions (
    id bigint NOT NULL,
    usuario_id bigint NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.usuario_user_permissions OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 22993)
-- Name: usuario_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usuario_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 358 (class 1259 OID 22994)
-- Name: vacacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vacacion (
    vac_id integer NOT NULL,
    vac_fecha_inicio date NOT NULL,
    vac_fecha_fin date,
    fk_empleado integer NOT NULL
);


ALTER TABLE public.vacacion OWNER TO postgres;

--
-- TOC entry 359 (class 1259 OID 22997)
-- Name: vacacion_vac_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.vacacion ALTER COLUMN vac_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.vacacion_vac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 360 (class 1259 OID 22998)
-- Name: ven_onl_est; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ven_onl_est (
    ven_onl_est_id integer NOT NULL,
    ven_onl_est_fecha_inicio date NOT NULL,
    ven_onl_est_fecha_fin date,
    fk_estatus integer NOT NULL,
    fk_venta_online integer NOT NULL
);


ALTER TABLE public.ven_onl_est OWNER TO postgres;

--
-- TOC entry 361 (class 1259 OID 23001)
-- Name: ven_onl_est_ven_onl_est_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ven_onl_est ALTER COLUMN ven_onl_est_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ven_onl_est_ven_onl_est_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 362 (class 1259 OID 23002)
-- Name: venta_boleto_evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta_boleto_evento (
    ven_bol_eve_id integer NOT NULL,
    ven_bol_eve_fecha_hora timestamp with time zone NOT NULL,
    ven_bol_eve_monto_total numeric(18,2) NOT NULL,
    ven_bol_eve_descripcion character varying(255) NOT NULL
);


ALTER TABLE public.venta_boleto_evento OWNER TO postgres;

--
-- TOC entry 363 (class 1259 OID 23005)
-- Name: venta_boleto_evento_ven_bol_eve_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.venta_boleto_evento ALTER COLUMN ven_bol_eve_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.venta_boleto_evento_ven_bol_eve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 364 (class 1259 OID 23006)
-- Name: venta_evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta_evento (
    ven_eve_id integer NOT NULL,
    ven_eve_fecha_hora timestamp with time zone NOT NULL,
    ven_eve_monto_total numeric(18,2) NOT NULL,
    fk_cliente integer NOT NULL,
    fk_evento integer NOT NULL
);


ALTER TABLE public.venta_evento OWNER TO postgres;

--
-- TOC entry 365 (class 1259 OID 23009)
-- Name: venta_evento_ven_eve_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.venta_evento ALTER COLUMN ven_eve_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.venta_evento_ven_eve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 366 (class 1259 OID 23010)
-- Name: venta_fisica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta_fisica (
    ven_fis_id integer NOT NULL,
    ven_fis_fecha date NOT NULL,
    ven_fis_total integer NOT NULL,
    fk_cliente integer NOT NULL,
    fk_oferta integer,
    fk_tienda integer NOT NULL
);


ALTER TABLE public.venta_fisica OWNER TO postgres;

--
-- TOC entry 367 (class 1259 OID 23013)
-- Name: venta_fisica_ven_fis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.venta_fisica ALTER COLUMN ven_fis_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.venta_fisica_ven_fis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 368 (class 1259 OID 23014)
-- Name: venta_online; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta_online (
    ven_onl_id integer NOT NULL,
    ven_onl_fecha date NOT NULL,
    ven_onl_total integer NOT NULL,
    fk_oferta integer,
    fk_tienda integer NOT NULL,
    fk_usuario bigint NOT NULL
);


ALTER TABLE public.venta_online OWNER TO postgres;

--
-- TOC entry 369 (class 1259 OID 23017)
-- Name: venta_online_ven_onl_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.venta_online ALTER COLUMN ven_onl_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.venta_online_ven_onl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5106 (class 2606 OID 23019)
-- Name: admin_interface_theme admin_interface_theme_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_interface_theme
    ADD CONSTRAINT admin_interface_theme_name_key UNIQUE (name);


--
-- TOC entry 5108 (class 2606 OID 23021)
-- Name: admin_interface_theme admin_interface_theme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_interface_theme
    ADD CONSTRAINT admin_interface_theme_pkey PRIMARY KEY (id);


--
-- TOC entry 5112 (class 2606 OID 23023)
-- Name: afi_est afi_est_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afi_est
    ADD CONSTRAINT afi_est_pkey PRIMARY KEY (afi_est_id);


--
-- TOC entry 5116 (class 2606 OID 23025)
-- Name: afiliacion afiliacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afiliacion
    ADD CONSTRAINT afiliacion_pkey PRIMARY KEY (afi_id);


--
-- TOC entry 5119 (class 2606 OID 23027)
-- Name: almacen almacen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.almacen
    ADD CONSTRAINT almacen_pkey PRIMARY KEY (alm_id);


--
-- TOC entry 5122 (class 2606 OID 23029)
-- Name: anaquel anaquel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anaquel
    ADD CONSTRAINT anaquel_pkey PRIMARY KEY (ana_id);


--
-- TOC entry 5130 (class 2606 OID 23031)
-- Name: asistencia_evento asistencia_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia_evento
    ADD CONSTRAINT asistencia_evento_pkey PRIMARY KEY (asi_eve_id);


--
-- TOC entry 5125 (class 2606 OID 23033)
-- Name: asistencia asistencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT asistencia_pkey PRIMARY KEY (asi_id);


--
-- TOC entry 5133 (class 2606 OID 23035)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 5138 (class 2606 OID 23037)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 5141 (class 2606 OID 23039)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5135 (class 2606 OID 23041)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 5144 (class 2606 OID 23043)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 5146 (class 2606 OID 23045)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 5150 (class 2606 OID 23047)
-- Name: car_tip_cer car_tip_cer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_tip_cer
    ADD CONSTRAINT car_tip_cer_pkey PRIMARY KEY (id);


--
-- TOC entry 5152 (class 2606 OID 23049)
-- Name: caracteristica caracteristica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caracteristica
    ADD CONSTRAINT caracteristica_pkey PRIMARY KEY (car_id);


--
-- TOC entry 5155 (class 2606 OID 23051)
-- Name: cargo cargo_car_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargo
    ADD CONSTRAINT cargo_car_nombre_key UNIQUE (car_nombre);


--
-- TOC entry 5157 (class 2606 OID 23053)
-- Name: cargo cargo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargo
    ADD CONSTRAINT cargo_pkey PRIMARY KEY (car_id);


--
-- TOC entry 5161 (class 2606 OID 23055)
-- Name: cerv_car cerv_car_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cerv_car
    ADD CONSTRAINT cerv_car_pkey PRIMARY KEY (id);


--
-- TOC entry 5164 (class 2606 OID 23057)
-- Name: cerveza cerveza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cerveza
    ADD CONSTRAINT cerveza_pkey PRIMARY KEY (cer_id);


--
-- TOC entry 5167 (class 2606 OID 23059)
-- Name: cliente cliente_cli_nat_ci_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_cli_nat_ci_key UNIQUE (cli_nat_ci);


--
-- TOC entry 5170 (class 2606 OID 23061)
-- Name: cliente cliente_cli_rif_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_cli_rif_key UNIQUE (cli_rif);


--
-- TOC entry 5173 (class 2606 OID 23063)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cli_id);


--
-- TOC entry 5176 (class 2606 OID 23065)
-- Name: contacto_cliente contacto_cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacto_cliente
    ADD CONSTRAINT contacto_cliente_pkey PRIMARY KEY (con_cli_id);


--
-- TOC entry 5179 (class 2606 OID 23067)
-- Name: contacto_proveedor contacto_proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacto_proveedor
    ADD CONSTRAINT contacto_proveedor_pkey PRIMARY KEY (con_pro_id);


--
-- TOC entry 5186 (class 2606 OID 23069)
-- Name: correo_electronico correo_electronico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.correo_electronico
    ADD CONSTRAINT correo_electronico_pkey PRIMARY KEY (cor_ele_id);


--
-- TOC entry 5189 (class 2606 OID 23071)
-- Name: cuenta_punto cuenta_punto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta_punto
    ADD CONSTRAINT cuenta_punto_pkey PRIMARY KEY (cue_pun_id);


--
-- TOC entry 5193 (class 2606 OID 23073)
-- Name: dep_tie dep_tie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dep_tie
    ADD CONSTRAINT dep_tie_pkey PRIMARY KEY (id);


--
-- TOC entry 5196 (class 2606 OID 23075)
-- Name: departamento departamento_dep_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_dep_nombre_key UNIQUE (dep_nombre);


--
-- TOC entry 5198 (class 2606 OID 23077)
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (dep_id);


--
-- TOC entry 5202 (class 2606 OID 23079)
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (det_com_id);


--
-- TOC entry 5206 (class 2606 OID 23081)
-- Name: detalle_venta_evento detalle_venta_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_evento
    ADD CONSTRAINT detalle_venta_evento_pkey PRIMARY KEY (det_ven_eve_id);


--
-- TOC entry 5210 (class 2606 OID 23083)
-- Name: detalle_venta_fisica detalle_venta_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_fisica
    ADD CONSTRAINT detalle_venta_fisica_pkey PRIMARY KEY (det_ven_fis_id);


--
-- TOC entry 5214 (class 2606 OID 23085)
-- Name: detalle_venta_online detalle_venta_online_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_online
    ADD CONSTRAINT detalle_venta_online_pkey PRIMARY KEY (det_ven_onl_id);


--
-- TOC entry 5217 (class 2606 OID 23087)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 5220 (class 2606 OID 23089)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 5222 (class 2606 OID 23091)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 5224 (class 2606 OID 23093)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 5227 (class 2606 OID 23095)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 5232 (class 2606 OID 23097)
-- Name: emp_car emp_car_fk_empleado_fk_cargo_fk__7e690c0f_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car
    ADD CONSTRAINT emp_car_fk_empleado_fk_cargo_fk__7e690c0f_uniq UNIQUE (fk_empleado, fk_cargo, fk_departamento, fk_tienda);


--
-- TOC entry 5241 (class 2606 OID 23099)
-- Name: emp_car_hor emp_car_hor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car_hor
    ADD CONSTRAINT emp_car_hor_pkey PRIMARY KEY (id);


--
-- TOC entry 5234 (class 2606 OID 23101)
-- Name: emp_car emp_car_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car
    ADD CONSTRAINT emp_car_pkey PRIMARY KEY (id);


--
-- TOC entry 5245 (class 2606 OID 23103)
-- Name: emp_tip_ben emp_tip_ben_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_tip_ben
    ADD CONSTRAINT emp_tip_ben_pkey PRIMARY KEY (id);


--
-- TOC entry 5248 (class 2606 OID 23105)
-- Name: empleado empleado_emp_ci_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_emp_ci_key UNIQUE (emp_ci);


--
-- TOC entry 5251 (class 2606 OID 23107)
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (emp_id);


--
-- TOC entry 5254 (class 2606 OID 23109)
-- Name: estatus estatus_est_tipo_estatus_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estatus
    ADD CONSTRAINT estatus_est_tipo_estatus_key UNIQUE (est_tipo_estatus);


--
-- TOC entry 5256 (class 2606 OID 23111)
-- Name: estatus estatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estatus
    ADD CONSTRAINT estatus_pkey PRIMARY KEY (est_id);


--
-- TOC entry 5258 (class 2606 OID 23113)
-- Name: estilo_cerveza estilo_cerveza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estilo_cerveza
    ADD CONSTRAINT estilo_cerveza_pkey PRIMARY KEY (est_cer_id);


--
-- TOC entry 5261 (class 2606 OID 23115)
-- Name: eve_pro eve_pro_fk_evento_fk_proveedor_d084f3e7_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eve_pro
    ADD CONSTRAINT eve_pro_fk_evento_fk_proveedor_d084f3e7_uniq UNIQUE (fk_evento, fk_proveedor);


--
-- TOC entry 5264 (class 2606 OID 23117)
-- Name: eve_pro eve_pro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eve_pro
    ADD CONSTRAINT eve_pro_pkey PRIMARY KEY (eve_pro_id);


--
-- TOC entry 5268 (class 2606 OID 23119)
-- Name: evento evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT evento_pkey PRIMARY KEY (eve_id);


--
-- TOC entry 5272 (class 2606 OID 23121)
-- Name: existencia_evento existencia_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.existencia_evento
    ADD CONSTRAINT existencia_evento_pkey PRIMARY KEY (exi_eve_id);


--
-- TOC entry 5275 (class 2606 OID 23123)
-- Name: historico_moneda historico_moneda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_moneda
    ADD CONSTRAINT historico_moneda_pkey PRIMARY KEY (his_mon_id);


--
-- TOC entry 5277 (class 2606 OID 23125)
-- Name: historico_precio_punto historico_precio_punto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_precio_punto
    ADD CONSTRAINT historico_precio_punto_pkey PRIMARY KEY (his_pre_pun_id);


--
-- TOC entry 5279 (class 2606 OID 23127)
-- Name: horario horario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horario
    ADD CONSTRAINT horario_pkey PRIMARY KEY (hor_id);


--
-- TOC entry 5281 (class 2606 OID 23129)
-- Name: ingrediente ingrediente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingrediente
    ADD CONSTRAINT ingrediente_pkey PRIMARY KEY (ing_id);


--
-- TOC entry 5283 (class 2606 OID 23131)
-- Name: instruccion instruccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instruccion
    ADD CONSTRAINT instruccion_pkey PRIMARY KEY (ins_id);


--
-- TOC entry 5288 (class 2606 OID 23133)
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (inv_id);


--
-- TOC entry 5291 (class 2606 OID 23135)
-- Name: lugar lugar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lugar
    ADD CONSTRAINT lugar_pkey PRIMARY KEY (lug_id);


--
-- TOC entry 5295 (class 2606 OID 23137)
-- Name: lugar_tienda lugar_tienda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lugar_tienda
    ADD CONSTRAINT lugar_tienda_pkey PRIMARY KEY (lug_tie_id);


--
-- TOC entry 5298 (class 2606 OID 23139)
-- Name: metodo_pago metodo_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodo_pago
    ADD CONSTRAINT metodo_pago_pkey PRIMARY KEY (met_pag_id);


--
-- TOC entry 5301 (class 2606 OID 23141)
-- Name: moneda moneda_mon_tipo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moneda
    ADD CONSTRAINT moneda_mon_tipo_key UNIQUE (mon_tipo);


--
-- TOC entry 5303 (class 2606 OID 23143)
-- Name: moneda moneda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moneda
    ADD CONSTRAINT moneda_pkey PRIMARY KEY (mon_id);


--
-- TOC entry 5305 (class 2606 OID 23145)
-- Name: oferta oferta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oferta
    ADD CONSTRAINT oferta_pkey PRIMARY KEY (ofe_id);


--
-- TOC entry 5316 (class 2606 OID 23147)
-- Name: pago_efectivo pago_efectivo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago_efectivo
    ADD CONSTRAINT pago_efectivo_pkey PRIMARY KEY (pag_efe_id);


--
-- TOC entry 5313 (class 2606 OID 23149)
-- Name: pago pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (pag_id);


--
-- TOC entry 5321 (class 2606 OID 23151)
-- Name: pre_alm pre_alm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_alm
    ADD CONSTRAINT pre_alm_pkey PRIMARY KEY (pre_alm_id);


--
-- TOC entry 5324 (class 2606 OID 23153)
-- Name: presentacion presentacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presentacion
    ADD CONSTRAINT presentacion_pkey PRIMARY KEY (prese_id);


--
-- TOC entry 5427 (class 2606 OID 23991)
-- Name: privilegio privilegio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilegio
    ADD CONSTRAINT privilegio_pkey PRIMARY KEY (privilegio_id);


--
-- TOC entry 5430 (class 2606 OID 23993)
-- Name: privilegio privilegio_privilegio_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privilegio
    ADD CONSTRAINT privilegio_privilegio_nombre_key UNIQUE (privilegio_nombre);


--
-- TOC entry 5327 (class 2606 OID 23155)
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (pro_id);


--
-- TOC entry 5330 (class 2606 OID 23157)
-- Name: proveedor proveedor_pro_rif_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pro_rif_key UNIQUE (pro_rif);


--
-- TOC entry 5334 (class 2606 OID 23159)
-- Name: rec_ing rec_ing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rec_ing
    ADD CONSTRAINT rec_ing_pkey PRIMARY KEY (rec_ing_id);


--
-- TOC entry 5338 (class 2606 OID 23161)
-- Name: rec_ins rec_ins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rec_ins
    ADD CONSTRAINT rec_ins_pkey PRIMARY KEY (rec_ins_id);


--
-- TOC entry 5340 (class 2606 OID 23163)
-- Name: receta receta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_pkey PRIMARY KEY (rec_id);


--
-- TOC entry 5432 (class 2606 OID 23999)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (rol_id);


--
-- TOC entry 5439 (class 2606 OID 24017)
-- Name: rol_privilegio rol_privilegio_fk_rol_fk_privilegio_b30d801e_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_privilegio
    ADD CONSTRAINT rol_privilegio_fk_rol_fk_privilegio_b30d801e_uniq UNIQUE (fk_rol, fk_privilegio);


--
-- TOC entry 5441 (class 2606 OID 24012)
-- Name: rol_privilegio rol_privilegio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_privilegio
    ADD CONSTRAINT rol_privilegio_pkey PRIMARY KEY (id);


--
-- TOC entry 5435 (class 2606 OID 24001)
-- Name: rol rol_rol_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_rol_nombre_key UNIQUE (rol_nombre);


--
-- TOC entry 5344 (class 2606 OID 23165)
-- Name: sol_com_est sol_com_est_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sol_com_est
    ADD CONSTRAINT sol_com_est_pkey PRIMARY KEY (sol_com_est_id);


--
-- TOC entry 5348 (class 2606 OID 23167)
-- Name: sol_rep_est sol_rep_est_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sol_rep_est
    ADD CONSTRAINT sol_rep_est_pkey PRIMARY KEY (sol_rep_est_id);


--
-- TOC entry 5353 (class 2606 OID 23169)
-- Name: solicitud_compra solicitud_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_compra
    ADD CONSTRAINT solicitud_compra_pkey PRIMARY KEY (sol_com_id);


--
-- TOC entry 5358 (class 2606 OID 23171)
-- Name: solicitud_reposicion solicitud_reposicion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_reposicion
    ADD CONSTRAINT solicitud_reposicion_pkey PRIMARY KEY (sol_rep_id);


--
-- TOC entry 5365 (class 2606 OID 23173)
-- Name: telefono telefono_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_pkey PRIMARY KEY (tel_id);


--
-- TOC entry 5368 (class 2606 OID 23175)
-- Name: tienda tienda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tienda
    ADD CONSTRAINT tienda_pkey PRIMARY KEY (tie_id);


--
-- TOC entry 5370 (class 2606 OID 23177)
-- Name: tipo_beneficio tipo_beneficio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_beneficio
    ADD CONSTRAINT tipo_beneficio_pkey PRIMARY KEY (tip_ben_id);


--
-- TOC entry 5373 (class 2606 OID 23179)
-- Name: tipo_beneficio tipo_beneficio_tip_ben_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_beneficio
    ADD CONSTRAINT tipo_beneficio_tip_ben_nombre_key UNIQUE (tip_ben_nombre);


--
-- TOC entry 5375 (class 2606 OID 23181)
-- Name: tipo_cerveza tipo_cerveza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_cerveza
    ADD CONSTRAINT tipo_cerveza_pkey PRIMARY KEY (tip_cer_id);


--
-- TOC entry 5379 (class 2606 OID 23183)
-- Name: tipo_estilo_cerveza tipo_estilo_cerveza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_estilo_cerveza
    ADD CONSTRAINT tipo_estilo_cerveza_pkey PRIMARY KEY (tip_est_cer_id);


--
-- TOC entry 5382 (class 2606 OID 23185)
-- Name: tipo_evento tipo_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_evento
    ADD CONSTRAINT tipo_evento_pkey PRIMARY KEY (tip_eve_id);


--
-- TOC entry 5393 (class 2606 OID 23187)
-- Name: usuario_groups usuario_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_groups
    ADD CONSTRAINT usuario_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 5396 (class 2606 OID 23189)
-- Name: usuario_groups usuario_groups_usuario_id_group_id_2e3cd638_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_groups
    ADD CONSTRAINT usuario_groups_usuario_id_group_id_2e3cd638_uniq UNIQUE (usuario_id, group_id);


--
-- TOC entry 5387 (class 2606 OID 23191)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 5399 (class 2606 OID 23193)
-- Name: usuario_user_permissions usuario_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_user_permissions
    ADD CONSTRAINT usuario_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5402 (class 2606 OID 23195)
-- Name: usuario_user_permissions usuario_user_permissions_usuario_id_permission_id_3db58b8c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_user_permissions
    ADD CONSTRAINT usuario_user_permissions_usuario_id_permission_id_3db58b8c_uniq UNIQUE (usuario_id, permission_id);


--
-- TOC entry 5390 (class 2606 OID 23197)
-- Name: usuario usuario_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);


--
-- TOC entry 5405 (class 2606 OID 23199)
-- Name: vacacion vacacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacacion
    ADD CONSTRAINT vacacion_pkey PRIMARY KEY (vac_id);


--
-- TOC entry 5409 (class 2606 OID 23201)
-- Name: ven_onl_est ven_onl_est_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_onl_est
    ADD CONSTRAINT ven_onl_est_pkey PRIMARY KEY (ven_onl_est_id);


--
-- TOC entry 5411 (class 2606 OID 23203)
-- Name: venta_boleto_evento venta_boleto_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_boleto_evento
    ADD CONSTRAINT venta_boleto_evento_pkey PRIMARY KEY (ven_bol_eve_id);


--
-- TOC entry 5415 (class 2606 OID 23205)
-- Name: venta_evento venta_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_evento
    ADD CONSTRAINT venta_evento_pkey PRIMARY KEY (ven_eve_id);


--
-- TOC entry 5420 (class 2606 OID 23207)
-- Name: venta_fisica venta_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_fisica
    ADD CONSTRAINT venta_fisica_pkey PRIMARY KEY (ven_fis_id);


--
-- TOC entry 5425 (class 2606 OID 23209)
-- Name: venta_online venta_online_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_online
    ADD CONSTRAINT venta_online_pkey PRIMARY KEY (ven_onl_id);


--
-- TOC entry 5104 (class 1259 OID 23210)
-- Name: admin_interface_theme_name_30bda70f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_interface_theme_name_30bda70f_like ON public.admin_interface_theme USING btree (name varchar_pattern_ops);


--
-- TOC entry 5109 (class 1259 OID 23211)
-- Name: afi_est_fk_afiliacion_c96a58d5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX afi_est_fk_afiliacion_c96a58d5 ON public.afi_est USING btree (fk_afiliacion);


--
-- TOC entry 5110 (class 1259 OID 23212)
-- Name: afi_est_fk_estatus_80c67bde; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX afi_est_fk_estatus_80c67bde ON public.afi_est USING btree (fk_estatus);


--
-- TOC entry 5113 (class 1259 OID 23213)
-- Name: afiliacion_fk_proveedor_138d21e9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX afiliacion_fk_proveedor_138d21e9 ON public.afiliacion USING btree (fk_proveedor);


--
-- TOC entry 5114 (class 1259 OID 23214)
-- Name: afiliacion_fk_tienda_25a1ae33; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX afiliacion_fk_tienda_25a1ae33 ON public.afiliacion USING btree (fk_tienda);


--
-- TOC entry 5117 (class 1259 OID 23215)
-- Name: almacen_fk_tienda_182f6ff1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX almacen_fk_tienda_182f6ff1 ON public.almacen USING btree (fk_tienda);


--
-- TOC entry 5120 (class 1259 OID 23216)
-- Name: anaquel_fk_lugar_tienda_b94218bd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX anaquel_fk_lugar_tienda_b94218bd ON public.anaquel USING btree (fk_lugar_tienda);


--
-- TOC entry 5126 (class 1259 OID 23217)
-- Name: asistencia_evento_fk_cliente_d0dc47f6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asistencia_evento_fk_cliente_d0dc47f6 ON public.asistencia_evento USING btree (fk_cliente);


--
-- TOC entry 5127 (class 1259 OID 23218)
-- Name: asistencia_evento_fk_evento_4f0bf62d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asistencia_evento_fk_evento_4f0bf62d ON public.asistencia_evento USING btree (fk_evento);


--
-- TOC entry 5128 (class 1259 OID 23219)
-- Name: asistencia_evento_fk_ven_bol_eve_fd72f073; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asistencia_evento_fk_ven_bol_eve_fd72f073 ON public.asistencia_evento USING btree (fk_ven_bol_eve);


--
-- TOC entry 5123 (class 1259 OID 23220)
-- Name: asistencia_fk_empleado_ad1a0f87; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX asistencia_fk_empleado_ad1a0f87 ON public.asistencia USING btree (fk_empleado);


--
-- TOC entry 5131 (class 1259 OID 23221)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 5136 (class 1259 OID 23222)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 5139 (class 1259 OID 23223)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 5142 (class 1259 OID 23224)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 5147 (class 1259 OID 23225)
-- Name: car_tip_cer_fk_caracteristica_eb690ec0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_tip_cer_fk_caracteristica_eb690ec0 ON public.car_tip_cer USING btree (fk_caracteristica);


--
-- TOC entry 5148 (class 1259 OID 23226)
-- Name: car_tip_cer_fk_tipo_cerveza_6206cb80; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX car_tip_cer_fk_tipo_cerveza_6206cb80 ON public.car_tip_cer USING btree (fk_tipo_cerveza);


--
-- TOC entry 5153 (class 1259 OID 23227)
-- Name: cargo_car_nombre_9cf4f9ee_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cargo_car_nombre_9cf4f9ee_like ON public.cargo USING btree (car_nombre varchar_pattern_ops);


--
-- TOC entry 5158 (class 1259 OID 23228)
-- Name: cerv_car_fk_caracteristica_fdfb8a58; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cerv_car_fk_caracteristica_fdfb8a58 ON public.cerv_car USING btree (fk_caracteristica);


--
-- TOC entry 5159 (class 1259 OID 23229)
-- Name: cerv_car_fk_cerveza_3e5952ac; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cerv_car_fk_cerveza_3e5952ac ON public.cerv_car USING btree (fk_cerveza);


--
-- TOC entry 5162 (class 1259 OID 23230)
-- Name: cerveza_fk_tipo_estilo_cerveza_83d8a42a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cerveza_fk_tipo_estilo_cerveza_83d8a42a ON public.cerveza USING btree (fk_tipo_estilo_cerveza);


--
-- TOC entry 5165 (class 1259 OID 23231)
-- Name: cliente_cli_nat_ci_f109af57_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cliente_cli_nat_ci_f109af57_like ON public.cliente USING btree (cli_nat_ci varchar_pattern_ops);


--
-- TOC entry 5168 (class 1259 OID 23232)
-- Name: cliente_cli_rif_41bae00a_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cliente_cli_rif_41bae00a_like ON public.cliente USING btree (cli_rif varchar_pattern_ops);


--
-- TOC entry 5171 (class 1259 OID 23233)
-- Name: cliente_fk_lugar_d10f46fc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cliente_fk_lugar_d10f46fc ON public.cliente USING btree (fk_lugar);


--
-- TOC entry 5174 (class 1259 OID 23234)
-- Name: contacto_cliente_fk_cliente_d6d1ddfb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX contacto_cliente_fk_cliente_d6d1ddfb ON public.contacto_cliente USING btree (fk_cliente);


--
-- TOC entry 5177 (class 1259 OID 23235)
-- Name: contacto_proveedor_fk_proveedor_bec82efc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX contacto_proveedor_fk_proveedor_bec82efc ON public.contacto_proveedor USING btree (fk_proveedor);


--
-- TOC entry 5180 (class 1259 OID 23236)
-- Name: correo_electronico_fk_cliente_1675eca8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX correo_electronico_fk_cliente_1675eca8 ON public.correo_electronico USING btree (fk_cliente);


--
-- TOC entry 5181 (class 1259 OID 23237)
-- Name: correo_electronico_fk_contacto_cliente_3a44c8ea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX correo_electronico_fk_contacto_cliente_3a44c8ea ON public.correo_electronico USING btree (fk_contacto_cliente);


--
-- TOC entry 5182 (class 1259 OID 23238)
-- Name: correo_electronico_fk_contacto_proveedor_232a81da; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX correo_electronico_fk_contacto_proveedor_232a81da ON public.correo_electronico USING btree (fk_contacto_proveedor);


--
-- TOC entry 5183 (class 1259 OID 23239)
-- Name: correo_electronico_fk_empleado_9dd767b3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX correo_electronico_fk_empleado_9dd767b3 ON public.correo_electronico USING btree (fk_empleado);


--
-- TOC entry 5184 (class 1259 OID 23240)
-- Name: correo_electronico_fk_proveedor_cfa4325b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX correo_electronico_fk_proveedor_cfa4325b ON public.correo_electronico USING btree (fk_proveedor);


--
-- TOC entry 5187 (class 1259 OID 23241)
-- Name: cuenta_punto_fk_cliente_8a672568; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cuenta_punto_fk_cliente_8a672568 ON public.cuenta_punto USING btree (fk_cliente);


--
-- TOC entry 5190 (class 1259 OID 23242)
-- Name: dep_tie_fk_departamento_b29b24bf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dep_tie_fk_departamento_b29b24bf ON public.dep_tie USING btree (fk_departamento);


--
-- TOC entry 5191 (class 1259 OID 23243)
-- Name: dep_tie_fk_tienda_8f8c75d7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dep_tie_fk_tienda_8f8c75d7 ON public.dep_tie USING btree (fk_tienda);


--
-- TOC entry 5194 (class 1259 OID 23244)
-- Name: departamento_dep_nombre_8a5d3481_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX departamento_dep_nombre_8a5d3481_like ON public.departamento USING btree (dep_nombre varchar_pattern_ops);


--
-- TOC entry 5199 (class 1259 OID 23245)
-- Name: detalle_compra_fk_presentacion_7fb10ea0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX detalle_compra_fk_presentacion_7fb10ea0 ON public.detalle_compra USING btree (fk_presentacion);


--
-- TOC entry 5200 (class 1259 OID 23246)
-- Name: detalle_compra_fk_sol_com_217351a2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX detalle_compra_fk_sol_com_217351a2 ON public.detalle_compra USING btree (fk_sol_com);


--
-- TOC entry 5203 (class 1259 OID 23247)
-- Name: detalle_venta_evento_fk_exi_eve_ad5084b0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX detalle_venta_evento_fk_exi_eve_ad5084b0 ON public.detalle_venta_evento USING btree (fk_exi_eve);


--
-- TOC entry 5204 (class 1259 OID 23248)
-- Name: detalle_venta_evento_fk_venta_evento_3071707e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX detalle_venta_evento_fk_venta_evento_3071707e ON public.detalle_venta_evento USING btree (fk_venta_evento);


--
-- TOC entry 5207 (class 1259 OID 23249)
-- Name: detalle_venta_fisica_fk_inventario_05904a18; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX detalle_venta_fisica_fk_inventario_05904a18 ON public.detalle_venta_fisica USING btree (fk_inventario);


--
-- TOC entry 5208 (class 1259 OID 23250)
-- Name: detalle_venta_fisica_fk_venta_fisica_21f2bec4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX detalle_venta_fisica_fk_venta_fisica_21f2bec4 ON public.detalle_venta_fisica USING btree (fk_venta_fisica);


--
-- TOC entry 5211 (class 1259 OID 23251)
-- Name: detalle_venta_online_fk_pre_alm_96592db4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX detalle_venta_online_fk_pre_alm_96592db4 ON public.detalle_venta_online USING btree (fk_pre_alm);


--
-- TOC entry 5212 (class 1259 OID 23252)
-- Name: detalle_venta_online_fk_venta_online_a472f874; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX detalle_venta_online_fk_venta_online_a472f874 ON public.detalle_venta_online USING btree (fk_venta_online);


--
-- TOC entry 5215 (class 1259 OID 23253)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 5218 (class 1259 OID 23254)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 5225 (class 1259 OID 23255)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 5228 (class 1259 OID 23256)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 5229 (class 1259 OID 23257)
-- Name: emp_car_fk_cargo_0bf0fe73; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_car_fk_cargo_0bf0fe73 ON public.emp_car USING btree (fk_cargo);


--
-- TOC entry 5230 (class 1259 OID 23258)
-- Name: emp_car_fk_empleado_60df61f4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_car_fk_empleado_60df61f4 ON public.emp_car USING btree (fk_empleado);


--
-- TOC entry 5235 (class 1259 OID 23259)
-- Name: emp_car_hor_fk_cargo_5f5dacf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_car_hor_fk_cargo_5f5dacf9 ON public.emp_car_hor USING btree (fk_cargo);


--
-- TOC entry 5236 (class 1259 OID 23260)
-- Name: emp_car_hor_fk_departamento_d475f135; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_car_hor_fk_departamento_d475f135 ON public.emp_car_hor USING btree (fk_departamento);


--
-- TOC entry 5237 (class 1259 OID 23261)
-- Name: emp_car_hor_fk_empleado_5d35073d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_car_hor_fk_empleado_5d35073d ON public.emp_car_hor USING btree (fk_empleado);


--
-- TOC entry 5238 (class 1259 OID 23262)
-- Name: emp_car_hor_fk_horario_fb352a17; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_car_hor_fk_horario_fb352a17 ON public.emp_car_hor USING btree (fk_horario);


--
-- TOC entry 5239 (class 1259 OID 23263)
-- Name: emp_car_hor_fk_tienda_3fc5172f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_car_hor_fk_tienda_3fc5172f ON public.emp_car_hor USING btree (fk_tienda);


--
-- TOC entry 5242 (class 1259 OID 23264)
-- Name: emp_tip_ben_fk_empleado_6458ef81; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_tip_ben_fk_empleado_6458ef81 ON public.emp_tip_ben USING btree (fk_empleado);


--
-- TOC entry 5243 (class 1259 OID 23265)
-- Name: emp_tip_ben_fk_tipo_beneficio_ae383219; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX emp_tip_ben_fk_tipo_beneficio_ae383219 ON public.emp_tip_ben USING btree (fk_tipo_beneficio);


--
-- TOC entry 5246 (class 1259 OID 23266)
-- Name: empleado_emp_ci_de9ccff4_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX empleado_emp_ci_de9ccff4_like ON public.empleado USING btree (emp_ci varchar_pattern_ops);


--
-- TOC entry 5249 (class 1259 OID 23267)
-- Name: empleado_fk_lugar_68df3593; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX empleado_fk_lugar_68df3593 ON public.empleado USING btree (fk_lugar);


--
-- TOC entry 5252 (class 1259 OID 23268)
-- Name: estatus_est_tipo_estatus_6b47eec1_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX estatus_est_tipo_estatus_6b47eec1_like ON public.estatus USING btree (est_tipo_estatus varchar_pattern_ops);


--
-- TOC entry 5259 (class 1259 OID 23269)
-- Name: eve_pro_fk_evento_e275f857; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX eve_pro_fk_evento_e275f857 ON public.eve_pro USING btree (fk_evento);


--
-- TOC entry 5262 (class 1259 OID 23270)
-- Name: eve_pro_fk_proveedor_f7e10495; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX eve_pro_fk_proveedor_f7e10495 ON public.eve_pro USING btree (fk_proveedor);


--
-- TOC entry 5265 (class 1259 OID 23271)
-- Name: evento_fk_lugar_7051b684; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX evento_fk_lugar_7051b684 ON public.evento USING btree (fk_lugar);


--
-- TOC entry 5266 (class 1259 OID 23272)
-- Name: evento_fk_tip_eve_c60c530e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX evento_fk_tip_eve_c60c530e ON public.evento USING btree (fk_tip_eve);


--
-- TOC entry 5269 (class 1259 OID 23273)
-- Name: existencia_evento_fk_evento_proveedor_3ddb7e7f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX existencia_evento_fk_evento_proveedor_3ddb7e7f ON public.existencia_evento USING btree (fk_evento_proveedor);


--
-- TOC entry 5270 (class 1259 OID 23274)
-- Name: existencia_evento_fk_presentacion_d7307eef; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX existencia_evento_fk_presentacion_d7307eef ON public.existencia_evento USING btree (fk_presentacion);


--
-- TOC entry 5273 (class 1259 OID 23275)
-- Name: historico_moneda_fk_moneda_f7a8a024; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX historico_moneda_fk_moneda_f7a8a024 ON public.historico_moneda USING btree (fk_moneda);


--
-- TOC entry 5284 (class 1259 OID 23276)
-- Name: inventario_fk_anaquel_340a6257; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX inventario_fk_anaquel_340a6257 ON public.inventario USING btree (fk_anaquel);


--
-- TOC entry 5285 (class 1259 OID 23277)
-- Name: inventario_fk_oferta_e57cd75c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX inventario_fk_oferta_e57cd75c ON public.inventario USING btree (fk_oferta);


--
-- TOC entry 5286 (class 1259 OID 23278)
-- Name: inventario_fk_presentacion_b292e310; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX inventario_fk_presentacion_b292e310 ON public.inventario USING btree (fk_presentacion);


--
-- TOC entry 5289 (class 1259 OID 23279)
-- Name: lugar_fk_lugar_c34c3bbf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lugar_fk_lugar_c34c3bbf ON public.lugar USING btree (fk_lugar);


--
-- TOC entry 5292 (class 1259 OID 23280)
-- Name: lugar_tienda_fk_lugar_tienda_fabc654c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lugar_tienda_fk_lugar_tienda_fabc654c ON public.lugar_tienda USING btree (fk_lugar_tienda);


--
-- TOC entry 5293 (class 1259 OID 23281)
-- Name: lugar_tienda_fk_tienda_1b0e37d3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lugar_tienda_fk_tienda_1b0e37d3 ON public.lugar_tienda USING btree (fk_tienda);


--
-- TOC entry 5296 (class 1259 OID 23282)
-- Name: metodo_pago_fk_his_pre_pun_ba04b391; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX metodo_pago_fk_his_pre_pun_ba04b391 ON public.metodo_pago USING btree (fk_his_pre_pun);


--
-- TOC entry 5299 (class 1259 OID 23283)
-- Name: moneda_mon_tipo_fb01df73_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX moneda_mon_tipo_fb01df73_like ON public.moneda USING btree (mon_tipo varchar_pattern_ops);


--
-- TOC entry 5314 (class 1259 OID 23284)
-- Name: pago_efectivo_fk_metodo_pago_5cfe4bc4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pago_efectivo_fk_metodo_pago_5cfe4bc4 ON public.pago_efectivo USING btree (fk_metodo_pago);


--
-- TOC entry 5306 (class 1259 OID 23285)
-- Name: pago_fk_afiliacion_5599c377; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pago_fk_afiliacion_5599c377 ON public.pago USING btree (fk_afiliacion);


--
-- TOC entry 5307 (class 1259 OID 23286)
-- Name: pago_fk_metodo_pago_958fa9c8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pago_fk_metodo_pago_958fa9c8 ON public.pago USING btree (fk_metodo_pago);


--
-- TOC entry 5308 (class 1259 OID 23287)
-- Name: pago_fk_moneda_2704d165; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pago_fk_moneda_2704d165 ON public.pago USING btree (fk_moneda);


--
-- TOC entry 5309 (class 1259 OID 23288)
-- Name: pago_fk_venta_evento_4bddf9fa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pago_fk_venta_evento_4bddf9fa ON public.pago USING btree (fk_venta_evento);


--
-- TOC entry 5310 (class 1259 OID 23289)
-- Name: pago_fk_venta_fisica_f58df627; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pago_fk_venta_fisica_f58df627 ON public.pago USING btree (fk_venta_fisica);


--
-- TOC entry 5311 (class 1259 OID 23290)
-- Name: pago_fk_venta_online_4161ef78; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pago_fk_venta_online_4161ef78 ON public.pago USING btree (fk_venta_online);


--
-- TOC entry 5317 (class 1259 OID 23291)
-- Name: pre_alm_fk_almacen_58bc2a80; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pre_alm_fk_almacen_58bc2a80 ON public.pre_alm USING btree (fk_almacen);


--
-- TOC entry 5318 (class 1259 OID 23292)
-- Name: pre_alm_fk_oferta_310e972d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pre_alm_fk_oferta_310e972d ON public.pre_alm USING btree (fk_oferta);


--
-- TOC entry 5319 (class 1259 OID 23293)
-- Name: pre_alm_fk_presentacion_5791ab49; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pre_alm_fk_presentacion_5791ab49 ON public.pre_alm USING btree (fk_presentacion);


--
-- TOC entry 5322 (class 1259 OID 23294)
-- Name: presentacion_fk_cerveza_fdd3f59d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX presentacion_fk_cerveza_fdd3f59d ON public.presentacion USING btree (fk_cerveza);


--
-- TOC entry 5428 (class 1259 OID 24013)
-- Name: privilegio_privilegio_nombre_d3daf350_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX privilegio_privilegio_nombre_d3daf350_like ON public.privilegio USING btree (privilegio_nombre varchar_pattern_ops);


--
-- TOC entry 5325 (class 1259 OID 23295)
-- Name: proveedor_fk_lugar_7459b24b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX proveedor_fk_lugar_7459b24b ON public.proveedor USING btree (fk_lugar);


--
-- TOC entry 5328 (class 1259 OID 23296)
-- Name: proveedor_pro_rif_54ed4c71_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX proveedor_pro_rif_54ed4c71_like ON public.proveedor USING btree (pro_rif varchar_pattern_ops);


--
-- TOC entry 5331 (class 1259 OID 23297)
-- Name: rec_ing_fk_ingrediente_1752b53d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rec_ing_fk_ingrediente_1752b53d ON public.rec_ing USING btree (fk_ingrediente);


--
-- TOC entry 5332 (class 1259 OID 23298)
-- Name: rec_ing_fk_receta_eb1aef13; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rec_ing_fk_receta_eb1aef13 ON public.rec_ing USING btree (fk_receta);


--
-- TOC entry 5335 (class 1259 OID 23299)
-- Name: rec_ins_fk_instruccion_5749ecf7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rec_ins_fk_instruccion_5749ecf7 ON public.rec_ins USING btree (fk_instruccion);


--
-- TOC entry 5336 (class 1259 OID 23300)
-- Name: rec_ins_fk_receta_775a9e30; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rec_ins_fk_receta_775a9e30 ON public.rec_ins USING btree (fk_receta);


--
-- TOC entry 5436 (class 1259 OID 24028)
-- Name: rol_privilegio_fk_privilegio_dea72104; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rol_privilegio_fk_privilegio_dea72104 ON public.rol_privilegio USING btree (fk_privilegio);


--
-- TOC entry 5437 (class 1259 OID 24029)
-- Name: rol_privilegio_fk_rol_723d6077; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rol_privilegio_fk_rol_723d6077 ON public.rol_privilegio USING btree (fk_rol);


--
-- TOC entry 5433 (class 1259 OID 24014)
-- Name: rol_rol_nombre_1e057d86_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rol_rol_nombre_1e057d86_like ON public.rol USING btree (rol_nombre varchar_pattern_ops);


--
-- TOC entry 5341 (class 1259 OID 23301)
-- Name: sol_com_est_fk_estatus_3f65e504; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sol_com_est_fk_estatus_3f65e504 ON public.sol_com_est USING btree (fk_estatus);


--
-- TOC entry 5342 (class 1259 OID 23302)
-- Name: sol_com_est_fk_sol_com_c02697c4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sol_com_est_fk_sol_com_c02697c4 ON public.sol_com_est USING btree (fk_sol_com);


--
-- TOC entry 5345 (class 1259 OID 23303)
-- Name: sol_rep_est_fk_estatus_400f4a62; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sol_rep_est_fk_estatus_400f4a62 ON public.sol_rep_est USING btree (fk_estatus);


--
-- TOC entry 5346 (class 1259 OID 23304)
-- Name: sol_rep_est_fk_sol_rep_5131a8fa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sol_rep_est_fk_sol_rep_5131a8fa ON public.sol_rep_est USING btree (fk_sol_rep);


--
-- TOC entry 5349 (class 1259 OID 23305)
-- Name: solicitud_compra_fk_pre_alm_9c5c5847; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX solicitud_compra_fk_pre_alm_9c5c5847 ON public.solicitud_compra USING btree (fk_pre_alm);


--
-- TOC entry 5350 (class 1259 OID 23306)
-- Name: solicitud_compra_fk_proveedor_682536fa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX solicitud_compra_fk_proveedor_682536fa ON public.solicitud_compra USING btree (fk_proveedor);


--
-- TOC entry 5351 (class 1259 OID 23307)
-- Name: solicitud_compra_fk_usuario_4a71efc5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX solicitud_compra_fk_usuario_4a71efc5 ON public.solicitud_compra USING btree (fk_usuario);


--
-- TOC entry 5354 (class 1259 OID 23308)
-- Name: solicitud_reposicion_fk_inv_755d3938; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX solicitud_reposicion_fk_inv_755d3938 ON public.solicitud_reposicion USING btree (fk_inv);


--
-- TOC entry 5355 (class 1259 OID 23309)
-- Name: solicitud_reposicion_fk_pre_alm_a29cf191; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX solicitud_reposicion_fk_pre_alm_a29cf191 ON public.solicitud_reposicion USING btree (fk_pre_alm);


--
-- TOC entry 5356 (class 1259 OID 23310)
-- Name: solicitud_reposicion_fk_usuario_55e4cc27; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX solicitud_reposicion_fk_usuario_55e4cc27 ON public.solicitud_reposicion USING btree (fk_usuario);


--
-- TOC entry 5359 (class 1259 OID 23311)
-- Name: telefono_fk_cliente_b85c99d6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX telefono_fk_cliente_b85c99d6 ON public.telefono USING btree (fk_cliente);


--
-- TOC entry 5360 (class 1259 OID 23312)
-- Name: telefono_fk_contacto_cliente_6bc5ba62; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX telefono_fk_contacto_cliente_6bc5ba62 ON public.telefono USING btree (fk_contacto_cliente);


--
-- TOC entry 5361 (class 1259 OID 23313)
-- Name: telefono_fk_contacto_proveedor_853fc0fc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX telefono_fk_contacto_proveedor_853fc0fc ON public.telefono USING btree (fk_contacto_proveedor);


--
-- TOC entry 5362 (class 1259 OID 23314)
-- Name: telefono_fk_empleado_218ece5a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX telefono_fk_empleado_218ece5a ON public.telefono USING btree (fk_empleado);


--
-- TOC entry 5363 (class 1259 OID 23315)
-- Name: telefono_fk_proveedor_e45ba6be; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX telefono_fk_proveedor_e45ba6be ON public.telefono USING btree (fk_proveedor);


--
-- TOC entry 5366 (class 1259 OID 23316)
-- Name: tienda_fk_lugar_a63cb22a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tienda_fk_lugar_a63cb22a ON public.tienda USING btree (fk_lugar);


--
-- TOC entry 5371 (class 1259 OID 23317)
-- Name: tipo_beneficio_tip_ben_nombre_7295c1da_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tipo_beneficio_tip_ben_nombre_7295c1da_like ON public.tipo_beneficio USING btree (tip_ben_nombre varchar_pattern_ops);


--
-- TOC entry 5376 (class 1259 OID 23318)
-- Name: tipo_estilo_cerveza_fk_estilo_cerveza_6891c74a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tipo_estilo_cerveza_fk_estilo_cerveza_6891c74a ON public.tipo_estilo_cerveza USING btree (fk_estilo_cerveza);


--
-- TOC entry 5377 (class 1259 OID 23319)
-- Name: tipo_estilo_cerveza_fk_tipo_cerveza_ed8d1c70; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tipo_estilo_cerveza_fk_tipo_cerveza_ed8d1c70 ON public.tipo_estilo_cerveza USING btree (fk_tipo_cerveza);


--
-- TOC entry 5380 (class 1259 OID 23320)
-- Name: tipo_evento_fk_tipo_evento_64e19139; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tipo_evento_fk_tipo_evento_64e19139 ON public.tipo_evento USING btree (fk_tipo_evento);


--
-- TOC entry 5383 (class 1259 OID 23321)
-- Name: usuario_fk_cliente_4ae4519a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX usuario_fk_cliente_4ae4519a ON public.usuario USING btree (fk_cliente);


--
-- TOC entry 5384 (class 1259 OID 23322)
-- Name: usuario_fk_proveedor_9b4f82fb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX usuario_fk_proveedor_9b4f82fb ON public.usuario USING btree (fk_proveedor);


--
-- TOC entry 5385 (class 1259 OID 24015)
-- Name: usuario_fk_rol_e0faaaac; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX usuario_fk_rol_e0faaaac ON public.usuario USING btree (fk_rol);


--
-- TOC entry 5391 (class 1259 OID 23323)
-- Name: usuario_groups_group_id_c67c8651; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX usuario_groups_group_id_c67c8651 ON public.usuario_groups USING btree (group_id);


--
-- TOC entry 5394 (class 1259 OID 23324)
-- Name: usuario_groups_usuario_id_161fc80c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX usuario_groups_usuario_id_161fc80c ON public.usuario_groups USING btree (usuario_id);


--
-- TOC entry 5397 (class 1259 OID 23325)
-- Name: usuario_user_permissions_permission_id_a8893ce7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX usuario_user_permissions_permission_id_a8893ce7 ON public.usuario_user_permissions USING btree (permission_id);


--
-- TOC entry 5400 (class 1259 OID 23326)
-- Name: usuario_user_permissions_usuario_id_693d9c50; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX usuario_user_permissions_usuario_id_693d9c50 ON public.usuario_user_permissions USING btree (usuario_id);


--
-- TOC entry 5388 (class 1259 OID 23327)
-- Name: usuario_username_7e1fc9dc_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX usuario_username_7e1fc9dc_like ON public.usuario USING btree (username varchar_pattern_ops);


--
-- TOC entry 5403 (class 1259 OID 23328)
-- Name: vacacion_fk_empleado_cb6959b7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vacacion_fk_empleado_cb6959b7 ON public.vacacion USING btree (fk_empleado);


--
-- TOC entry 5406 (class 1259 OID 23329)
-- Name: ven_onl_est_fk_estatus_2d259dbd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ven_onl_est_fk_estatus_2d259dbd ON public.ven_onl_est USING btree (fk_estatus);


--
-- TOC entry 5407 (class 1259 OID 23330)
-- Name: ven_onl_est_fk_venta_online_a6c34bae; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ven_onl_est_fk_venta_online_a6c34bae ON public.ven_onl_est USING btree (fk_venta_online);


--
-- TOC entry 5412 (class 1259 OID 23331)
-- Name: venta_evento_fk_cliente_1a772f9f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX venta_evento_fk_cliente_1a772f9f ON public.venta_evento USING btree (fk_cliente);


--
-- TOC entry 5413 (class 1259 OID 23332)
-- Name: venta_evento_fk_evento_259febf5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX venta_evento_fk_evento_259febf5 ON public.venta_evento USING btree (fk_evento);


--
-- TOC entry 5416 (class 1259 OID 23333)
-- Name: venta_fisica_fk_cliente_6695bafa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX venta_fisica_fk_cliente_6695bafa ON public.venta_fisica USING btree (fk_cliente);


--
-- TOC entry 5417 (class 1259 OID 23334)
-- Name: venta_fisica_fk_oferta_4e836443; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX venta_fisica_fk_oferta_4e836443 ON public.venta_fisica USING btree (fk_oferta);


--
-- TOC entry 5418 (class 1259 OID 23335)
-- Name: venta_fisica_fk_tienda_68b386cf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX venta_fisica_fk_tienda_68b386cf ON public.venta_fisica USING btree (fk_tienda);


--
-- TOC entry 5421 (class 1259 OID 23336)
-- Name: venta_online_fk_oferta_ae68023f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX venta_online_fk_oferta_ae68023f ON public.venta_online USING btree (fk_oferta);


--
-- TOC entry 5422 (class 1259 OID 23337)
-- Name: venta_online_fk_tienda_2b45db66; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX venta_online_fk_tienda_2b45db66 ON public.venta_online USING btree (fk_tienda);


--
-- TOC entry 5423 (class 1259 OID 23338)
-- Name: venta_online_fk_usuario_ff559976; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX venta_online_fk_usuario_ff559976 ON public.venta_online USING btree (fk_usuario);


--
-- TOC entry 5562 (class 2620 OID 24080)
-- Name: detalle_venta_fisica tr_descuento_inventario_venta_fisica; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_descuento_inventario_venta_fisica AFTER INSERT ON public.detalle_venta_fisica FOR EACH ROW EXECUTE FUNCTION public.fn_descuento_inventario_venta_fisica();


--
-- TOC entry 5563 (class 2620 OID 24082)
-- Name: inventario trg_verificar_stock_inventario; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_verificar_stock_inventario AFTER UPDATE ON public.inventario FOR EACH ROW WHEN (((new.inv_cantidad < old.inv_cantidad) AND (new.inv_cantidad <= 20))) EXECUTE FUNCTION public.fn_generar_reposicion_desde_inventario();


--
-- TOC entry 5565 (class 2620 OID 24071)
-- Name: sol_com_est trigger_entrega_completada; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_entrega_completada AFTER INSERT ON public.sol_com_est FOR EACH ROW EXECUTE FUNCTION public.actualizar_stock_entrega();


--
-- TOC entry 5564 (class 2620 OID 24069)
-- Name: pre_alm trigger_stock_bajo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_stock_bajo AFTER UPDATE ON public.pre_alm FOR EACH ROW EXECUTE FUNCTION public.crear_solicitud_compra();


--
-- TOC entry 5442 (class 2606 OID 23339)
-- Name: afi_est afi_est_fk_afiliacion_c96a58d5_fk_afiliacion_afi_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afi_est
    ADD CONSTRAINT afi_est_fk_afiliacion_c96a58d5_fk_afiliacion_afi_id FOREIGN KEY (fk_afiliacion) REFERENCES public.afiliacion(afi_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5443 (class 2606 OID 23344)
-- Name: afi_est afi_est_fk_estatus_80c67bde_fk_estatus_est_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afi_est
    ADD CONSTRAINT afi_est_fk_estatus_80c67bde_fk_estatus_est_id FOREIGN KEY (fk_estatus) REFERENCES public.estatus(est_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5444 (class 2606 OID 23349)
-- Name: afiliacion afiliacion_fk_proveedor_138d21e9_fk_proveedor_pro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afiliacion
    ADD CONSTRAINT afiliacion_fk_proveedor_138d21e9_fk_proveedor_pro_id FOREIGN KEY (fk_proveedor) REFERENCES public.proveedor(pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5445 (class 2606 OID 23354)
-- Name: afiliacion afiliacion_fk_tienda_25a1ae33_fk_tienda_tie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afiliacion
    ADD CONSTRAINT afiliacion_fk_tienda_25a1ae33_fk_tienda_tie_id FOREIGN KEY (fk_tienda) REFERENCES public.tienda(tie_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5446 (class 2606 OID 23359)
-- Name: almacen almacen_fk_tienda_182f6ff1_fk_tienda_tie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.almacen
    ADD CONSTRAINT almacen_fk_tienda_182f6ff1_fk_tienda_tie_id FOREIGN KEY (fk_tienda) REFERENCES public.tienda(tie_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5447 (class 2606 OID 23364)
-- Name: anaquel anaquel_fk_lugar_tienda_b94218bd_fk_lugar_tienda_lug_tie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anaquel
    ADD CONSTRAINT anaquel_fk_lugar_tienda_b94218bd_fk_lugar_tienda_lug_tie_id FOREIGN KEY (fk_lugar_tienda) REFERENCES public.lugar_tienda(lug_tie_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5449 (class 2606 OID 23369)
-- Name: asistencia_evento asistencia_evento_fk_cliente_d0dc47f6_fk_cliente_cli_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia_evento
    ADD CONSTRAINT asistencia_evento_fk_cliente_d0dc47f6_fk_cliente_cli_id FOREIGN KEY (fk_cliente) REFERENCES public.cliente(cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5450 (class 2606 OID 23374)
-- Name: asistencia_evento asistencia_evento_fk_evento_4f0bf62d_fk_evento_eve_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia_evento
    ADD CONSTRAINT asistencia_evento_fk_evento_4f0bf62d_fk_evento_eve_id FOREIGN KEY (fk_evento) REFERENCES public.evento(eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5451 (class 2606 OID 23379)
-- Name: asistencia_evento asistencia_evento_fk_ven_bol_eve_fd72f073_fk_venta_bol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia_evento
    ADD CONSTRAINT asistencia_evento_fk_ven_bol_eve_fd72f073_fk_venta_bol FOREIGN KEY (fk_ven_bol_eve) REFERENCES public.venta_boleto_evento(ven_bol_eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5448 (class 2606 OID 23384)
-- Name: asistencia asistencia_fk_empleado_ad1a0f87_fk_empleado_emp_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT asistencia_fk_empleado_ad1a0f87_fk_empleado_emp_id FOREIGN KEY (fk_empleado) REFERENCES public.empleado(emp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5452 (class 2606 OID 23389)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5453 (class 2606 OID 23394)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5454 (class 2606 OID 23399)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5455 (class 2606 OID 23404)
-- Name: car_tip_cer car_tip_cer_fk_caracteristica_eb690ec0_fk_caracteristica_car_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_tip_cer
    ADD CONSTRAINT car_tip_cer_fk_caracteristica_eb690ec0_fk_caracteristica_car_id FOREIGN KEY (fk_caracteristica) REFERENCES public.caracteristica(car_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5456 (class 2606 OID 23409)
-- Name: car_tip_cer car_tip_cer_fk_tipo_cerveza_6206cb80_fk_tipo_cerveza_tip_cer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_tip_cer
    ADD CONSTRAINT car_tip_cer_fk_tipo_cerveza_6206cb80_fk_tipo_cerveza_tip_cer_id FOREIGN KEY (fk_tipo_cerveza) REFERENCES public.tipo_cerveza(tip_cer_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5457 (class 2606 OID 23414)
-- Name: cerv_car cerv_car_fk_caracteristica_fdfb8a58_fk_caracteristica_car_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cerv_car
    ADD CONSTRAINT cerv_car_fk_caracteristica_fdfb8a58_fk_caracteristica_car_id FOREIGN KEY (fk_caracteristica) REFERENCES public.caracteristica(car_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5458 (class 2606 OID 23419)
-- Name: cerv_car cerv_car_fk_cerveza_3e5952ac_fk_cerveza_cer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cerv_car
    ADD CONSTRAINT cerv_car_fk_cerveza_3e5952ac_fk_cerveza_cer_id FOREIGN KEY (fk_cerveza) REFERENCES public.cerveza(cer_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5459 (class 2606 OID 23424)
-- Name: cerveza cerveza_fk_tipo_estilo_cerve_83d8a42a_fk_tipo_esti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cerveza
    ADD CONSTRAINT cerveza_fk_tipo_estilo_cerve_83d8a42a_fk_tipo_esti FOREIGN KEY (fk_tipo_estilo_cerveza) REFERENCES public.tipo_estilo_cerveza(tip_est_cer_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5460 (class 2606 OID 23429)
-- Name: cliente cliente_fk_lugar_d10f46fc_fk_lugar_lug_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_fk_lugar_d10f46fc_fk_lugar_lug_id FOREIGN KEY (fk_lugar) REFERENCES public.lugar(lug_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5461 (class 2606 OID 23434)
-- Name: contacto_cliente contacto_cliente_fk_cliente_d6d1ddfb_fk_cliente_cli_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacto_cliente
    ADD CONSTRAINT contacto_cliente_fk_cliente_d6d1ddfb_fk_cliente_cli_id FOREIGN KEY (fk_cliente) REFERENCES public.cliente(cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5462 (class 2606 OID 23439)
-- Name: contacto_proveedor contacto_proveedor_fk_proveedor_bec82efc_fk_proveedor_pro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacto_proveedor
    ADD CONSTRAINT contacto_proveedor_fk_proveedor_bec82efc_fk_proveedor_pro_id FOREIGN KEY (fk_proveedor) REFERENCES public.proveedor(pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5463 (class 2606 OID 23444)
-- Name: correo_electronico correo_electronico_fk_cliente_1675eca8_fk_cliente_cli_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.correo_electronico
    ADD CONSTRAINT correo_electronico_fk_cliente_1675eca8_fk_cliente_cli_id FOREIGN KEY (fk_cliente) REFERENCES public.cliente(cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5464 (class 2606 OID 23449)
-- Name: correo_electronico correo_electronico_fk_contacto_cliente_3a44c8ea_fk_contacto_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.correo_electronico
    ADD CONSTRAINT correo_electronico_fk_contacto_cliente_3a44c8ea_fk_contacto_ FOREIGN KEY (fk_contacto_cliente) REFERENCES public.contacto_cliente(con_cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5465 (class 2606 OID 23454)
-- Name: correo_electronico correo_electronico_fk_contacto_proveedo_232a81da_fk_contacto_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.correo_electronico
    ADD CONSTRAINT correo_electronico_fk_contacto_proveedo_232a81da_fk_contacto_ FOREIGN KEY (fk_contacto_proveedor) REFERENCES public.contacto_proveedor(con_pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5466 (class 2606 OID 23459)
-- Name: correo_electronico correo_electronico_fk_empleado_9dd767b3_fk_empleado_emp_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.correo_electronico
    ADD CONSTRAINT correo_electronico_fk_empleado_9dd767b3_fk_empleado_emp_id FOREIGN KEY (fk_empleado) REFERENCES public.empleado(emp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5467 (class 2606 OID 23464)
-- Name: correo_electronico correo_electronico_fk_proveedor_cfa4325b_fk_proveedor_pro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.correo_electronico
    ADD CONSTRAINT correo_electronico_fk_proveedor_cfa4325b_fk_proveedor_pro_id FOREIGN KEY (fk_proveedor) REFERENCES public.proveedor(pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5468 (class 2606 OID 23469)
-- Name: cuenta_punto cuenta_punto_fk_cliente_8a672568_fk_cliente_cli_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta_punto
    ADD CONSTRAINT cuenta_punto_fk_cliente_8a672568_fk_cliente_cli_id FOREIGN KEY (fk_cliente) REFERENCES public.cliente(cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5469 (class 2606 OID 23474)
-- Name: dep_tie dep_tie_fk_departamento_b29b24bf_fk_departamento_dep_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dep_tie
    ADD CONSTRAINT dep_tie_fk_departamento_b29b24bf_fk_departamento_dep_id FOREIGN KEY (fk_departamento) REFERENCES public.departamento(dep_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5470 (class 2606 OID 23479)
-- Name: dep_tie dep_tie_fk_tienda_8f8c75d7_fk_tienda_tie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dep_tie
    ADD CONSTRAINT dep_tie_fk_tienda_8f8c75d7_fk_tienda_tie_id FOREIGN KEY (fk_tienda) REFERENCES public.tienda(tie_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5471 (class 2606 OID 23484)
-- Name: detalle_compra detalle_compra_fk_presentacion_7fb10ea0_fk_presentac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_fk_presentacion_7fb10ea0_fk_presentac FOREIGN KEY (fk_presentacion) REFERENCES public.presentacion(prese_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5472 (class 2606 OID 23489)
-- Name: detalle_compra detalle_compra_fk_sol_com_217351a2_fk_solicitud; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_fk_sol_com_217351a2_fk_solicitud FOREIGN KEY (fk_sol_com) REFERENCES public.solicitud_compra(sol_com_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5473 (class 2606 OID 23494)
-- Name: detalle_venta_evento detalle_venta_evento_fk_exi_eve_ad5084b0_fk_existenci; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_evento
    ADD CONSTRAINT detalle_venta_evento_fk_exi_eve_ad5084b0_fk_existenci FOREIGN KEY (fk_exi_eve) REFERENCES public.existencia_evento(exi_eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5474 (class 2606 OID 23499)
-- Name: detalle_venta_evento detalle_venta_evento_fk_venta_evento_3071707e_fk_venta_eve; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_evento
    ADD CONSTRAINT detalle_venta_evento_fk_venta_evento_3071707e_fk_venta_eve FOREIGN KEY (fk_venta_evento) REFERENCES public.venta_evento(ven_eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5475 (class 2606 OID 23504)
-- Name: detalle_venta_fisica detalle_venta_fisica_fk_inventario_05904a18_fk_inventari; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_fisica
    ADD CONSTRAINT detalle_venta_fisica_fk_inventario_05904a18_fk_inventari FOREIGN KEY (fk_inventario) REFERENCES public.inventario(inv_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5476 (class 2606 OID 23509)
-- Name: detalle_venta_fisica detalle_venta_fisica_fk_venta_fisica_21f2bec4_fk_venta_fis; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_fisica
    ADD CONSTRAINT detalle_venta_fisica_fk_venta_fisica_21f2bec4_fk_venta_fis FOREIGN KEY (fk_venta_fisica) REFERENCES public.venta_fisica(ven_fis_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5477 (class 2606 OID 23514)
-- Name: detalle_venta_online detalle_venta_online_fk_pre_alm_96592db4_fk_pre_alm_pre_alm_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_online
    ADD CONSTRAINT detalle_venta_online_fk_pre_alm_96592db4_fk_pre_alm_pre_alm_id FOREIGN KEY (fk_pre_alm) REFERENCES public.pre_alm(pre_alm_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5478 (class 2606 OID 23519)
-- Name: detalle_venta_online detalle_venta_online_fk_venta_online_a472f874_fk_venta_onl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta_online
    ADD CONSTRAINT detalle_venta_online_fk_venta_online_a472f874_fk_venta_onl FOREIGN KEY (fk_venta_online) REFERENCES public.venta_online(ven_onl_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5479 (class 2606 OID 23524)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5480 (class 2606 OID 23529)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_usuario_id FOREIGN KEY (user_id) REFERENCES public.usuario(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5481 (class 2606 OID 23534)
-- Name: emp_car emp_car_fk_cargo_0bf0fe73_fk_cargo_car_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car
    ADD CONSTRAINT emp_car_fk_cargo_0bf0fe73_fk_cargo_car_id FOREIGN KEY (fk_cargo) REFERENCES public.cargo(car_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5482 (class 2606 OID 23539)
-- Name: emp_car emp_car_fk_empleado_60df61f4_fk_empleado_emp_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car
    ADD CONSTRAINT emp_car_fk_empleado_60df61f4_fk_empleado_emp_id FOREIGN KEY (fk_empleado) REFERENCES public.empleado(emp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5483 (class 2606 OID 23544)
-- Name: emp_car_hor emp_car_hor_fk_cargo_5f5dacf9_fk_cargo_car_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car_hor
    ADD CONSTRAINT emp_car_hor_fk_cargo_5f5dacf9_fk_cargo_car_id FOREIGN KEY (fk_cargo) REFERENCES public.cargo(car_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5484 (class 2606 OID 23549)
-- Name: emp_car_hor emp_car_hor_fk_departamento_d475f135_fk_departamento_dep_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car_hor
    ADD CONSTRAINT emp_car_hor_fk_departamento_d475f135_fk_departamento_dep_id FOREIGN KEY (fk_departamento) REFERENCES public.departamento(dep_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5485 (class 2606 OID 23554)
-- Name: emp_car_hor emp_car_hor_fk_empleado_5d35073d_fk_empleado_emp_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car_hor
    ADD CONSTRAINT emp_car_hor_fk_empleado_5d35073d_fk_empleado_emp_id FOREIGN KEY (fk_empleado) REFERENCES public.empleado(emp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5486 (class 2606 OID 23559)
-- Name: emp_car_hor emp_car_hor_fk_horario_fb352a17_fk_horario_hor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car_hor
    ADD CONSTRAINT emp_car_hor_fk_horario_fb352a17_fk_horario_hor_id FOREIGN KEY (fk_horario) REFERENCES public.horario(hor_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5487 (class 2606 OID 23564)
-- Name: emp_car_hor emp_car_hor_fk_tienda_3fc5172f_fk_tienda_tie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_car_hor
    ADD CONSTRAINT emp_car_hor_fk_tienda_3fc5172f_fk_tienda_tie_id FOREIGN KEY (fk_tienda) REFERENCES public.tienda(tie_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5488 (class 2606 OID 23569)
-- Name: emp_tip_ben emp_tip_ben_fk_empleado_6458ef81_fk_empleado_emp_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_tip_ben
    ADD CONSTRAINT emp_tip_ben_fk_empleado_6458ef81_fk_empleado_emp_id FOREIGN KEY (fk_empleado) REFERENCES public.empleado(emp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5489 (class 2606 OID 23574)
-- Name: emp_tip_ben emp_tip_ben_fk_tipo_beneficio_ae383219_fk_tipo_bene; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_tip_ben
    ADD CONSTRAINT emp_tip_ben_fk_tipo_beneficio_ae383219_fk_tipo_bene FOREIGN KEY (fk_tipo_beneficio) REFERENCES public.tipo_beneficio(tip_ben_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5490 (class 2606 OID 23579)
-- Name: empleado empleado_fk_lugar_68df3593_fk_lugar_lug_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_fk_lugar_68df3593_fk_lugar_lug_id FOREIGN KEY (fk_lugar) REFERENCES public.lugar(lug_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5491 (class 2606 OID 23584)
-- Name: eve_pro eve_pro_fk_evento_e275f857_fk_evento_eve_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eve_pro
    ADD CONSTRAINT eve_pro_fk_evento_e275f857_fk_evento_eve_id FOREIGN KEY (fk_evento) REFERENCES public.evento(eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5492 (class 2606 OID 23589)
-- Name: eve_pro eve_pro_fk_proveedor_f7e10495_fk_proveedor_pro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eve_pro
    ADD CONSTRAINT eve_pro_fk_proveedor_f7e10495_fk_proveedor_pro_id FOREIGN KEY (fk_proveedor) REFERENCES public.proveedor(pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5493 (class 2606 OID 23594)
-- Name: evento evento_fk_lugar_7051b684_fk_lugar_lug_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT evento_fk_lugar_7051b684_fk_lugar_lug_id FOREIGN KEY (fk_lugar) REFERENCES public.lugar(lug_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5494 (class 2606 OID 23599)
-- Name: evento evento_fk_tip_eve_c60c530e_fk_tipo_evento_tip_eve_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT evento_fk_tip_eve_c60c530e_fk_tipo_evento_tip_eve_id FOREIGN KEY (fk_tip_eve) REFERENCES public.tipo_evento(tip_eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5495 (class 2606 OID 23604)
-- Name: existencia_evento existencia_evento_fk_evento_proveedor_3ddb7e7f_fk_eve_pro_e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.existencia_evento
    ADD CONSTRAINT existencia_evento_fk_evento_proveedor_3ddb7e7f_fk_eve_pro_e FOREIGN KEY (fk_evento_proveedor) REFERENCES public.eve_pro(eve_pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5496 (class 2606 OID 23609)
-- Name: existencia_evento existencia_evento_fk_presentacion_d7307eef_fk_presentac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.existencia_evento
    ADD CONSTRAINT existencia_evento_fk_presentacion_d7307eef_fk_presentac FOREIGN KEY (fk_presentacion) REFERENCES public.presentacion(prese_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5497 (class 2606 OID 23614)
-- Name: historico_moneda historico_moneda_fk_moneda_f7a8a024_fk_moneda_mon_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_moneda
    ADD CONSTRAINT historico_moneda_fk_moneda_f7a8a024_fk_moneda_mon_id FOREIGN KEY (fk_moneda) REFERENCES public.moneda(mon_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5498 (class 2606 OID 23619)
-- Name: inventario inventario_fk_anaquel_340a6257_fk_anaquel_ana_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_fk_anaquel_340a6257_fk_anaquel_ana_id FOREIGN KEY (fk_anaquel) REFERENCES public.anaquel(ana_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5499 (class 2606 OID 23624)
-- Name: inventario inventario_fk_oferta_e57cd75c_fk_oferta_ofe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_fk_oferta_e57cd75c_fk_oferta_ofe_id FOREIGN KEY (fk_oferta) REFERENCES public.oferta(ofe_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5500 (class 2606 OID 23629)
-- Name: inventario inventario_fk_presentacion_b292e310_fk_presentacion_prese_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_fk_presentacion_b292e310_fk_presentacion_prese_id FOREIGN KEY (fk_presentacion) REFERENCES public.presentacion(prese_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5501 (class 2606 OID 23634)
-- Name: lugar lugar_fk_lugar_c34c3bbf_fk_lugar_lug_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lugar
    ADD CONSTRAINT lugar_fk_lugar_c34c3bbf_fk_lugar_lug_id FOREIGN KEY (fk_lugar) REFERENCES public.lugar(lug_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5502 (class 2606 OID 23639)
-- Name: lugar_tienda lugar_tienda_fk_lugar_tienda_fabc654c_fk_lugar_lug_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lugar_tienda
    ADD CONSTRAINT lugar_tienda_fk_lugar_tienda_fabc654c_fk_lugar_lug_id FOREIGN KEY (fk_lugar_tienda) REFERENCES public.lugar(lug_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5503 (class 2606 OID 23644)
-- Name: lugar_tienda lugar_tienda_fk_tienda_1b0e37d3_fk_tienda_tie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lugar_tienda
    ADD CONSTRAINT lugar_tienda_fk_tienda_1b0e37d3_fk_tienda_tie_id FOREIGN KEY (fk_tienda) REFERENCES public.tienda(tie_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5504 (class 2606 OID 23649)
-- Name: metodo_pago metodo_pago_fk_his_pre_pun_ba04b391_fk_historico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodo_pago
    ADD CONSTRAINT metodo_pago_fk_his_pre_pun_ba04b391_fk_historico FOREIGN KEY (fk_his_pre_pun) REFERENCES public.historico_precio_punto(his_pre_pun_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5505 (class 2606 OID 23654)
-- Name: metodo_pago metodo_pago_fk_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodo_pago
    ADD CONSTRAINT metodo_pago_fk_usuario FOREIGN KEY (fk_usuario) REFERENCES public.usuario(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5512 (class 2606 OID 23659)
-- Name: pago_efectivo pago_efectivo_fk_metodo_pago_5cfe4bc4_fk_metodo_pago_met_pag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago_efectivo
    ADD CONSTRAINT pago_efectivo_fk_metodo_pago_5cfe4bc4_fk_metodo_pago_met_pag_id FOREIGN KEY (fk_metodo_pago) REFERENCES public.metodo_pago(met_pag_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5506 (class 2606 OID 23664)
-- Name: pago pago_fk_afiliacion_5599c377_fk_afiliacion_afi_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_fk_afiliacion_5599c377_fk_afiliacion_afi_id FOREIGN KEY (fk_afiliacion) REFERENCES public.afiliacion(afi_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5507 (class 2606 OID 23669)
-- Name: pago pago_fk_metodo_pago_958fa9c8_fk_metodo_pago_met_pag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_fk_metodo_pago_958fa9c8_fk_metodo_pago_met_pag_id FOREIGN KEY (fk_metodo_pago) REFERENCES public.metodo_pago(met_pag_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5508 (class 2606 OID 23674)
-- Name: pago pago_fk_moneda_2704d165_fk_moneda_mon_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_fk_moneda_2704d165_fk_moneda_mon_id FOREIGN KEY (fk_moneda) REFERENCES public.moneda(mon_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5509 (class 2606 OID 23679)
-- Name: pago pago_fk_venta_evento_4bddf9fa_fk_venta_evento_ven_eve_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_fk_venta_evento_4bddf9fa_fk_venta_evento_ven_eve_id FOREIGN KEY (fk_venta_evento) REFERENCES public.venta_evento(ven_eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5510 (class 2606 OID 23684)
-- Name: pago pago_fk_venta_fisica_f58df627_fk_venta_fisica_ven_fis_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_fk_venta_fisica_f58df627_fk_venta_fisica_ven_fis_id FOREIGN KEY (fk_venta_fisica) REFERENCES public.venta_fisica(ven_fis_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5511 (class 2606 OID 23689)
-- Name: pago pago_fk_venta_online_4161ef78_fk_venta_online_ven_onl_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_fk_venta_online_4161ef78_fk_venta_online_ven_onl_id FOREIGN KEY (fk_venta_online) REFERENCES public.venta_online(ven_onl_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5513 (class 2606 OID 23694)
-- Name: pre_alm pre_alm_fk_almacen_58bc2a80_fk_almacen_alm_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_alm
    ADD CONSTRAINT pre_alm_fk_almacen_58bc2a80_fk_almacen_alm_id FOREIGN KEY (fk_almacen) REFERENCES public.almacen(alm_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5514 (class 2606 OID 23699)
-- Name: pre_alm pre_alm_fk_oferta_310e972d_fk_oferta_ofe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_alm
    ADD CONSTRAINT pre_alm_fk_oferta_310e972d_fk_oferta_ofe_id FOREIGN KEY (fk_oferta) REFERENCES public.oferta(ofe_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5515 (class 2606 OID 23704)
-- Name: pre_alm pre_alm_fk_presentacion_5791ab49_fk_presentacion_prese_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pre_alm
    ADD CONSTRAINT pre_alm_fk_presentacion_5791ab49_fk_presentacion_prese_id FOREIGN KEY (fk_presentacion) REFERENCES public.presentacion(prese_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5516 (class 2606 OID 23709)
-- Name: presentacion presentacion_fk_cerveza_fdd3f59d_fk_cerveza_cer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presentacion
    ADD CONSTRAINT presentacion_fk_cerveza_fdd3f59d_fk_cerveza_cer_id FOREIGN KEY (fk_cerveza) REFERENCES public.cerveza(cer_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5517 (class 2606 OID 23714)
-- Name: proveedor proveedor_fk_lugar_7459b24b_fk_lugar_lug_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_fk_lugar_7459b24b_fk_lugar_lug_id FOREIGN KEY (fk_lugar) REFERENCES public.lugar(lug_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5518 (class 2606 OID 23719)
-- Name: rec_ing rec_ing_fk_ingrediente_1752b53d_fk_ingrediente_ing_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rec_ing
    ADD CONSTRAINT rec_ing_fk_ingrediente_1752b53d_fk_ingrediente_ing_id FOREIGN KEY (fk_ingrediente) REFERENCES public.ingrediente(ing_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5519 (class 2606 OID 23724)
-- Name: rec_ing rec_ing_fk_receta_eb1aef13_fk_receta_rec_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rec_ing
    ADD CONSTRAINT rec_ing_fk_receta_eb1aef13_fk_receta_rec_id FOREIGN KEY (fk_receta) REFERENCES public.receta(rec_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5520 (class 2606 OID 23729)
-- Name: rec_ins rec_ins_fk_instruccion_5749ecf7_fk_instruccion_ins_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rec_ins
    ADD CONSTRAINT rec_ins_fk_instruccion_5749ecf7_fk_instruccion_ins_id FOREIGN KEY (fk_instruccion) REFERENCES public.instruccion(ins_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5521 (class 2606 OID 23734)
-- Name: rec_ins rec_ins_fk_receta_775a9e30_fk_receta_rec_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rec_ins
    ADD CONSTRAINT rec_ins_fk_receta_775a9e30_fk_receta_rec_id FOREIGN KEY (fk_receta) REFERENCES public.receta(rec_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5560 (class 2606 OID 24018)
-- Name: rol_privilegio rol_privilegio_fk_privilegio_dea72104_fk_privilegi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_privilegio
    ADD CONSTRAINT rol_privilegio_fk_privilegio_dea72104_fk_privilegi FOREIGN KEY (fk_privilegio) REFERENCES public.privilegio(privilegio_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5561 (class 2606 OID 24023)
-- Name: rol_privilegio rol_privilegio_fk_rol_723d6077_fk_rol_rol_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_privilegio
    ADD CONSTRAINT rol_privilegio_fk_rol_723d6077_fk_rol_rol_id FOREIGN KEY (fk_rol) REFERENCES public.rol(rol_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5522 (class 2606 OID 23739)
-- Name: sol_com_est sol_com_est_fk_estatus_3f65e504_fk_estatus_est_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sol_com_est
    ADD CONSTRAINT sol_com_est_fk_estatus_3f65e504_fk_estatus_est_id FOREIGN KEY (fk_estatus) REFERENCES public.estatus(est_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5523 (class 2606 OID 23744)
-- Name: sol_com_est sol_com_est_fk_sol_com_c02697c4_fk_solicitud_compra_sol_com_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sol_com_est
    ADD CONSTRAINT sol_com_est_fk_sol_com_c02697c4_fk_solicitud_compra_sol_com_id FOREIGN KEY (fk_sol_com) REFERENCES public.solicitud_compra(sol_com_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5524 (class 2606 OID 23749)
-- Name: sol_rep_est sol_rep_est_fk_estatus_400f4a62_fk_estatus_est_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sol_rep_est
    ADD CONSTRAINT sol_rep_est_fk_estatus_400f4a62_fk_estatus_est_id FOREIGN KEY (fk_estatus) REFERENCES public.estatus(est_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5525 (class 2606 OID 23754)
-- Name: sol_rep_est sol_rep_est_fk_sol_rep_5131a8fa_fk_solicitud; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sol_rep_est
    ADD CONSTRAINT sol_rep_est_fk_sol_rep_5131a8fa_fk_solicitud FOREIGN KEY (fk_sol_rep) REFERENCES public.solicitud_reposicion(sol_rep_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5526 (class 2606 OID 23759)
-- Name: solicitud_compra solicitud_compra_fk_pre_alm_9c5c5847_fk_pre_alm_pre_alm_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_compra
    ADD CONSTRAINT solicitud_compra_fk_pre_alm_9c5c5847_fk_pre_alm_pre_alm_id FOREIGN KEY (fk_pre_alm) REFERENCES public.pre_alm(pre_alm_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5527 (class 2606 OID 23764)
-- Name: solicitud_compra solicitud_compra_fk_proveedor_682536fa_fk_proveedor_pro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_compra
    ADD CONSTRAINT solicitud_compra_fk_proveedor_682536fa_fk_proveedor_pro_id FOREIGN KEY (fk_proveedor) REFERENCES public.proveedor(pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5528 (class 2606 OID 23769)
-- Name: solicitud_compra solicitud_compra_fk_usuario_4a71efc5_fk_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_compra
    ADD CONSTRAINT solicitud_compra_fk_usuario_4a71efc5_fk_usuario_id FOREIGN KEY (fk_usuario) REFERENCES public.usuario(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5529 (class 2606 OID 23774)
-- Name: solicitud_reposicion solicitud_reposicion_fk_inv_755d3938_fk_inventario_inv_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_reposicion
    ADD CONSTRAINT solicitud_reposicion_fk_inv_755d3938_fk_inventario_inv_id FOREIGN KEY (fk_inv) REFERENCES public.inventario(inv_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5530 (class 2606 OID 23779)
-- Name: solicitud_reposicion solicitud_reposicion_fk_pre_alm_a29cf191_fk_pre_alm_pre_alm_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_reposicion
    ADD CONSTRAINT solicitud_reposicion_fk_pre_alm_a29cf191_fk_pre_alm_pre_alm_id FOREIGN KEY (fk_pre_alm) REFERENCES public.pre_alm(pre_alm_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5531 (class 2606 OID 23784)
-- Name: solicitud_reposicion solicitud_reposicion_fk_usuario_55e4cc27_fk_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitud_reposicion
    ADD CONSTRAINT solicitud_reposicion_fk_usuario_55e4cc27_fk_usuario_id FOREIGN KEY (fk_usuario) REFERENCES public.usuario(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5532 (class 2606 OID 23789)
-- Name: telefono telefono_fk_cliente_b85c99d6_fk_cliente_cli_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_fk_cliente_b85c99d6_fk_cliente_cli_id FOREIGN KEY (fk_cliente) REFERENCES public.cliente(cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5533 (class 2606 OID 23794)
-- Name: telefono telefono_fk_contacto_cliente_6bc5ba62_fk_contacto_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_fk_contacto_cliente_6bc5ba62_fk_contacto_ FOREIGN KEY (fk_contacto_cliente) REFERENCES public.contacto_cliente(con_cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5534 (class 2606 OID 23799)
-- Name: telefono telefono_fk_contacto_proveedo_853fc0fc_fk_contacto_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_fk_contacto_proveedo_853fc0fc_fk_contacto_ FOREIGN KEY (fk_contacto_proveedor) REFERENCES public.contacto_proveedor(con_pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5535 (class 2606 OID 23804)
-- Name: telefono telefono_fk_empleado_218ece5a_fk_empleado_emp_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_fk_empleado_218ece5a_fk_empleado_emp_id FOREIGN KEY (fk_empleado) REFERENCES public.empleado(emp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5536 (class 2606 OID 23809)
-- Name: telefono telefono_fk_proveedor_e45ba6be_fk_proveedor_pro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_fk_proveedor_e45ba6be_fk_proveedor_pro_id FOREIGN KEY (fk_proveedor) REFERENCES public.proveedor(pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5537 (class 2606 OID 23814)
-- Name: tienda tienda_fk_lugar_a63cb22a_fk_lugar_lug_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tienda
    ADD CONSTRAINT tienda_fk_lugar_a63cb22a_fk_lugar_lug_id FOREIGN KEY (fk_lugar) REFERENCES public.lugar(lug_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5538 (class 2606 OID 23819)
-- Name: tipo_estilo_cerveza tipo_estilo_cerveza_fk_estilo_cerveza_6891c74a_fk_estilo_ce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_estilo_cerveza
    ADD CONSTRAINT tipo_estilo_cerveza_fk_estilo_cerveza_6891c74a_fk_estilo_ce FOREIGN KEY (fk_estilo_cerveza) REFERENCES public.estilo_cerveza(est_cer_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5539 (class 2606 OID 23824)
-- Name: tipo_estilo_cerveza tipo_estilo_cerveza_fk_tipo_cerveza_ed8d1c70_fk_tipo_cerv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_estilo_cerveza
    ADD CONSTRAINT tipo_estilo_cerveza_fk_tipo_cerveza_ed8d1c70_fk_tipo_cerv FOREIGN KEY (fk_tipo_cerveza) REFERENCES public.tipo_cerveza(tip_cer_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5540 (class 2606 OID 23829)
-- Name: tipo_evento tipo_evento_fk_tipo_evento_64e19139_fk_tipo_evento_tip_eve_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_evento
    ADD CONSTRAINT tipo_evento_fk_tipo_evento_64e19139_fk_tipo_evento_tip_eve_id FOREIGN KEY (fk_tipo_evento) REFERENCES public.tipo_evento(tip_eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5541 (class 2606 OID 23834)
-- Name: usuario usuario_fk_cliente_4ae4519a_fk_cliente_cli_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_fk_cliente_4ae4519a_fk_cliente_cli_id FOREIGN KEY (fk_cliente) REFERENCES public.cliente(cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5542 (class 2606 OID 23839)
-- Name: usuario usuario_fk_emp_car_4ae4519a_fk_empleado_emp_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_fk_emp_car_4ae4519a_fk_empleado_emp_id FOREIGN KEY (fk_emp_car) REFERENCES public.emp_car(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5543 (class 2606 OID 23844)
-- Name: usuario usuario_fk_proveedor_9b4f82fb_fk_proveedor_pro_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_fk_proveedor_9b4f82fb_fk_proveedor_pro_id FOREIGN KEY (fk_proveedor) REFERENCES public.proveedor(pro_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5544 (class 2606 OID 24002)
-- Name: usuario usuario_fk_rol_e0faaaac_fk_rol_rol_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_fk_rol_e0faaaac_fk_rol_rol_id FOREIGN KEY (fk_rol) REFERENCES public.rol(rol_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5545 (class 2606 OID 23849)
-- Name: usuario_groups usuario_groups_group_id_c67c8651_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_groups
    ADD CONSTRAINT usuario_groups_group_id_c67c8651_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5546 (class 2606 OID 23854)
-- Name: usuario_groups usuario_groups_usuario_id_161fc80c_fk_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_groups
    ADD CONSTRAINT usuario_groups_usuario_id_161fc80c_fk_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5547 (class 2606 OID 23859)
-- Name: usuario_user_permissions usuario_user_permiss_permission_id_a8893ce7_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_user_permissions
    ADD CONSTRAINT usuario_user_permiss_permission_id_a8893ce7_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5548 (class 2606 OID 23864)
-- Name: usuario_user_permissions usuario_user_permissions_usuario_id_693d9c50_fk_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_user_permissions
    ADD CONSTRAINT usuario_user_permissions_usuario_id_693d9c50_fk_usuario_id FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5549 (class 2606 OID 23869)
-- Name: vacacion vacacion_fk_empleado_cb6959b7_fk_empleado_emp_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacacion
    ADD CONSTRAINT vacacion_fk_empleado_cb6959b7_fk_empleado_emp_id FOREIGN KEY (fk_empleado) REFERENCES public.empleado(emp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5550 (class 2606 OID 23874)
-- Name: ven_onl_est ven_onl_est_fk_estatus_2d259dbd_fk_estatus_est_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_onl_est
    ADD CONSTRAINT ven_onl_est_fk_estatus_2d259dbd_fk_estatus_est_id FOREIGN KEY (fk_estatus) REFERENCES public.estatus(est_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5551 (class 2606 OID 23879)
-- Name: ven_onl_est ven_onl_est_fk_venta_online_a6c34bae_fk_venta_online_ven_onl_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ven_onl_est
    ADD CONSTRAINT ven_onl_est_fk_venta_online_a6c34bae_fk_venta_online_ven_onl_id FOREIGN KEY (fk_venta_online) REFERENCES public.venta_online(ven_onl_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5552 (class 2606 OID 23884)
-- Name: venta_evento venta_evento_fk_cliente_1a772f9f_fk_cliente_cli_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_evento
    ADD CONSTRAINT venta_evento_fk_cliente_1a772f9f_fk_cliente_cli_id FOREIGN KEY (fk_cliente) REFERENCES public.cliente(cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5553 (class 2606 OID 23889)
-- Name: venta_evento venta_evento_fk_evento_259febf5_fk_evento_eve_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_evento
    ADD CONSTRAINT venta_evento_fk_evento_259febf5_fk_evento_eve_id FOREIGN KEY (fk_evento) REFERENCES public.evento(eve_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5554 (class 2606 OID 23894)
-- Name: venta_fisica venta_fisica_fk_cliente_6695bafa_fk_cliente_cli_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_fisica
    ADD CONSTRAINT venta_fisica_fk_cliente_6695bafa_fk_cliente_cli_id FOREIGN KEY (fk_cliente) REFERENCES public.cliente(cli_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5555 (class 2606 OID 23899)
-- Name: venta_fisica venta_fisica_fk_oferta_4e836443_fk_oferta_ofe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_fisica
    ADD CONSTRAINT venta_fisica_fk_oferta_4e836443_fk_oferta_ofe_id FOREIGN KEY (fk_oferta) REFERENCES public.oferta(ofe_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5556 (class 2606 OID 23904)
-- Name: venta_fisica venta_fisica_fk_tienda_68b386cf_fk_tienda_tie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_fisica
    ADD CONSTRAINT venta_fisica_fk_tienda_68b386cf_fk_tienda_tie_id FOREIGN KEY (fk_tienda) REFERENCES public.tienda(tie_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5557 (class 2606 OID 23909)
-- Name: venta_online venta_online_fk_oferta_ae68023f_fk_oferta_ofe_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_online
    ADD CONSTRAINT venta_online_fk_oferta_ae68023f_fk_oferta_ofe_id FOREIGN KEY (fk_oferta) REFERENCES public.oferta(ofe_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5558 (class 2606 OID 23914)
-- Name: venta_online venta_online_fk_tienda_2b45db66_fk_tienda_tie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_online
    ADD CONSTRAINT venta_online_fk_tienda_2b45db66_fk_tienda_tie_id FOREIGN KEY (fk_tienda) REFERENCES public.tienda(tie_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5559 (class 2606 OID 23919)
-- Name: venta_online venta_online_fk_usuario_ff559976_fk_usuario_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta_online
    ADD CONSTRAINT venta_online_fk_usuario_ff559976_fk_usuario_id FOREIGN KEY (fk_usuario) REFERENCES public.usuario(id) DEFERRABLE INITIALLY DEFERRED;


-- Completed on 2025-06-26 02:13:34

--
-- PostgreSQL database dump complete
--

