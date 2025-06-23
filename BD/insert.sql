--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

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
-- Data for Name: admin_interface_theme; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.admin_interface_theme VALUES (1, 'Django', true, 'Django administration', '#F5DD5D', true, '', '#FFFFFF', 400, 100, true, '', '', '#E74C3C', true, true, true, 'default-select', 'code', '#0C4B33', '#44B78B', '#FFFFFF', '#C9F0DD', '#44B78B', '#FFFFCC', '#FFFFFF', '#FFFFFF', '#FFFFFF', '#C9F0DD', true, '#0C3C26', '#156641', '#29B864', '#0C4B33', '#0C3C26', '#FFFFFF', '#BA2121', '#A41515', '#FFFFFF', true, '#000000', '0.3', true, true, true, true, true, false, true, false, false, false, true, false, true, true, false, false);


--
-- Data for Name: lugar; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lugar VALUES (1, 'Amazonas', 'estado', NULL);
INSERT INTO public.lugar VALUES (2, 'Anzoátegui', 'estado', NULL);
INSERT INTO public.lugar VALUES (3, 'Apure', 'estado', NULL);
INSERT INTO public.lugar VALUES (4, 'Aragua', 'estado', NULL);
INSERT INTO public.lugar VALUES (5, 'Barinas', 'estado', NULL);
INSERT INTO public.lugar VALUES (6, 'Bolívar', 'estado', NULL);
INSERT INTO public.lugar VALUES (7, 'Carabobo', 'estado', NULL);
INSERT INTO public.lugar VALUES (8, 'Cojedes', 'estado', NULL);
INSERT INTO public.lugar VALUES (9, 'Delta Amacuro', 'estado', NULL);
INSERT INTO public.lugar VALUES (10, 'Falcón', 'estado', NULL);
INSERT INTO public.lugar VALUES (11, 'Guárico', 'estado', NULL);
INSERT INTO public.lugar VALUES (12, 'Lara', 'estado', NULL);
INSERT INTO public.lugar VALUES (13, 'Mérida', 'estado', NULL);
INSERT INTO public.lugar VALUES (14, 'Miranda', 'estado', NULL);
INSERT INTO public.lugar VALUES (15, 'Monagas', 'estado', NULL);
INSERT INTO public.lugar VALUES (16, 'Nueva Esparta', 'estado', NULL);
INSERT INTO public.lugar VALUES (17, 'Portuguesa', 'estado', NULL);
INSERT INTO public.lugar VALUES (18, 'Sucre', 'estado', NULL);
INSERT INTO public.lugar VALUES (19, 'Táchira', 'estado', NULL);
INSERT INTO public.lugar VALUES (20, 'Trujillo', 'estado', NULL);
INSERT INTO public.lugar VALUES (21, 'Vargas', 'estado', NULL);
INSERT INTO public.lugar VALUES (22, 'Yaracuy', 'estado', NULL);
INSERT INTO public.lugar VALUES (23, 'Zulia', 'estado', NULL);
INSERT INTO public.lugar VALUES (24, 'Distrito Capital', 'estado', NULL);
INSERT INTO public.lugar VALUES (25, 'Dependencias Federales', 'estado', NULL);
INSERT INTO public.lugar VALUES (26, 'Alto Orinoco', 'municipio', 1);
INSERT INTO public.lugar VALUES (27, 'Atabapo', 'municipio', 1);
INSERT INTO public.lugar VALUES (28, 'Atures', 'municipio', 1);
INSERT INTO public.lugar VALUES (29, 'Autana', 'municipio', 1);
INSERT INTO public.lugar VALUES (30, 'Manapiare', 'municipio', 1);
INSERT INTO public.lugar VALUES (31, 'Maroa', 'municipio', 1);
INSERT INTO public.lugar VALUES (32, 'Río Negro', 'municipio', 1);
INSERT INTO public.lugar VALUES (33, 'Anaco', 'municipio', 2);
INSERT INTO public.lugar VALUES (34, 'Aragua', 'municipio', 2);
INSERT INTO public.lugar VALUES (35, 'Manuel Ezequiel Bruzual', 'municipio', 2);
INSERT INTO public.lugar VALUES (36, 'Diego Bautista Urbaneja', 'municipio', 2);
INSERT INTO public.lugar VALUES (37, 'Fernando Peñalver', 'municipio', 2);
INSERT INTO public.lugar VALUES (38, 'Francisco Del Carmen Carvajal', 'municipio', 2);
INSERT INTO public.lugar VALUES (39, 'General Sir Arthur McGregor', 'municipio', 2);
INSERT INTO public.lugar VALUES (40, 'Guanta', 'municipio', 2);
INSERT INTO public.lugar VALUES (41, 'Independencia', 'municipio', 2);
INSERT INTO public.lugar VALUES (42, 'José Gregorio Monagas', 'municipio', 2);
INSERT INTO public.lugar VALUES (43, 'Juan Antonio Sotillo', 'municipio', 2);
INSERT INTO public.lugar VALUES (44, 'Juan Manuel Cajigal', 'municipio', 2);
INSERT INTO public.lugar VALUES (45, 'Libertad', 'municipio', 2);
INSERT INTO public.lugar VALUES (46, 'Francisco de Miranda', 'municipio', 2);
INSERT INTO public.lugar VALUES (47, 'Pedro María Freites', 'municipio', 2);
INSERT INTO public.lugar VALUES (48, 'Píritu', 'municipio', 2);
INSERT INTO public.lugar VALUES (49, 'San José de Guanipa', 'municipio', 2);
INSERT INTO public.lugar VALUES (50, 'San Juan de Capistrano', 'municipio', 2);
INSERT INTO public.lugar VALUES (51, 'Santa Ana', 'municipio', 2);
INSERT INTO public.lugar VALUES (52, 'Simón Bolívar', 'municipio', 2);
INSERT INTO public.lugar VALUES (53, 'Simón Rodríguez', 'municipio', 2);
INSERT INTO public.lugar VALUES (54, 'Achaguas', 'municipio', 3);
INSERT INTO public.lugar VALUES (55, 'Biruaca', 'municipio', 3);
INSERT INTO public.lugar VALUES (56, 'Muñóz', 'municipio', 3);
INSERT INTO public.lugar VALUES (57, 'Páez', 'municipio', 3);
INSERT INTO public.lugar VALUES (58, 'Pedro Camejo', 'municipio', 3);
INSERT INTO public.lugar VALUES (59, 'Rómulo Gallegos', 'municipio', 3);
INSERT INTO public.lugar VALUES (60, 'San Fernando', 'municipio', 3);
INSERT INTO public.lugar VALUES (61, 'Atanasio Girardot', 'municipio', 4);
INSERT INTO public.lugar VALUES (62, 'Bolívar', 'municipio', 4);
INSERT INTO public.lugar VALUES (63, 'Camatagua', 'municipio', 4);
INSERT INTO public.lugar VALUES (64, 'Francisco Linares Alcántara', 'municipio', 4);
INSERT INTO public.lugar VALUES (65, 'José Ángel Lamas', 'municipio', 4);
INSERT INTO public.lugar VALUES (66, 'José Félix Ribas', 'municipio', 4);
INSERT INTO public.lugar VALUES (67, 'José Rafael Revenga', 'municipio', 4);
INSERT INTO public.lugar VALUES (68, 'Libertador', 'municipio', 4);
INSERT INTO public.lugar VALUES (69, 'Ocumare de la Costa de Oro', 'municipio', 4);
INSERT INTO public.lugar VALUES (70, 'San Casimiro', 'municipio', 4);
INSERT INTO public.lugar VALUES (71, 'Mario Briceño Iragorry', 'municipio', 4);
INSERT INTO public.lugar VALUES (72, 'San Sebastián', 'municipio', 4);
INSERT INTO public.lugar VALUES (73, 'Santiago Mariño', 'municipio', 4);
INSERT INTO public.lugar VALUES (74, 'Santos Michelena', 'municipio', 4);
INSERT INTO public.lugar VALUES (75, 'Sucre', 'municipio', 4);
INSERT INTO public.lugar VALUES (76, 'Tovar', 'municipio', 4);
INSERT INTO public.lugar VALUES (77, 'Urdaneta', 'municipio', 4);
INSERT INTO public.lugar VALUES (78, 'Zamora', 'municipio', 4);
INSERT INTO public.lugar VALUES (79, 'Alberto Arvelo Torrealba', 'municipio', 5);
INSERT INTO public.lugar VALUES (80, 'Andrés Eloy Blanco', 'municipio', 5);
INSERT INTO public.lugar VALUES (81, 'Antonio José de Sucre', 'municipio', 5);
INSERT INTO public.lugar VALUES (82, 'Arismendi', 'municipio', 5);
INSERT INTO public.lugar VALUES (83, 'Barinas', 'municipio', 5);
INSERT INTO public.lugar VALUES (84, 'Bolívar', 'municipio', 5);
INSERT INTO public.lugar VALUES (85, 'Cruz Paredes', 'municipio', 5);
INSERT INTO public.lugar VALUES (86, 'Ezequiel Zamora', 'municipio', 5);
INSERT INTO public.lugar VALUES (87, 'Obispos', 'municipio', 5);
INSERT INTO public.lugar VALUES (88, 'Pedraza', 'municipio', 5);
INSERT INTO public.lugar VALUES (89, 'Rojas', 'municipio', 5);
INSERT INTO public.lugar VALUES (90, 'Sosa', 'municipio', 5);
INSERT INTO public.lugar VALUES (91, 'Caroní', 'municipio', 6);
INSERT INTO public.lugar VALUES (92, 'Cedeño', 'municipio', 6);
INSERT INTO public.lugar VALUES (93, 'El Callao', 'municipio', 6);
INSERT INTO public.lugar VALUES (94, 'Gran Sabana', 'municipio', 6);
INSERT INTO public.lugar VALUES (95, 'Heres', 'municipio', 6);
INSERT INTO public.lugar VALUES (96, 'Piar', 'municipio', 6);
INSERT INTO public.lugar VALUES (97, 'Angostura (Raúl Leoni)', 'municipio', 6);
INSERT INTO public.lugar VALUES (98, 'Roscio', 'municipio', 6);
INSERT INTO public.lugar VALUES (99, 'Sifontes', 'municipio', 6);
INSERT INTO public.lugar VALUES (100, 'Sucre', 'municipio', 6);
INSERT INTO public.lugar VALUES (101, 'Padre Pedro Chien', 'municipio', 6);
INSERT INTO public.lugar VALUES (102, 'Bejuma', 'municipio', 7);
INSERT INTO public.lugar VALUES (103, 'Carlos Arvelo', 'municipio', 7);
INSERT INTO public.lugar VALUES (104, 'Diego Ibarra', 'municipio', 7);
INSERT INTO public.lugar VALUES (105, 'Guacara', 'municipio', 7);
INSERT INTO public.lugar VALUES (106, 'Juan José Mora', 'municipio', 7);
INSERT INTO public.lugar VALUES (107, 'Libertador', 'municipio', 7);
INSERT INTO public.lugar VALUES (108, 'Los Guayos', 'municipio', 7);
INSERT INTO public.lugar VALUES (109, 'Miranda', 'municipio', 7);
INSERT INTO public.lugar VALUES (110, 'Montalbán', 'municipio', 7);
INSERT INTO public.lugar VALUES (111, 'Naguanagua', 'municipio', 7);
INSERT INTO public.lugar VALUES (112, 'Puerto Cabello', 'municipio', 7);
INSERT INTO public.lugar VALUES (113, 'San Diego', 'municipio', 7);
INSERT INTO public.lugar VALUES (114, 'San Joaquín', 'municipio', 7);
INSERT INTO public.lugar VALUES (115, 'Valencia', 'municipio', 7);
INSERT INTO public.lugar VALUES (116, 'Anzoátegui', 'municipio', 8);
INSERT INTO public.lugar VALUES (117, 'Tinaquillo', 'municipio', 8);
INSERT INTO public.lugar VALUES (118, 'Girardot', 'municipio', 8);
INSERT INTO public.lugar VALUES (119, 'Lima Blanco', 'municipio', 8);
INSERT INTO public.lugar VALUES (120, 'Pao de San Juan Bautista', 'municipio', 8);
INSERT INTO public.lugar VALUES (121, 'Ricaurte', 'municipio', 8);
INSERT INTO public.lugar VALUES (122, 'Rómulo Gallegos', 'municipio', 8);
INSERT INTO public.lugar VALUES (123, 'San Carlos', 'municipio', 8);
INSERT INTO public.lugar VALUES (124, 'Tinaco', 'municipio', 8);
INSERT INTO public.lugar VALUES (125, 'Antonio Díaz', 'municipio', 9);
INSERT INTO public.lugar VALUES (126, 'Casacoima', 'municipio', 9);
INSERT INTO public.lugar VALUES (127, 'Pedernales', 'municipio', 9);
INSERT INTO public.lugar VALUES (128, 'Tucupita', 'municipio', 9);
INSERT INTO public.lugar VALUES (129, 'Acosta', 'municipio', 10);
INSERT INTO public.lugar VALUES (130, 'Bolívar', 'municipio', 10);
INSERT INTO public.lugar VALUES (131, 'Buchivacoa', 'municipio', 10);
INSERT INTO public.lugar VALUES (132, 'Cacique Manaure', 'municipio', 10);
INSERT INTO public.lugar VALUES (133, 'Carirubana', 'municipio', 10);
INSERT INTO public.lugar VALUES (134, 'Colina', 'municipio', 10);
INSERT INTO public.lugar VALUES (135, 'Dabajuro', 'municipio', 10);
INSERT INTO public.lugar VALUES (136, 'Democracia', 'municipio', 10);
INSERT INTO public.lugar VALUES (137, 'Falcón', 'municipio', 10);
INSERT INTO public.lugar VALUES (138, 'Federación', 'municipio', 10);
INSERT INTO public.lugar VALUES (139, 'Jacura', 'municipio', 10);
INSERT INTO public.lugar VALUES (140, 'José Laurencio Silva', 'municipio', 10);
INSERT INTO public.lugar VALUES (141, 'Los Taques', 'municipio', 10);
INSERT INTO public.lugar VALUES (142, 'Mauroa', 'municipio', 10);
INSERT INTO public.lugar VALUES (143, 'Miranda', 'municipio', 10);
INSERT INTO public.lugar VALUES (144, 'Monseñor Iturriza', 'municipio', 10);
INSERT INTO public.lugar VALUES (145, 'Palmasola', 'municipio', 10);
INSERT INTO public.lugar VALUES (146, 'Petit', 'municipio', 10);
INSERT INTO public.lugar VALUES (147, 'Píritu', 'municipio', 10);
INSERT INTO public.lugar VALUES (148, 'San Francisco', 'municipio', 10);
INSERT INTO public.lugar VALUES (149, 'Sucre', 'municipio', 10);
INSERT INTO public.lugar VALUES (150, 'Tocópero', 'municipio', 10);
INSERT INTO public.lugar VALUES (151, 'Unión', 'municipio', 10);
INSERT INTO public.lugar VALUES (152, 'Urumaco', 'municipio', 10);
INSERT INTO public.lugar VALUES (153, 'Zamora', 'municipio', 10);
INSERT INTO public.lugar VALUES (154, 'Camaguán', 'municipio', 11);
INSERT INTO public.lugar VALUES (155, 'Chaguaramas', 'municipio', 11);
INSERT INTO public.lugar VALUES (156, 'El Socorro', 'municipio', 11);
INSERT INTO public.lugar VALUES (157, 'José Félix Ribas', 'municipio', 11);
INSERT INTO public.lugar VALUES (158, 'José Tadeo Monagas', 'municipio', 11);
INSERT INTO public.lugar VALUES (159, 'Juan Germán Roscio', 'municipio', 11);
INSERT INTO public.lugar VALUES (160, 'Julián Mellado', 'municipio', 11);
INSERT INTO public.lugar VALUES (161, 'Las Mercedes', 'municipio', 11);
INSERT INTO public.lugar VALUES (162, 'Leonardo Infante', 'municipio', 11);
INSERT INTO public.lugar VALUES (163, 'Pedro Zaraza', 'municipio', 11);
INSERT INTO public.lugar VALUES (164, 'Ortíz', 'municipio', 11);
INSERT INTO public.lugar VALUES (165, 'San Gerónimo de Guayabal', 'municipio', 11);
INSERT INTO public.lugar VALUES (166, 'San José de Guaribe', 'municipio', 11);
INSERT INTO public.lugar VALUES (167, 'Santa María de Ipire', 'municipio', 11);
INSERT INTO public.lugar VALUES (168, 'Sebastián Francisco de Miranda', 'municipio', 11);
INSERT INTO public.lugar VALUES (169, 'Andrés Eloy Blanco', 'municipio', 12);
INSERT INTO public.lugar VALUES (170, 'Crespo', 'municipio', 12);
INSERT INTO public.lugar VALUES (171, 'Iribarren', 'municipio', 12);
INSERT INTO public.lugar VALUES (172, 'Jiménez', 'municipio', 12);
INSERT INTO public.lugar VALUES (173, 'Morán', 'municipio', 12);
INSERT INTO public.lugar VALUES (174, 'Palavecino', 'municipio', 12);
INSERT INTO public.lugar VALUES (175, 'Simón Planas', 'municipio', 12);
INSERT INTO public.lugar VALUES (176, 'Torres', 'municipio', 12);
INSERT INTO public.lugar VALUES (177, 'Urdaneta', 'municipio', 12);
INSERT INTO public.lugar VALUES (178, 'Alberto Adriani', 'municipio', 13);
INSERT INTO public.lugar VALUES (179, 'Andrés Bello', 'municipio', 13);
INSERT INTO public.lugar VALUES (180, 'Antonio Pinto Salinas', 'municipio', 13);
INSERT INTO public.lugar VALUES (181, 'Aricagua', 'municipio', 13);
INSERT INTO public.lugar VALUES (182, 'Arzobispo Chacón', 'municipio', 13);
INSERT INTO public.lugar VALUES (183, 'Campo Elías', 'municipio', 13);
INSERT INTO public.lugar VALUES (184, 'Caracciolo Parra Olmedo', 'municipio', 13);
INSERT INTO public.lugar VALUES (185, 'Cardenal Quintero', 'municipio', 13);
INSERT INTO public.lugar VALUES (186, 'Guaraque', 'municipio', 13);
INSERT INTO public.lugar VALUES (187, 'Julio César Salas', 'municipio', 13);
INSERT INTO public.lugar VALUES (188, 'Justo Briceño', 'municipio', 13);
INSERT INTO public.lugar VALUES (189, 'Libertador', 'municipio', 13);
INSERT INTO public.lugar VALUES (190, 'Miranda', 'municipio', 13);
INSERT INTO public.lugar VALUES (191, 'Obispo Ramos de Lora', 'municipio', 13);
INSERT INTO public.lugar VALUES (192, 'Padre Noguera', 'municipio', 13);
INSERT INTO public.lugar VALUES (193, 'Pueblo Llano', 'municipio', 13);
INSERT INTO public.lugar VALUES (194, 'Rangel', 'municipio', 13);
INSERT INTO public.lugar VALUES (195, 'Rivas Dávila', 'municipio', 13);
INSERT INTO public.lugar VALUES (196, 'Santos Marquina', 'municipio', 13);
INSERT INTO public.lugar VALUES (197, 'Sucre', 'municipio', 13);
INSERT INTO public.lugar VALUES (198, 'Tovar', 'municipio', 13);
INSERT INTO public.lugar VALUES (199, 'Tulio Febres Cordero', 'municipio', 13);
INSERT INTO public.lugar VALUES (200, 'Zea', 'municipio', 13);
INSERT INTO public.lugar VALUES (201, 'Acevedo', 'municipio', 14);
INSERT INTO public.lugar VALUES (202, 'Andrés Bello', 'municipio', 14);
INSERT INTO public.lugar VALUES (203, 'Baruta', 'municipio', 14);
INSERT INTO public.lugar VALUES (204, 'Brión', 'municipio', 14);
INSERT INTO public.lugar VALUES (205, 'Buroz', 'municipio', 14);
INSERT INTO public.lugar VALUES (206, 'Carrizal', 'municipio', 14);
INSERT INTO public.lugar VALUES (207, 'Chacao', 'municipio', 14);
INSERT INTO public.lugar VALUES (208, 'Cristóbal Rojas', 'municipio', 14);
INSERT INTO public.lugar VALUES (209, 'El Hatillo', 'municipio', 14);
INSERT INTO public.lugar VALUES (210, 'Guaicaipuro', 'municipio', 14);
INSERT INTO public.lugar VALUES (211, 'Independencia', 'municipio', 14);
INSERT INTO public.lugar VALUES (212, 'Lander', 'municipio', 14);
INSERT INTO public.lugar VALUES (213, 'Los Salias', 'municipio', 14);
INSERT INTO public.lugar VALUES (214, 'Páez', 'municipio', 14);
INSERT INTO public.lugar VALUES (215, 'Paz Castillo', 'municipio', 14);
INSERT INTO public.lugar VALUES (216, 'Pedro Gual', 'municipio', 14);
INSERT INTO public.lugar VALUES (217, 'Plaza', 'municipio', 14);
INSERT INTO public.lugar VALUES (218, 'Simón Bolívar', 'municipio', 14);
INSERT INTO public.lugar VALUES (219, 'Sucre', 'municipio', 14);
INSERT INTO public.lugar VALUES (220, 'Urdaneta', 'municipio', 14);
INSERT INTO public.lugar VALUES (221, 'Zamora', 'municipio', 14);
INSERT INTO public.lugar VALUES (222, 'Acosta', 'municipio', 15);
INSERT INTO public.lugar VALUES (223, 'Aguasay', 'municipio', 15);
INSERT INTO public.lugar VALUES (224, 'Bolívar', 'municipio', 15);
INSERT INTO public.lugar VALUES (225, 'Caripe', 'municipio', 15);
INSERT INTO public.lugar VALUES (226, 'Cedeño', 'municipio', 15);
INSERT INTO public.lugar VALUES (227, 'Ezequiel Zamora', 'municipio', 15);
INSERT INTO public.lugar VALUES (228, 'Libertador', 'municipio', 15);
INSERT INTO public.lugar VALUES (229, 'Maturín', 'municipio', 15);
INSERT INTO public.lugar VALUES (230, 'Piar', 'municipio', 15);
INSERT INTO public.lugar VALUES (231, 'Punceres', 'municipio', 15);
INSERT INTO public.lugar VALUES (232, 'Santa Bárbara', 'municipio', 15);
INSERT INTO public.lugar VALUES (233, 'Sotillo', 'municipio', 15);
INSERT INTO public.lugar VALUES (234, 'Uracoa', 'municipio', 15);
INSERT INTO public.lugar VALUES (235, 'Antolín del Campo', 'municipio', 16);
INSERT INTO public.lugar VALUES (236, 'Arismendi', 'municipio', 16);
INSERT INTO public.lugar VALUES (237, 'García', 'municipio', 16);
INSERT INTO public.lugar VALUES (238, 'Gómez', 'municipio', 16);
INSERT INTO public.lugar VALUES (239, 'Maneiro', 'municipio', 16);
INSERT INTO public.lugar VALUES (240, 'Marcano', 'municipio', 16);
INSERT INTO public.lugar VALUES (241, 'Mariño', 'municipio', 16);
INSERT INTO public.lugar VALUES (242, 'Península de Macanao', 'municipio', 16);
INSERT INTO public.lugar VALUES (243, 'Tubores', 'municipio', 16);
INSERT INTO public.lugar VALUES (244, 'Villalba', 'municipio', 16);
INSERT INTO public.lugar VALUES (245, 'Díaz', 'municipio', 16);
INSERT INTO public.lugar VALUES (246, 'Agua Blanca', 'municipio', 17);
INSERT INTO public.lugar VALUES (247, 'Araure', 'municipio', 17);
INSERT INTO public.lugar VALUES (248, 'Esteller', 'municipio', 17);
INSERT INTO public.lugar VALUES (249, 'Guanare', 'municipio', 17);
INSERT INTO public.lugar VALUES (250, 'Guanarito', 'municipio', 17);
INSERT INTO public.lugar VALUES (251, 'Monseñor José Vicente de Unda', 'municipio', 17);
INSERT INTO public.lugar VALUES (252, 'Ospino', 'municipio', 17);
INSERT INTO public.lugar VALUES (253, 'Páez', 'municipio', 17);
INSERT INTO public.lugar VALUES (254, 'Papelón', 'municipio', 17);
INSERT INTO public.lugar VALUES (255, 'San Genaro de Boconoíto', 'municipio', 17);
INSERT INTO public.lugar VALUES (256, 'San Rafael de Onoto', 'municipio', 17);
INSERT INTO public.lugar VALUES (257, 'Santa Rosalía', 'municipio', 17);
INSERT INTO public.lugar VALUES (258, 'Sucre', 'municipio', 17);
INSERT INTO public.lugar VALUES (259, 'Turén', 'municipio', 17);
INSERT INTO public.lugar VALUES (260, 'Andrés Eloy Blanco', 'municipio', 18);
INSERT INTO public.lugar VALUES (261, 'Andrés Mata', 'municipio', 18);
INSERT INTO public.lugar VALUES (262, 'Arismendi', 'municipio', 18);
INSERT INTO public.lugar VALUES (263, 'Benítez', 'municipio', 18);
INSERT INTO public.lugar VALUES (264, 'Bermúdez', 'municipio', 18);
INSERT INTO public.lugar VALUES (265, 'Bolívar', 'municipio', 18);
INSERT INTO public.lugar VALUES (266, 'Cajigal', 'municipio', 18);
INSERT INTO public.lugar VALUES (267, 'Cruz Salmerón Acosta', 'municipio', 18);
INSERT INTO public.lugar VALUES (268, 'Libertador', 'municipio', 18);
INSERT INTO public.lugar VALUES (269, 'Mariño', 'municipio', 18);
INSERT INTO public.lugar VALUES (270, 'Mejía', 'municipio', 18);
INSERT INTO public.lugar VALUES (271, 'Montes', 'municipio', 18);
INSERT INTO public.lugar VALUES (272, 'Ribero', 'municipio', 18);
INSERT INTO public.lugar VALUES (273, 'Sucre', 'municipio', 18);
INSERT INTO public.lugar VALUES (274, 'Valdéz', 'municipio', 18);
INSERT INTO public.lugar VALUES (275, 'Andrés Bello', 'municipio', 19);
INSERT INTO public.lugar VALUES (276, 'Antonio Rómulo Costa', 'municipio', 19);
INSERT INTO public.lugar VALUES (277, 'Ayacucho', 'municipio', 19);
INSERT INTO public.lugar VALUES (278, 'Bolívar', 'municipio', 19);
INSERT INTO public.lugar VALUES (279, 'Cárdenas', 'municipio', 19);
INSERT INTO public.lugar VALUES (280, 'Córdoba', 'municipio', 19);
INSERT INTO public.lugar VALUES (281, 'Fernández Feo', 'municipio', 19);
INSERT INTO public.lugar VALUES (282, 'Francisco de Miranda', 'municipio', 19);
INSERT INTO public.lugar VALUES (283, 'García de Hevia', 'municipio', 19);
INSERT INTO public.lugar VALUES (284, 'Guásimos', 'municipio', 19);
INSERT INTO public.lugar VALUES (285, 'Independencia', 'municipio', 19);
INSERT INTO public.lugar VALUES (286, 'Jáuregui', 'municipio', 19);
INSERT INTO public.lugar VALUES (287, 'José María Vargas', 'municipio', 19);
INSERT INTO public.lugar VALUES (288, 'Junín', 'municipio', 19);
INSERT INTO public.lugar VALUES (289, 'Libertad', 'municipio', 19);
INSERT INTO public.lugar VALUES (290, 'Libertador', 'municipio', 19);
INSERT INTO public.lugar VALUES (291, 'Lobatera', 'municipio', 19);
INSERT INTO public.lugar VALUES (292, 'Michelena', 'municipio', 19);
INSERT INTO public.lugar VALUES (293, 'Panamericano', 'municipio', 19);
INSERT INTO public.lugar VALUES (294, 'Pedro María Ureña', 'municipio', 19);
INSERT INTO public.lugar VALUES (295, 'Rafael Urdaneta', 'municipio', 19);
INSERT INTO public.lugar VALUES (296, 'Samuel Darío Maldonado', 'municipio', 19);
INSERT INTO public.lugar VALUES (297, 'San Cristóbal', 'municipio', 19);
INSERT INTO public.lugar VALUES (298, 'Seboruco', 'municipio', 19);
INSERT INTO public.lugar VALUES (299, 'Simón Rodríguez', 'municipio', 19);
INSERT INTO public.lugar VALUES (300, 'Sucre', 'municipio', 19);
INSERT INTO public.lugar VALUES (301, 'Torbes', 'municipio', 19);
INSERT INTO public.lugar VALUES (302, 'Uribante', 'municipio', 19);
INSERT INTO public.lugar VALUES (303, 'San Judas Tadeo', 'municipio', 19);
INSERT INTO public.lugar VALUES (304, 'Andrés Bello', 'municipio', 20);
INSERT INTO public.lugar VALUES (305, 'Boconó', 'municipio', 20);
INSERT INTO public.lugar VALUES (306, 'Bolívar', 'municipio', 20);
INSERT INTO public.lugar VALUES (307, 'Candelaria', 'municipio', 20);
INSERT INTO public.lugar VALUES (308, 'Carache', 'municipio', 20);
INSERT INTO public.lugar VALUES (309, 'Escuque', 'municipio', 20);
INSERT INTO public.lugar VALUES (310, 'José Felipe Márquez Cañizalez', 'municipio', 20);
INSERT INTO public.lugar VALUES (311, 'Juan Vicente Campos Elías', 'municipio', 20);
INSERT INTO public.lugar VALUES (312, 'La Ceiba', 'municipio', 20);
INSERT INTO public.lugar VALUES (313, 'Miranda', 'municipio', 20);
INSERT INTO public.lugar VALUES (314, 'Monte Carmelo', 'municipio', 20);
INSERT INTO public.lugar VALUES (315, 'Motatán', 'municipio', 20);
INSERT INTO public.lugar VALUES (316, 'Pampán', 'municipio', 20);
INSERT INTO public.lugar VALUES (317, 'Pampanito', 'municipio', 20);
INSERT INTO public.lugar VALUES (318, 'Rafael Rangel', 'municipio', 20);
INSERT INTO public.lugar VALUES (319, 'San Rafael de Carvajal', 'municipio', 20);
INSERT INTO public.lugar VALUES (320, 'Sucre', 'municipio', 20);
INSERT INTO public.lugar VALUES (321, 'Trujillo', 'municipio', 20);
INSERT INTO public.lugar VALUES (322, 'Urdaneta', 'municipio', 20);
INSERT INTO public.lugar VALUES (323, 'Valera', 'municipio', 20);
INSERT INTO public.lugar VALUES (324, 'Vargas', 'municipio', 21);
INSERT INTO public.lugar VALUES (325, 'Arístides Bastidas', 'municipio', 22);
INSERT INTO public.lugar VALUES (326, 'Bolívar', 'municipio', 22);
INSERT INTO public.lugar VALUES (327, 'Bruzual', 'municipio', 22);
INSERT INTO public.lugar VALUES (328, 'Cocorote', 'municipio', 22);
INSERT INTO public.lugar VALUES (329, 'Independencia', 'municipio', 22);
INSERT INTO public.lugar VALUES (330, 'José Antonio Páez', 'municipio', 22);
INSERT INTO public.lugar VALUES (331, 'La Trinidad', 'municipio', 22);
INSERT INTO public.lugar VALUES (332, 'Manuel Monge', 'municipio', 22);
INSERT INTO public.lugar VALUES (333, 'Nirgua', 'municipio', 22);
INSERT INTO public.lugar VALUES (334, 'Peña', 'municipio', 22);
INSERT INTO public.lugar VALUES (335, 'San Felipe', 'municipio', 22);
INSERT INTO public.lugar VALUES (336, 'Sucre', 'municipio', 22);
INSERT INTO public.lugar VALUES (337, 'Urachiche', 'municipio', 22);
INSERT INTO public.lugar VALUES (338, 'José Joaquín Veroes', 'municipio', 22);
INSERT INTO public.lugar VALUES (339, 'Almirante Padilla', 'municipio', 23);
INSERT INTO public.lugar VALUES (340, 'Baralt', 'municipio', 23);
INSERT INTO public.lugar VALUES (341, 'Cabimas', 'municipio', 23);
INSERT INTO public.lugar VALUES (342, 'Catatumbo', 'municipio', 23);
INSERT INTO public.lugar VALUES (343, 'Colón', 'municipio', 23);
INSERT INTO public.lugar VALUES (344, 'Francisco Javier Pulgar', 'municipio', 23);
INSERT INTO public.lugar VALUES (345, 'Páez', 'municipio', 23);
INSERT INTO public.lugar VALUES (346, 'Jesús Enrique Losada', 'municipio', 23);
INSERT INTO public.lugar VALUES (347, 'Jesús María Semprún', 'municipio', 23);
INSERT INTO public.lugar VALUES (348, 'La Cañada de Urdaneta', 'municipio', 23);
INSERT INTO public.lugar VALUES (349, 'Lagunillas', 'municipio', 23);
INSERT INTO public.lugar VALUES (350, 'Machiques de Perijá', 'municipio', 23);
INSERT INTO public.lugar VALUES (351, 'Mara', 'municipio', 23);
INSERT INTO public.lugar VALUES (352, 'Maracaibo', 'municipio', 23);
INSERT INTO public.lugar VALUES (353, 'Miranda', 'municipio', 23);
INSERT INTO public.lugar VALUES (354, 'Rosario de Perijá', 'municipio', 23);
INSERT INTO public.lugar VALUES (355, 'San Francisco', 'municipio', 23);
INSERT INTO public.lugar VALUES (356, 'Santa Rita', 'municipio', 23);
INSERT INTO public.lugar VALUES (357, 'Simón Bolívar', 'municipio', 23);
INSERT INTO public.lugar VALUES (358, 'Sucre', 'municipio', 23);
INSERT INTO public.lugar VALUES (359, 'Valmore Rodríguez', 'municipio', 23);
INSERT INTO public.lugar VALUES (360, 'Libertador', 'municipio', 24);
INSERT INTO public.lugar VALUES (70983, 'Alto Orinoco', 'parroquia', 26);
INSERT INTO public.lugar VALUES (70984, 'Huachamacare Acanaña', 'parroquia', 26);
INSERT INTO public.lugar VALUES (70985, 'Marawaka Toky Shamanaña', 'parroquia', 26);
INSERT INTO public.lugar VALUES (70986, 'Mavaka Mavaka', 'parroquia', 26);
INSERT INTO public.lugar VALUES (70987, 'Sierra Parima Parimabé', 'parroquia', 26);
INSERT INTO public.lugar VALUES (70988, 'Ucata Laja Lisa', 'parroquia', 27);
INSERT INTO public.lugar VALUES (70989, 'Yapacana Macuruco', 'parroquia', 27);
INSERT INTO public.lugar VALUES (70990, 'Caname Guarinuma', 'parroquia', 27);
INSERT INTO public.lugar VALUES (70991, 'San Fernando de Atabapo', 'parroquia', 27);
INSERT INTO public.lugar VALUES (70992, 'Fernando Girón Tovar', 'parroquia', 28);
INSERT INTO public.lugar VALUES (70993, 'Luis Alberto Gómez', 'parroquia', 28);
INSERT INTO public.lugar VALUES (70994, 'Pahueña Limón de Parhueña', 'parroquia', 28);
INSERT INTO public.lugar VALUES (70995, 'Platanillal Platanillal', 'parroquia', 28);
INSERT INTO public.lugar VALUES (70996, 'Samariapo', 'parroquia', 29);
INSERT INTO public.lugar VALUES (70997, 'Sipapo', 'parroquia', 29);
INSERT INTO public.lugar VALUES (70998, 'Munduapo', 'parroquia', 29);
INSERT INTO public.lugar VALUES (70999, 'Guayapo', 'parroquia', 29);
INSERT INTO public.lugar VALUES (71000, 'Isla Ratón', 'parroquia', 29);
INSERT INTO public.lugar VALUES (71001, 'Alto Ventuari', 'parroquia', 30);
INSERT INTO public.lugar VALUES (71002, 'Medio Ventuari', 'parroquia', 30);
INSERT INTO public.lugar VALUES (71003, 'Bajo Ventuari', 'parroquia', 30);
INSERT INTO public.lugar VALUES (71004, 'San Juan de Manapiare', 'parroquia', 30);
INSERT INTO public.lugar VALUES (71005, 'Maroa', 'parroquia', 31);
INSERT INTO public.lugar VALUES (71006, 'Victorino', 'parroquia', 31);
INSERT INTO public.lugar VALUES (71007, 'Comunidad', 'parroquia', 31);
INSERT INTO public.lugar VALUES (71008, 'Casiquiare', 'parroquia', 32);
INSERT INTO public.lugar VALUES (71009, 'Cocuy', 'parroquia', 32);
INSERT INTO public.lugar VALUES (71010, 'San Carlos de Río Negro', 'parroquia', 32);
INSERT INTO public.lugar VALUES (71011, 'Solano', 'parroquia', 32);
INSERT INTO public.lugar VALUES (71012, 'Anaco', 'parroquia', 33);
INSERT INTO public.lugar VALUES (71013, 'San Joaquín', 'parroquia', 33);
INSERT INTO public.lugar VALUES (71014, 'Buena Vista', 'parroquia', 33);
INSERT INTO public.lugar VALUES (71015, 'Cachipo', 'parroquia', 34);
INSERT INTO public.lugar VALUES (71016, 'Aragua de Barcelona', 'parroquia', 34);
INSERT INTO public.lugar VALUES (71017, 'Clarines', 'parroquia', 35);
INSERT INTO public.lugar VALUES (71018, 'Guanape', 'parroquia', 35);
INSERT INTO public.lugar VALUES (71019, 'Sabana de Uchire', 'parroquia', 35);
INSERT INTO public.lugar VALUES (71020, 'Lechería', 'parroquia', 36);
INSERT INTO public.lugar VALUES (71021, 'El Morro', 'parroquia', 36);
INSERT INTO public.lugar VALUES (71022, 'Puerto Píritu', 'parroquia', 37);
INSERT INTO public.lugar VALUES (71023, 'San Miguel', 'parroquia', 37);
INSERT INTO public.lugar VALUES (71024, 'Sucre', 'parroquia', 37);
INSERT INTO public.lugar VALUES (71025, 'Valle de Guanape', 'parroquia', 38);
INSERT INTO public.lugar VALUES (71026, 'Santa Bárbara', 'parroquia', 38);
INSERT INTO public.lugar VALUES (71027, 'El Chaparro', 'parroquia', 39);
INSERT INTO public.lugar VALUES (71028, 'Tomás Alfaro', 'parroquia', 39);
INSERT INTO public.lugar VALUES (71029, 'Calatrava', 'parroquia', 39);
INSERT INTO public.lugar VALUES (71030, 'Guanta', 'parroquia', 40);
INSERT INTO public.lugar VALUES (71031, 'Chorrerón', 'parroquia', 40);
INSERT INTO public.lugar VALUES (71032, 'Mamo', 'parroquia', 41);
INSERT INTO public.lugar VALUES (71033, 'Soledad', 'parroquia', 41);
INSERT INTO public.lugar VALUES (71034, 'Mapire', 'parroquia', 42);
INSERT INTO public.lugar VALUES (71035, 'Piar', 'parroquia', 42);
INSERT INTO public.lugar VALUES (71036, 'Santa Clara', 'parroquia', 42);
INSERT INTO public.lugar VALUES (71037, 'San Diego de Cabrutica', 'parroquia', 42);
INSERT INTO public.lugar VALUES (71038, 'Uverito', 'parroquia', 42);
INSERT INTO public.lugar VALUES (71039, 'Zuata', 'parroquia', 42);
INSERT INTO public.lugar VALUES (71040, 'Puerto La Cruz', 'parroquia', 43);
INSERT INTO public.lugar VALUES (71041, 'Pozuelos', 'parroquia', 43);
INSERT INTO public.lugar VALUES (71042, 'Onoto', 'parroquia', 44);
INSERT INTO public.lugar VALUES (71043, 'San Pablo', 'parroquia', 44);
INSERT INTO public.lugar VALUES (71044, 'San Mateo', 'parroquia', 45);
INSERT INTO public.lugar VALUES (71045, 'El Carito', 'parroquia', 45);
INSERT INTO public.lugar VALUES (71046, 'Santa Inés', 'parroquia', 45);
INSERT INTO public.lugar VALUES (71047, 'La Romereña', 'parroquia', 45);
INSERT INTO public.lugar VALUES (71048, 'Atapirire', 'parroquia', 46);
INSERT INTO public.lugar VALUES (71049, 'Boca del Pao', 'parroquia', 46);
INSERT INTO public.lugar VALUES (71050, 'El Pao', 'parroquia', 46);
INSERT INTO public.lugar VALUES (71051, 'Pariaguán', 'parroquia', 46);
INSERT INTO public.lugar VALUES (71052, 'Cantaura', 'parroquia', 47);
INSERT INTO public.lugar VALUES (71053, 'Libertador', 'parroquia', 47);
INSERT INTO public.lugar VALUES (71054, 'Santa Rosa', 'parroquia', 47);
INSERT INTO public.lugar VALUES (71055, 'Urica', 'parroquia', 47);
INSERT INTO public.lugar VALUES (71056, 'Píritu', 'parroquia', 48);
INSERT INTO public.lugar VALUES (71057, 'San Francisco', 'parroquia', 48);
INSERT INTO public.lugar VALUES (71058, 'San José de Guanipa', 'parroquia', 49);
INSERT INTO public.lugar VALUES (71059, 'Boca de Uchire', 'parroquia', 50);
INSERT INTO public.lugar VALUES (71060, 'Boca de Chávez', 'parroquia', 50);
INSERT INTO public.lugar VALUES (71061, 'Pueblo Nuevo', 'parroquia', 51);
INSERT INTO public.lugar VALUES (71062, 'Santa Ana', 'parroquia', 51);
INSERT INTO public.lugar VALUES (71063, 'Bergantín', 'parroquia', 52);
INSERT INTO public.lugar VALUES (71064, 'Caigua', 'parroquia', 52);
INSERT INTO public.lugar VALUES (71065, 'El Carmen', 'parroquia', 52);
INSERT INTO public.lugar VALUES (71066, 'El Pilar', 'parroquia', 52);
INSERT INTO public.lugar VALUES (71067, 'Naricual', 'parroquia', 52);
INSERT INTO public.lugar VALUES (71068, 'San Crsitóbal', 'parroquia', 52);
INSERT INTO public.lugar VALUES (71069, 'Edmundo Barrios', 'parroquia', 53);
INSERT INTO public.lugar VALUES (71070, 'Miguel Otero Silva', 'parroquia', 53);
INSERT INTO public.lugar VALUES (71071, 'Achaguas', 'parroquia', 54);
INSERT INTO public.lugar VALUES (71072, 'Apurito', 'parroquia', 54);
INSERT INTO public.lugar VALUES (71073, 'El Yagual', 'parroquia', 54);
INSERT INTO public.lugar VALUES (71074, 'Guachara', 'parroquia', 54);
INSERT INTO public.lugar VALUES (71075, 'Mucuritas', 'parroquia', 54);
INSERT INTO public.lugar VALUES (71076, 'Queseras del medio', 'parroquia', 54);
INSERT INTO public.lugar VALUES (71077, 'Biruaca', 'parroquia', 55);
INSERT INTO public.lugar VALUES (71078, 'Bruzual', 'parroquia', 56);
INSERT INTO public.lugar VALUES (71079, 'Mantecal', 'parroquia', 56);
INSERT INTO public.lugar VALUES (71080, 'Quintero', 'parroquia', 56);
INSERT INTO public.lugar VALUES (71081, 'Rincón Hondo', 'parroquia', 56);
INSERT INTO public.lugar VALUES (71082, 'San Vicente', 'parroquia', 56);
INSERT INTO public.lugar VALUES (71083, 'Guasdualito', 'parroquia', 57);
INSERT INTO public.lugar VALUES (71084, 'Aramendi', 'parroquia', 57);
INSERT INTO public.lugar VALUES (71085, 'El Amparo', 'parroquia', 57);
INSERT INTO public.lugar VALUES (71086, 'San Camilo', 'parroquia', 57);
INSERT INTO public.lugar VALUES (71087, 'Urdaneta', 'parroquia', 57);
INSERT INTO public.lugar VALUES (71088, 'San Juan de Payara', 'parroquia', 58);
INSERT INTO public.lugar VALUES (71089, 'Codazzi', 'parroquia', 58);
INSERT INTO public.lugar VALUES (71090, 'Cunaviche', 'parroquia', 58);
INSERT INTO public.lugar VALUES (71091, 'Elorza', 'parroquia', 59);
INSERT INTO public.lugar VALUES (71092, 'La Trinidad', 'parroquia', 59);
INSERT INTO public.lugar VALUES (71093, 'San Fernando', 'parroquia', 60);
INSERT INTO public.lugar VALUES (71094, 'El Recreo', 'parroquia', 60);
INSERT INTO public.lugar VALUES (71095, 'Peñalver', 'parroquia', 60);
INSERT INTO public.lugar VALUES (71096, 'San Rafael de Atamaica', 'parroquia', 60);
INSERT INTO public.lugar VALUES (71097, 'Pedro José Ovalles', 'parroquia', 61);
INSERT INTO public.lugar VALUES (71098, 'Joaquín Crespo', 'parroquia', 61);
INSERT INTO public.lugar VALUES (71099, 'José Casanova Godoy', 'parroquia', 61);
INSERT INTO public.lugar VALUES (71100, 'Madre María de San José', 'parroquia', 61);
INSERT INTO public.lugar VALUES (71101, 'Andrés Eloy Blanco', 'parroquia', 61);
INSERT INTO public.lugar VALUES (71102, 'Los Tacarigua', 'parroquia', 61);
INSERT INTO public.lugar VALUES (71103, 'Las Delicias', 'parroquia', 61);
INSERT INTO public.lugar VALUES (71104, 'Choroní', 'parroquia', 61);
INSERT INTO public.lugar VALUES (71105, 'Bolívar', 'parroquia', 62);
INSERT INTO public.lugar VALUES (71106, 'Camatagua', 'parroquia', 63);
INSERT INTO public.lugar VALUES (71107, 'Carmen de Cura', 'parroquia', 63);
INSERT INTO public.lugar VALUES (71108, 'Santa Rita', 'parroquia', 64);
INSERT INTO public.lugar VALUES (71109, 'Francisco de Miranda', 'parroquia', 64);
INSERT INTO public.lugar VALUES (71110, 'Moseñor Feliciano González', 'parroquia', 64);
INSERT INTO public.lugar VALUES (71111, 'Santa Cruz', 'parroquia', 65);
INSERT INTO public.lugar VALUES (71112, 'José Félix Ribas', 'parroquia', 66);
INSERT INTO public.lugar VALUES (71113, 'Castor Nieves Ríos', 'parroquia', 66);
INSERT INTO public.lugar VALUES (71114, 'Las Guacamayas', 'parroquia', 66);
INSERT INTO public.lugar VALUES (71115, 'Pao de Zárate', 'parroquia', 66);
INSERT INTO public.lugar VALUES (71116, 'Zuata', 'parroquia', 66);
INSERT INTO public.lugar VALUES (71117, 'José Rafael Revenga', 'parroquia', 67);
INSERT INTO public.lugar VALUES (71118, 'El Consejo', 'parroquia', 67);
INSERT INTO public.lugar VALUES (71119, 'Palo Negro', 'parroquia', 68);
INSERT INTO public.lugar VALUES (71120, 'San Martín de Porres', 'parroquia', 68);
INSERT INTO public.lugar VALUES (71121, 'Ocumare de la Costa', 'parroquia', 69);
INSERT INTO public.lugar VALUES (71122, 'San Casimiro', 'parroquia', 70);
INSERT INTO public.lugar VALUES (71123, 'Güiripa', 'parroquia', 70);
INSERT INTO public.lugar VALUES (71124, 'Ollas de Caramacate', 'parroquia', 70);
INSERT INTO public.lugar VALUES (71125, 'Valle Morín', 'parroquia', 70);
INSERT INTO public.lugar VALUES (71126, 'El Limón', 'parroquia', 71);
INSERT INTO public.lugar VALUES (71127, 'Caña de Azúcar', 'parroquia', 71);
INSERT INTO public.lugar VALUES (71128, 'San Sebastían', 'parroquia', 72);
INSERT INTO public.lugar VALUES (71129, 'Turmero', 'parroquia', 73);
INSERT INTO public.lugar VALUES (71130, 'Arevalo Aponte', 'parroquia', 73);
INSERT INTO public.lugar VALUES (71131, 'Chuao', 'parroquia', 73);
INSERT INTO public.lugar VALUES (71132, 'Samán de Güere', 'parroquia', 73);
INSERT INTO public.lugar VALUES (71133, 'Alfredo Pacheco Miranda', 'parroquia', 73);
INSERT INTO public.lugar VALUES (71134, 'Santos Michelena', 'parroquia', 74);
INSERT INTO public.lugar VALUES (71135, 'Tiara', 'parroquia', 74);
INSERT INTO public.lugar VALUES (71136, 'Cagua', 'parroquia', 75);
INSERT INTO public.lugar VALUES (71137, 'Bella Vista', 'parroquia', 75);
INSERT INTO public.lugar VALUES (71138, 'Tovar', 'parroquia', 76);
INSERT INTO public.lugar VALUES (71139, 'Urdaneta', 'parroquia', 77);
INSERT INTO public.lugar VALUES (71140, 'Las Peñitas', 'parroquia', 77);
INSERT INTO public.lugar VALUES (71141, 'San Francisco de Cara', 'parroquia', 77);
INSERT INTO public.lugar VALUES (71142, 'Taguay', 'parroquia', 77);
INSERT INTO public.lugar VALUES (71143, 'Zamora', 'parroquia', 78);
INSERT INTO public.lugar VALUES (71144, 'Magdaleno', 'parroquia', 78);
INSERT INTO public.lugar VALUES (71145, 'San Francisco de Asís', 'parroquia', 78);
INSERT INTO public.lugar VALUES (71146, 'Valles de Tucutunemo', 'parroquia', 78);
INSERT INTO public.lugar VALUES (71147, 'Augusto Mijares', 'parroquia', 78);
INSERT INTO public.lugar VALUES (71148, 'Sabaneta', 'parroquia', 79);
INSERT INTO public.lugar VALUES (71149, 'Juan Antonio Rodríguez Domínguez', 'parroquia', 79);
INSERT INTO public.lugar VALUES (71150, 'El Cantón', 'parroquia', 80);
INSERT INTO public.lugar VALUES (71151, 'Santa Cruz de Guacas', 'parroquia', 80);
INSERT INTO public.lugar VALUES (71152, 'Puerto Vivas', 'parroquia', 80);
INSERT INTO public.lugar VALUES (71153, 'Ticoporo', 'parroquia', 81);
INSERT INTO public.lugar VALUES (71154, 'Nicolás Pulido', 'parroquia', 81);
INSERT INTO public.lugar VALUES (71155, 'Andrés Bello', 'parroquia', 81);
INSERT INTO public.lugar VALUES (71156, 'Arismendi', 'parroquia', 82);
INSERT INTO public.lugar VALUES (71157, 'Guadarrama', 'parroquia', 82);
INSERT INTO public.lugar VALUES (71158, 'La Unión', 'parroquia', 82);
INSERT INTO public.lugar VALUES (71159, 'San Antonio', 'parroquia', 82);
INSERT INTO public.lugar VALUES (71160, 'Barinas', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71161, 'Alberto Arvelo Larriva', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71162, 'San Silvestre', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71163, 'Santa Inés', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71164, 'Santa Lucía', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71165, 'Torumos', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71166, 'El Carmen', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71167, 'Rómulo Betancourt', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71168, 'Corazón de Jesús', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71169, 'Ramón Ignacio Méndez', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71170, 'Alto Barinas', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71171, 'Manuel Palacio Fajardo', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71172, 'Juan Antonio Rodríguez Domínguez', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71173, 'Dominga Ortiz de Páez', 'parroquia', 83);
INSERT INTO public.lugar VALUES (71174, 'Barinitas', 'parroquia', 84);
INSERT INTO public.lugar VALUES (71175, 'Altamira de Cáceres', 'parroquia', 84);
INSERT INTO public.lugar VALUES (71176, 'Calderas', 'parroquia', 84);
INSERT INTO public.lugar VALUES (71177, 'Barrancas', 'parroquia', 85);
INSERT INTO public.lugar VALUES (71178, 'El Socorro', 'parroquia', 85);
INSERT INTO public.lugar VALUES (71179, 'Mazparrito', 'parroquia', 85);
INSERT INTO public.lugar VALUES (71180, 'Santa Bárbara', 'parroquia', 86);
INSERT INTO public.lugar VALUES (71181, 'Pedro Briceño Méndez', 'parroquia', 86);
INSERT INTO public.lugar VALUES (71182, 'Ramón Ignacio Méndez', 'parroquia', 86);
INSERT INTO public.lugar VALUES (71183, 'José Ignacio del Pumar', 'parroquia', 86);
INSERT INTO public.lugar VALUES (71184, 'Obispos', 'parroquia', 87);
INSERT INTO public.lugar VALUES (71185, 'Guasimitos', 'parroquia', 87);
INSERT INTO public.lugar VALUES (71186, 'El Real', 'parroquia', 87);
INSERT INTO public.lugar VALUES (71187, 'La Luz', 'parroquia', 87);
INSERT INTO public.lugar VALUES (71188, 'Ciudad Bolívia', 'parroquia', 88);
INSERT INTO public.lugar VALUES (71189, 'José Ignacio Briceño', 'parroquia', 88);
INSERT INTO public.lugar VALUES (71190, 'José Félix Ribas', 'parroquia', 88);
INSERT INTO public.lugar VALUES (71191, 'Páez', 'parroquia', 88);
INSERT INTO public.lugar VALUES (71192, 'Libertad', 'parroquia', 89);
INSERT INTO public.lugar VALUES (71193, 'Dolores', 'parroquia', 89);
INSERT INTO public.lugar VALUES (71194, 'Santa Rosa', 'parroquia', 89);
INSERT INTO public.lugar VALUES (71195, 'Palacio Fajardo', 'parroquia', 89);
INSERT INTO public.lugar VALUES (71196, 'Simón Rodríguez', 'parroquia', 89);
INSERT INTO public.lugar VALUES (71197, 'Ciudad de Nutrias', 'parroquia', 90);
INSERT INTO public.lugar VALUES (71198, 'El Regalo', 'parroquia', 90);
INSERT INTO public.lugar VALUES (71199, 'Puerto Nutrias', 'parroquia', 90);
INSERT INTO public.lugar VALUES (71200, 'Santa Catalina', 'parroquia', 90);
INSERT INTO public.lugar VALUES (71201, 'Simón Bolívar', 'parroquia', 90);
INSERT INTO public.lugar VALUES (71202, 'Cachamay', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71203, 'Chirica', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71204, 'Dalla Costa', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71205, 'Once de Abril', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71206, 'Simón Bolívar', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71207, 'Unare', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71208, 'Universidad', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71209, 'Vista al Sol', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71210, 'Pozo Verde', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71211, 'Yocoima', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71212, '5 de Julio', 'parroquia', 91);
INSERT INTO public.lugar VALUES (71213, 'Cedeño', 'parroquia', 92);
INSERT INTO public.lugar VALUES (71214, 'Altagracia', 'parroquia', 92);
INSERT INTO public.lugar VALUES (71215, 'Ascensión Farreras', 'parroquia', 92);
INSERT INTO public.lugar VALUES (71216, 'Guaniamo', 'parroquia', 92);
INSERT INTO public.lugar VALUES (71217, 'La Urbana', 'parroquia', 92);
INSERT INTO public.lugar VALUES (71218, 'Pijiguaos', 'parroquia', 92);
INSERT INTO public.lugar VALUES (71219, 'El Callao', 'parroquia', 93);
INSERT INTO public.lugar VALUES (71220, 'Gran Sabana', 'parroquia', 94);
INSERT INTO public.lugar VALUES (71221, 'Ikabarú', 'parroquia', 94);
INSERT INTO public.lugar VALUES (71222, 'Catedral', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71223, 'Zea', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71224, 'Orinoco', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71225, 'José Antonio Páez', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71226, 'Marhuanta', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71227, 'Agua Salada', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71228, 'Vista Hermosa', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71229, 'La Sabanita', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71230, 'Panapana', 'parroquia', 95);
INSERT INTO public.lugar VALUES (71231, 'Andrés Eloy Blanco', 'parroquia', 96);
INSERT INTO public.lugar VALUES (71232, 'Upata', 'parroquia', 96);
INSERT INTO public.lugar VALUES (71233, 'Pedro Cova', 'parroquia', 96);
INSERT INTO public.lugar VALUES (71234, 'Raúl Leoni', 'parroquia', 97);
INSERT INTO public.lugar VALUES (71235, 'Barceloneta', 'parroquia', 97);
INSERT INTO public.lugar VALUES (71236, 'Santa Bárbara', 'parroquia', 97);
INSERT INTO public.lugar VALUES (71237, 'San Francisco', 'parroquia', 97);
INSERT INTO public.lugar VALUES (71238, 'Roscio', 'parroquia', 98);
INSERT INTO public.lugar VALUES (71239, 'Salóm', 'parroquia', 98);
INSERT INTO public.lugar VALUES (71240, 'Sifontes', 'parroquia', 99);
INSERT INTO public.lugar VALUES (71241, 'Dalla Costa', 'parroquia', 99);
INSERT INTO public.lugar VALUES (71242, 'San Isidro', 'parroquia', 99);
INSERT INTO public.lugar VALUES (71243, 'Sucre', 'parroquia', 100);
INSERT INTO public.lugar VALUES (71244, 'Aripao', 'parroquia', 100);
INSERT INTO public.lugar VALUES (71245, 'Guarataro', 'parroquia', 100);
INSERT INTO public.lugar VALUES (71246, 'Las Majadas', 'parroquia', 100);
INSERT INTO public.lugar VALUES (71247, 'Moitaco', 'parroquia', 100);
INSERT INTO public.lugar VALUES (71248, 'Padre Pedro Chien', 'parroquia', 101);
INSERT INTO public.lugar VALUES (71249, 'Río Grande', 'parroquia', 101);
INSERT INTO public.lugar VALUES (71250, 'Canoabo', 'parroquia', 102);
INSERT INTO public.lugar VALUES (71251, 'Simón Bolívar', 'parroquia', 102);
INSERT INTO public.lugar VALUES (71252, 'Güigüe', 'parroquia', 103);
INSERT INTO public.lugar VALUES (71253, 'Carabobo', 'parroquia', 103);
INSERT INTO public.lugar VALUES (71254, 'Tacarigua', 'parroquia', 103);
INSERT INTO public.lugar VALUES (71255, 'Mariara', 'parroquia', 104);
INSERT INTO public.lugar VALUES (71256, 'Aguas Calientes', 'parroquia', 104);
INSERT INTO public.lugar VALUES (71257, 'Ciudad Alianza', 'parroquia', 105);
INSERT INTO public.lugar VALUES (71258, 'Guacara', 'parroquia', 105);
INSERT INTO public.lugar VALUES (71259, 'Yagua', 'parroquia', 105);
INSERT INTO public.lugar VALUES (71260, 'Morón', 'parroquia', 106);
INSERT INTO public.lugar VALUES (71261, 'Yagua', 'parroquia', 106);
INSERT INTO public.lugar VALUES (71262, 'Tocuyito', 'parroquia', 107);
INSERT INTO public.lugar VALUES (71263, 'Independencia', 'parroquia', 107);
INSERT INTO public.lugar VALUES (71264, 'Los Guayos', 'parroquia', 108);
INSERT INTO public.lugar VALUES (71265, 'Miranda', 'parroquia', 109);
INSERT INTO public.lugar VALUES (71266, 'Montalbán', 'parroquia', 110);
INSERT INTO public.lugar VALUES (71267, 'Naguanagua', 'parroquia', 111);
INSERT INTO public.lugar VALUES (71268, 'Bartolomé Salóm', 'parroquia', 112);
INSERT INTO public.lugar VALUES (71269, 'Democracia', 'parroquia', 112);
INSERT INTO public.lugar VALUES (71270, 'Fraternidad', 'parroquia', 112);
INSERT INTO public.lugar VALUES (71271, 'Goaigoaza', 'parroquia', 112);
INSERT INTO public.lugar VALUES (71272, 'Juan José Flores', 'parroquia', 112);
INSERT INTO public.lugar VALUES (71273, 'Unión', 'parroquia', 112);
INSERT INTO public.lugar VALUES (71274, 'Borburata', 'parroquia', 112);
INSERT INTO public.lugar VALUES (71275, 'Patanemo', 'parroquia', 112);
INSERT INTO public.lugar VALUES (71276, 'San Diego', 'parroquia', 113);
INSERT INTO public.lugar VALUES (71277, 'San Joaquín', 'parroquia', 114);
INSERT INTO public.lugar VALUES (71278, 'Candelaria', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71279, 'Catedral', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71280, 'El Socorro', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71281, 'Miguel Peña', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71282, 'Rafael Urdaneta', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71283, 'San Blas', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71284, 'San José', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71285, 'Santa Rosa', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71286, 'Negro Primero', 'parroquia', 115);
INSERT INTO public.lugar VALUES (71287, 'Cojedes', 'parroquia', 116);
INSERT INTO public.lugar VALUES (71288, 'Juan de Mata Suárez', 'parroquia', 116);
INSERT INTO public.lugar VALUES (71289, 'Tinaquillo', 'parroquia', 117);
INSERT INTO public.lugar VALUES (71290, 'El Baúl', 'parroquia', 118);
INSERT INTO public.lugar VALUES (71291, 'Sucre', 'parroquia', 118);
INSERT INTO public.lugar VALUES (71292, 'La Aguadita', 'parroquia', 119);
INSERT INTO public.lugar VALUES (71293, 'Macapo', 'parroquia', 119);
INSERT INTO public.lugar VALUES (71294, 'El Pao', 'parroquia', 120);
INSERT INTO public.lugar VALUES (71295, 'El Amparo', 'parroquia', 121);
INSERT INTO public.lugar VALUES (71296, 'Libertad de Cojedes', 'parroquia', 121);
INSERT INTO public.lugar VALUES (71297, 'Rómulo Gallegos', 'parroquia', 122);
INSERT INTO public.lugar VALUES (71298, 'San Carlos de Austria', 'parroquia', 123);
INSERT INTO public.lugar VALUES (71299, 'Juan Ángel Bravo', 'parroquia', 123);
INSERT INTO public.lugar VALUES (71300, 'Manuel Manrique', 'parroquia', 123);
INSERT INTO public.lugar VALUES (71301, 'General en Jefe José Laurencio Silva', 'parroquia', 124);
INSERT INTO public.lugar VALUES (71302, 'Curiapo', 'parroquia', 125);
INSERT INTO public.lugar VALUES (71303, 'Almirante Luis Brión', 'parroquia', 125);
INSERT INTO public.lugar VALUES (71304, 'Francisco Aniceto Lugo', 'parroquia', 125);
INSERT INTO public.lugar VALUES (71305, 'Manuel Renaud', 'parroquia', 125);
INSERT INTO public.lugar VALUES (71306, 'Padre Barral', 'parroquia', 125);
INSERT INTO public.lugar VALUES (71307, 'Santos de Abelgas', 'parroquia', 125);
INSERT INTO public.lugar VALUES (71308, 'Imataca', 'parroquia', 126);
INSERT INTO public.lugar VALUES (71309, 'Juan Bautista Arismendi', 'parroquia', 126);
INSERT INTO public.lugar VALUES (71310, 'Manuel Piar', 'parroquia', 126);
INSERT INTO public.lugar VALUES (71311, 'Rómulo Gallegos', 'parroquia', 126);
INSERT INTO public.lugar VALUES (71312, 'Pedernales', 'parroquia', 127);
INSERT INTO public.lugar VALUES (71313, 'Luis Beltrán Prieto Figueroa', 'parroquia', 127);
INSERT INTO public.lugar VALUES (71314, 'San José', 'parroquia', 128);
INSERT INTO public.lugar VALUES (71315, 'José Vidal Marcano', 'parroquia', 128);
INSERT INTO public.lugar VALUES (71316, 'Juan Millán', 'parroquia', 128);
INSERT INTO public.lugar VALUES (71317, 'Leonardo Ruíz Pineda', 'parroquia', 128);
INSERT INTO public.lugar VALUES (71318, 'Mariscal Antonio José de Sucre', 'parroquia', 128);
INSERT INTO public.lugar VALUES (71319, 'Monseñor Argimiro García', 'parroquia', 128);
INSERT INTO public.lugar VALUES (71320, 'San Rafael (Delta Amacuro)', 'parroquia', 128);
INSERT INTO public.lugar VALUES (71321, 'Virgen del Valle', 'parroquia', 128);
INSERT INTO public.lugar VALUES (71322, 'Capadare', 'parroquia', 129);
INSERT INTO public.lugar VALUES (71323, 'La Pastora', 'parroquia', 129);
INSERT INTO public.lugar VALUES (71324, 'Libertador', 'parroquia', 129);
INSERT INTO public.lugar VALUES (71325, 'San Juan de los Cayos', 'parroquia', 129);
INSERT INTO public.lugar VALUES (71326, 'Aracua', 'parroquia', 130);
INSERT INTO public.lugar VALUES (71327, 'La Peña', 'parroquia', 130);
INSERT INTO public.lugar VALUES (71328, 'San Luis', 'parroquia', 130);
INSERT INTO public.lugar VALUES (71329, 'Bariro', 'parroquia', 131);
INSERT INTO public.lugar VALUES (71330, 'Borojó', 'parroquia', 131);
INSERT INTO public.lugar VALUES (71331, 'Capatárida', 'parroquia', 131);
INSERT INTO public.lugar VALUES (71332, 'Guajiro', 'parroquia', 131);
INSERT INTO public.lugar VALUES (71333, 'Seque', 'parroquia', 131);
INSERT INTO public.lugar VALUES (71334, 'Zazárida', 'parroquia', 131);
INSERT INTO public.lugar VALUES (71335, 'Valle de Eroa', 'parroquia', 131);
INSERT INTO public.lugar VALUES (71336, 'Cacique Manaure', 'parroquia', 132);
INSERT INTO public.lugar VALUES (71337, 'Norte', 'parroquia', 133);
INSERT INTO public.lugar VALUES (71338, 'Carirubana', 'parroquia', 133);
INSERT INTO public.lugar VALUES (71339, 'Santa Ana', 'parroquia', 133);
INSERT INTO public.lugar VALUES (71340, 'Urbana Punta Cardón', 'parroquia', 133);
INSERT INTO public.lugar VALUES (71341, 'La Vela de Coro', 'parroquia', 134);
INSERT INTO public.lugar VALUES (71342, 'Acurigua', 'parroquia', 134);
INSERT INTO public.lugar VALUES (71343, 'Guaibacoa', 'parroquia', 134);
INSERT INTO public.lugar VALUES (71344, 'Las Calderas', 'parroquia', 134);
INSERT INTO public.lugar VALUES (71345, 'Macoruca', 'parroquia', 134);
INSERT INTO public.lugar VALUES (71346, 'Dabajuro', 'parroquia', 135);
INSERT INTO public.lugar VALUES (71347, 'Agua Clara', 'parroquia', 136);
INSERT INTO public.lugar VALUES (71348, 'Avaria', 'parroquia', 136);
INSERT INTO public.lugar VALUES (71349, 'Pedregal', 'parroquia', 136);
INSERT INTO public.lugar VALUES (71350, 'Piedra Grande', 'parroquia', 136);
INSERT INTO public.lugar VALUES (71351, 'Purureche', 'parroquia', 136);
INSERT INTO public.lugar VALUES (71352, 'Adaure', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71353, 'Adícora', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71354, 'Baraived', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71355, 'Buena Vista', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71356, 'Jadacaquiva', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71357, 'El Vínculo', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71358, 'El Hato', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71359, 'Moruy', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71360, 'Pueblo Nuevo', 'parroquia', 137);
INSERT INTO public.lugar VALUES (71361, 'Agua Larga', 'parroquia', 138);
INSERT INTO public.lugar VALUES (71362, 'Churuguara', 'parroquia', 138);
INSERT INTO public.lugar VALUES (71363, 'El Paují', 'parroquia', 138);
INSERT INTO public.lugar VALUES (71364, 'Independencia', 'parroquia', 138);
INSERT INTO public.lugar VALUES (71365, 'Mapararí', 'parroquia', 138);
INSERT INTO public.lugar VALUES (71366, 'Agua Linda', 'parroquia', 139);
INSERT INTO public.lugar VALUES (71367, 'Araurima', 'parroquia', 139);
INSERT INTO public.lugar VALUES (71368, 'Jacura', 'parroquia', 139);
INSERT INTO public.lugar VALUES (71369, 'Tucacas', 'parroquia', 140);
INSERT INTO public.lugar VALUES (71370, 'Boca de Aroa', 'parroquia', 140);
INSERT INTO public.lugar VALUES (71371, 'Los Taques', 'parroquia', 141);
INSERT INTO public.lugar VALUES (71372, 'Judibana', 'parroquia', 141);
INSERT INTO public.lugar VALUES (71373, 'Mene de Mauroa', 'parroquia', 142);
INSERT INTO public.lugar VALUES (71374, 'San Félix', 'parroquia', 142);
INSERT INTO public.lugar VALUES (71375, 'Casigua', 'parroquia', 142);
INSERT INTO public.lugar VALUES (71376, 'Guzmán Guillermo', 'parroquia', 143);
INSERT INTO public.lugar VALUES (71377, 'Mitare', 'parroquia', 143);
INSERT INTO public.lugar VALUES (71378, 'Río Seco', 'parroquia', 143);
INSERT INTO public.lugar VALUES (71379, 'Sabaneta', 'parroquia', 143);
INSERT INTO public.lugar VALUES (71380, 'San Antonio', 'parroquia', 143);
INSERT INTO public.lugar VALUES (71381, 'San Gabriel', 'parroquia', 143);
INSERT INTO public.lugar VALUES (71382, 'Santa Ana', 'parroquia', 143);
INSERT INTO public.lugar VALUES (71383, 'Boca del Tocuyo', 'parroquia', 144);
INSERT INTO public.lugar VALUES (71384, 'Chichiriviche', 'parroquia', 144);
INSERT INTO public.lugar VALUES (71385, 'Tocuyo de la Costa', 'parroquia', 144);
INSERT INTO public.lugar VALUES (71386, 'Palmasola', 'parroquia', 145);
INSERT INTO public.lugar VALUES (71387, 'Cabure', 'parroquia', 146);
INSERT INTO public.lugar VALUES (71388, 'Colina', 'parroquia', 146);
INSERT INTO public.lugar VALUES (71389, 'Curimagua', 'parroquia', 146);
INSERT INTO public.lugar VALUES (71390, 'San José de la Costa', 'parroquia', 147);
INSERT INTO public.lugar VALUES (71391, 'Píritu', 'parroquia', 147);
INSERT INTO public.lugar VALUES (71392, 'San Francisco', 'parroquia', 148);
INSERT INTO public.lugar VALUES (71393, 'Sucre', 'parroquia', 149);
INSERT INTO public.lugar VALUES (71394, 'Pecaya', 'parroquia', 149);
INSERT INTO public.lugar VALUES (71395, 'Tocópero', 'parroquia', 150);
INSERT INTO public.lugar VALUES (71396, 'El Charal', 'parroquia', 151);
INSERT INTO public.lugar VALUES (71397, 'Las Vegas del Tuy', 'parroquia', 151);
INSERT INTO public.lugar VALUES (71398, 'Santa Cruz de Bucaral', 'parroquia', 151);
INSERT INTO public.lugar VALUES (71399, 'Bruzual', 'parroquia', 152);
INSERT INTO public.lugar VALUES (71400, 'Urumaco', 'parroquia', 152);
INSERT INTO public.lugar VALUES (71401, 'Puerto Cumarebo', 'parroquia', 153);
INSERT INTO public.lugar VALUES (71402, 'La Ciénaga', 'parroquia', 153);
INSERT INTO public.lugar VALUES (71403, 'La Soledad', 'parroquia', 153);
INSERT INTO public.lugar VALUES (71404, 'Pueblo Cumarebo', 'parroquia', 153);
INSERT INTO public.lugar VALUES (71405, 'Zazárida', 'parroquia', 153);
INSERT INTO public.lugar VALUES (71406, 'Camaguán', 'parroquia', 154);
INSERT INTO public.lugar VALUES (71407, 'Puerto Miranda', 'parroquia', 154);
INSERT INTO public.lugar VALUES (71408, 'Uverito', 'parroquia', 154);
INSERT INTO public.lugar VALUES (71409, 'Chaguaramas', 'parroquia', 155);
INSERT INTO public.lugar VALUES (71410, 'El Socorro', 'parroquia', 156);
INSERT INTO public.lugar VALUES (71411, 'Tucupido', 'parroquia', 157);
INSERT INTO public.lugar VALUES (71412, 'San Rafael de Laya', 'parroquia', 157);
INSERT INTO public.lugar VALUES (71413, 'Altagracia de Orituco', 'parroquia', 158);
INSERT INTO public.lugar VALUES (71414, 'San Rafael de Orituco', 'parroquia', 158);
INSERT INTO public.lugar VALUES (71415, 'San Francisco Javier de Lezama', 'parroquia', 158);
INSERT INTO public.lugar VALUES (71416, 'Paso Real de Macaira', 'parroquia', 158);
INSERT INTO public.lugar VALUES (71417, 'Carlos Soublette', 'parroquia', 158);
INSERT INTO public.lugar VALUES (71418, 'San Francisco de Macaira', 'parroquia', 158);
INSERT INTO public.lugar VALUES (71419, 'Libertad de Orituco', 'parroquia', 158);
INSERT INTO public.lugar VALUES (71420, 'Cantagallo', 'parroquia', 159);
INSERT INTO public.lugar VALUES (71421, 'San Juan de los Morros', 'parroquia', 159);
INSERT INTO public.lugar VALUES (71422, 'Parapara', 'parroquia', 159);
INSERT INTO public.lugar VALUES (71423, 'El Sombrero', 'parroquia', 160);
INSERT INTO public.lugar VALUES (71424, 'Sosa', 'parroquia', 160);
INSERT INTO public.lugar VALUES (71425, 'Las Mercedes', 'parroquia', 161);
INSERT INTO public.lugar VALUES (71426, 'Cabruta', 'parroquia', 161);
INSERT INTO public.lugar VALUES (71427, 'Santa Rita de Manapire', 'parroquia', 161);
INSERT INTO public.lugar VALUES (71428, 'Valle de la Pascua', 'parroquia', 162);
INSERT INTO public.lugar VALUES (71429, 'Espino', 'parroquia', 162);
INSERT INTO public.lugar VALUES (71430, 'San José de Unare', 'parroquia', 163);
INSERT INTO public.lugar VALUES (71431, 'Zaraza', 'parroquia', 163);
INSERT INTO public.lugar VALUES (71432, 'San José de Tiznados', 'parroquia', 164);
INSERT INTO public.lugar VALUES (71433, 'San Francisco de Tiznados', 'parroquia', 164);
INSERT INTO public.lugar VALUES (71434, 'San Lorenzo de Tiznados', 'parroquia', 164);
INSERT INTO public.lugar VALUES (71435, 'Ortiz', 'parroquia', 164);
INSERT INTO public.lugar VALUES (71436, 'Guayabal', 'parroquia', 165);
INSERT INTO public.lugar VALUES (71437, 'Cazorla', 'parroquia', 165);
INSERT INTO public.lugar VALUES (71438, 'San José de Guaribe', 'parroquia', 166);
INSERT INTO public.lugar VALUES (71439, 'Santa María de Ipire', 'parroquia', 167);
INSERT INTO public.lugar VALUES (71440, 'Altamira', 'parroquia', 167);
INSERT INTO public.lugar VALUES (71441, 'El Calvario', 'parroquia', 168);
INSERT INTO public.lugar VALUES (71442, 'El Rastro', 'parroquia', 168);
INSERT INTO public.lugar VALUES (71443, 'Guardatinajas', 'parroquia', 168);
INSERT INTO public.lugar VALUES (71444, 'Capital Urbana Calabozo', 'parroquia', 168);
INSERT INTO public.lugar VALUES (71445, 'Quebrada Honda de Guache', 'parroquia', 169);
INSERT INTO public.lugar VALUES (71446, 'Pío Tamayo', 'parroquia', 169);
INSERT INTO public.lugar VALUES (71447, 'Yacambú', 'parroquia', 169);
INSERT INTO public.lugar VALUES (71448, 'Fréitez', 'parroquia', 170);
INSERT INTO public.lugar VALUES (71449, 'José María Blanco', 'parroquia', 170);
INSERT INTO public.lugar VALUES (71450, 'Catedral', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71451, 'Concepción', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71452, 'El Cují', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71453, 'Juan de Villegas', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71454, 'Santa Rosa', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71455, 'Tamaca', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71456, 'Unión', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71457, 'Aguedo Felipe Alvarado', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71458, 'Buena Vista', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71459, 'Juárez', 'parroquia', 171);
INSERT INTO public.lugar VALUES (71460, 'Juan Bautista Rodríguez', 'parroquia', 172);
INSERT INTO public.lugar VALUES (71461, 'Cuara', 'parroquia', 172);
INSERT INTO public.lugar VALUES (71462, 'Diego de Lozada', 'parroquia', 172);
INSERT INTO public.lugar VALUES (71463, 'Paraíso de San José', 'parroquia', 172);
INSERT INTO public.lugar VALUES (71464, 'San Miguel', 'parroquia', 172);
INSERT INTO public.lugar VALUES (71465, 'Tintorero', 'parroquia', 172);
INSERT INTO public.lugar VALUES (71466, 'José Bernardo Dorante', 'parroquia', 172);
INSERT INTO public.lugar VALUES (71467, 'Coronel Mariano Peraza ', 'parroquia', 172);
INSERT INTO public.lugar VALUES (71468, 'Bolívar', 'parroquia', 173);
INSERT INTO public.lugar VALUES (71469, 'Anzoátegui', 'parroquia', 173);
INSERT INTO public.lugar VALUES (71470, 'Guarico', 'parroquia', 173);
INSERT INTO public.lugar VALUES (71471, 'Hilario Luna y Luna', 'parroquia', 173);
INSERT INTO public.lugar VALUES (71472, 'Humocaro Alto', 'parroquia', 173);
INSERT INTO public.lugar VALUES (71473, 'Humocaro Bajo', 'parroquia', 173);
INSERT INTO public.lugar VALUES (71474, 'La Candelaria', 'parroquia', 173);
INSERT INTO public.lugar VALUES (71475, 'Morán', 'parroquia', 173);
INSERT INTO public.lugar VALUES (71476, 'Cabudare', 'parroquia', 174);
INSERT INTO public.lugar VALUES (71477, 'José Gregorio Bastidas', 'parroquia', 174);
INSERT INTO public.lugar VALUES (71478, 'Agua Viva', 'parroquia', 174);
INSERT INTO public.lugar VALUES (71479, 'Sarare', 'parroquia', 175);
INSERT INTO public.lugar VALUES (71480, 'Buría', 'parroquia', 175);
INSERT INTO public.lugar VALUES (71481, 'Gustavo Vegas León', 'parroquia', 175);
INSERT INTO public.lugar VALUES (71482, 'Trinidad Samuel', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71483, 'Antonio Díaz', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71484, 'Camacaro', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71485, 'Castañeda', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71486, 'Cecilio Zubillaga', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71487, 'Chiquinquirá', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71488, 'El Blanco', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71489, 'Espinoza de los Monteros', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71490, 'Lara', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71491, 'Las Mercedes', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71492, 'Manuel Morillo', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71493, 'Montaña Verde', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71494, 'Montes de Oca', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71495, 'Torres', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71496, 'Heriberto Arroyo', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71497, 'Reyes Vargas', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71498, 'Altagracia', 'parroquia', 176);
INSERT INTO public.lugar VALUES (71499, 'Siquisique', 'parroquia', 177);
INSERT INTO public.lugar VALUES (71500, 'Moroturo', 'parroquia', 177);
INSERT INTO public.lugar VALUES (71501, 'San Miguel', 'parroquia', 177);
INSERT INTO public.lugar VALUES (71502, 'Xaguas', 'parroquia', 177);
INSERT INTO public.lugar VALUES (71503, 'Presidente Betancourt', 'parroquia', 178);
INSERT INTO public.lugar VALUES (71504, 'Presidente Páez', 'parroquia', 178);
INSERT INTO public.lugar VALUES (71505, 'Presidente Rómulo Gallegos', 'parroquia', 178);
INSERT INTO public.lugar VALUES (71506, 'Gabriel Picón González', 'parroquia', 178);
INSERT INTO public.lugar VALUES (71507, 'Héctor Amable Mora', 'parroquia', 178);
INSERT INTO public.lugar VALUES (71508, 'José Nucete Sardi', 'parroquia', 178);
INSERT INTO public.lugar VALUES (71509, 'Pulido Méndez', 'parroquia', 178);
INSERT INTO public.lugar VALUES (71510, 'La Azulita', 'parroquia', 179);
INSERT INTO public.lugar VALUES (71511, 'Santa Cruz de Mora', 'parroquia', 180);
INSERT INTO public.lugar VALUES (71512, 'Mesa Bolívar', 'parroquia', 180);
INSERT INTO public.lugar VALUES (71513, 'Mesa de Las Palmas', 'parroquia', 180);
INSERT INTO public.lugar VALUES (71514, 'Aricagua', 'parroquia', 181);
INSERT INTO public.lugar VALUES (71515, 'San Antonio', 'parroquia', 181);
INSERT INTO public.lugar VALUES (71516, 'Canagua', 'parroquia', 182);
INSERT INTO public.lugar VALUES (71517, 'Capurí', 'parroquia', 182);
INSERT INTO public.lugar VALUES (71518, 'Chacantá', 'parroquia', 182);
INSERT INTO public.lugar VALUES (71519, 'El Molino', 'parroquia', 182);
INSERT INTO public.lugar VALUES (71520, 'Guaimaral', 'parroquia', 182);
INSERT INTO public.lugar VALUES (71521, 'Mucutuy', 'parroquia', 182);
INSERT INTO public.lugar VALUES (71522, 'Mucuchachí', 'parroquia', 182);
INSERT INTO public.lugar VALUES (71523, 'Fernández Peña', 'parroquia', 183);
INSERT INTO public.lugar VALUES (71524, 'Matriz', 'parroquia', 183);
INSERT INTO public.lugar VALUES (71525, 'Montalbán', 'parroquia', 183);
INSERT INTO public.lugar VALUES (71526, 'Acequias', 'parroquia', 183);
INSERT INTO public.lugar VALUES (71527, 'Jají', 'parroquia', 183);
INSERT INTO public.lugar VALUES (71528, 'La Mesa', 'parroquia', 183);
INSERT INTO public.lugar VALUES (71529, 'San José del Sur', 'parroquia', 183);
INSERT INTO public.lugar VALUES (71530, 'Tucaní', 'parroquia', 184);
INSERT INTO public.lugar VALUES (71531, 'Florencio Ramírez', 'parroquia', 184);
INSERT INTO public.lugar VALUES (71532, 'Santo Domingo', 'parroquia', 185);
INSERT INTO public.lugar VALUES (71533, 'Las Piedras', 'parroquia', 185);
INSERT INTO public.lugar VALUES (71534, 'Guaraque', 'parroquia', 186);
INSERT INTO public.lugar VALUES (71535, 'Mesa de Quintero', 'parroquia', 186);
INSERT INTO public.lugar VALUES (71536, 'Río Negro', 'parroquia', 186);
INSERT INTO public.lugar VALUES (71537, 'Arapuey', 'parroquia', 187);
INSERT INTO public.lugar VALUES (71538, 'Palmira', 'parroquia', 187);
INSERT INTO public.lugar VALUES (71539, 'San Cristóbal de Torondoy', 'parroquia', 188);
INSERT INTO public.lugar VALUES (71540, 'Torondoy', 'parroquia', 188);
INSERT INTO public.lugar VALUES (71541, 'Antonio Spinetti Dini', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71542, 'Arias', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71543, 'Caracciolo Parra Pérez', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71544, 'Domingo Peña', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71545, 'El Llano', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71546, 'Gonzalo Picón Febres', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71547, 'Jacinto Plaza', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71548, 'Juan Rodríguez Suárez', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71549, 'Lasso de la Vega', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71550, 'Mariano Picón Salas', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71551, 'Milla', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71552, 'Osuna Rodríguez', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71553, 'Sagrario', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71554, 'El Morro', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71555, 'Los Nevados', 'parroquia', 189);
INSERT INTO public.lugar VALUES (71556, 'Andrés Eloy Blanco', 'parroquia', 190);
INSERT INTO public.lugar VALUES (71557, 'La Venta', 'parroquia', 190);
INSERT INTO public.lugar VALUES (71558, 'Piñango', 'parroquia', 190);
INSERT INTO public.lugar VALUES (71559, 'Timotes', 'parroquia', 190);
INSERT INTO public.lugar VALUES (71560, 'Eloy Paredes', 'parroquia', 191);
INSERT INTO public.lugar VALUES (71561, 'San Rafael de Alcázar', 'parroquia', 191);
INSERT INTO public.lugar VALUES (71562, 'Santa Elena de Arenales', 'parroquia', 191);
INSERT INTO public.lugar VALUES (71563, 'Santa María de Caparo', 'parroquia', 192);
INSERT INTO public.lugar VALUES (71564, 'Pueblo Llano', 'parroquia', 193);
INSERT INTO public.lugar VALUES (71565, 'Cacute', 'parroquia', 194);
INSERT INTO public.lugar VALUES (71566, 'La Toma', 'parroquia', 194);
INSERT INTO public.lugar VALUES (71567, 'Mucuchíes', 'parroquia', 194);
INSERT INTO public.lugar VALUES (71568, 'Mucurubá', 'parroquia', 194);
INSERT INTO public.lugar VALUES (71569, 'San Rafael', 'parroquia', 194);
INSERT INTO public.lugar VALUES (71570, 'Gerónimo Maldonado', 'parroquia', 195);
INSERT INTO public.lugar VALUES (71571, 'Bailadores', 'parroquia', 195);
INSERT INTO public.lugar VALUES (71572, 'Tabay', 'parroquia', 196);
INSERT INTO public.lugar VALUES (71573, 'Chiguará', 'parroquia', 197);
INSERT INTO public.lugar VALUES (71574, 'Estánquez', 'parroquia', 197);
INSERT INTO public.lugar VALUES (71575, 'Lagunillas', 'parroquia', 197);
INSERT INTO public.lugar VALUES (71576, 'La Trampa', 'parroquia', 197);
INSERT INTO public.lugar VALUES (71577, 'Pueblo Nuevo del Sur', 'parroquia', 197);
INSERT INTO public.lugar VALUES (71578, 'San Juan', 'parroquia', 197);
INSERT INTO public.lugar VALUES (71579, 'El Amparo', 'parroquia', 198);
INSERT INTO public.lugar VALUES (71580, 'El Llano', 'parroquia', 198);
INSERT INTO public.lugar VALUES (71581, 'San Francisco', 'parroquia', 198);
INSERT INTO public.lugar VALUES (71582, 'Tovar', 'parroquia', 198);
INSERT INTO public.lugar VALUES (71583, 'Independencia', 'parroquia', 199);
INSERT INTO public.lugar VALUES (71584, 'María de la Concepción Palacios Blanco', 'parroquia', 199);
INSERT INTO public.lugar VALUES (71585, 'Nueva Bolivia', 'parroquia', 199);
INSERT INTO public.lugar VALUES (71586, 'Santa Apolonia', 'parroquia', 199);
INSERT INTO public.lugar VALUES (71587, 'Caño El Tigre', 'parroquia', 200);
INSERT INTO public.lugar VALUES (71588, 'Zea', 'parroquia', 200);
INSERT INTO public.lugar VALUES (71589, 'Aragüita', 'parroquia', 201);
INSERT INTO public.lugar VALUES (71590, 'Arévalo González', 'parroquia', 201);
INSERT INTO public.lugar VALUES (71591, 'Capaya', 'parroquia', 201);
INSERT INTO public.lugar VALUES (71592, 'Caucagua', 'parroquia', 201);
INSERT INTO public.lugar VALUES (71593, 'Panaquire', 'parroquia', 201);
INSERT INTO public.lugar VALUES (71594, 'Ribas', 'parroquia', 201);
INSERT INTO public.lugar VALUES (71595, 'El Café', 'parroquia', 201);
INSERT INTO public.lugar VALUES (71596, 'Marizapa', 'parroquia', 201);
INSERT INTO public.lugar VALUES (71597, 'Cumbo', 'parroquia', 202);
INSERT INTO public.lugar VALUES (71598, 'San José de Barlovento', 'parroquia', 202);
INSERT INTO public.lugar VALUES (71599, 'El Cafetal', 'parroquia', 203);
INSERT INTO public.lugar VALUES (71600, 'Las Minas', 'parroquia', 203);
INSERT INTO public.lugar VALUES (71601, 'Higuerote', 'parroquia', 204);
INSERT INTO public.lugar VALUES (71602, 'Curiepe', 'parroquia', 204);
INSERT INTO public.lugar VALUES (71603, 'Tacarigua de Brión', 'parroquia', 204);
INSERT INTO public.lugar VALUES (71604, 'Mamporal', 'parroquia', 205);
INSERT INTO public.lugar VALUES (71605, 'Carrizal', 'parroquia', 206);
INSERT INTO public.lugar VALUES (71606, 'Chacao', 'parroquia', 207);
INSERT INTO public.lugar VALUES (71607, 'Charallave', 'parroquia', 208);
INSERT INTO public.lugar VALUES (71608, 'Las Brisas', 'parroquia', 208);
INSERT INTO public.lugar VALUES (71609, 'El Hatillo', 'parroquia', 209);
INSERT INTO public.lugar VALUES (71610, 'Altagracia de la Montaña', 'parroquia', 210);
INSERT INTO public.lugar VALUES (71611, 'Cecilio Acosta', 'parroquia', 210);
INSERT INTO public.lugar VALUES (71612, 'Los Teques', 'parroquia', 210);
INSERT INTO public.lugar VALUES (71613, 'El Jarillo', 'parroquia', 210);
INSERT INTO public.lugar VALUES (71614, 'San Pedro', 'parroquia', 210);
INSERT INTO public.lugar VALUES (71615, 'Tácata', 'parroquia', 210);
INSERT INTO public.lugar VALUES (71616, 'Paracotos', 'parroquia', 210);
INSERT INTO public.lugar VALUES (71617, 'Cartanal', 'parroquia', 211);
INSERT INTO public.lugar VALUES (71618, 'Santa Teresa del Tuy', 'parroquia', 211);
INSERT INTO public.lugar VALUES (71619, 'La Democracia', 'parroquia', 212);
INSERT INTO public.lugar VALUES (71620, 'Ocumare del Tuy', 'parroquia', 212);
INSERT INTO public.lugar VALUES (71621, 'Santa Bárbara', 'parroquia', 212);
INSERT INTO public.lugar VALUES (71622, 'San Antonio de los Altos', 'parroquia', 213);
INSERT INTO public.lugar VALUES (71623, 'Río Chico', 'parroquia', 214);
INSERT INTO public.lugar VALUES (71624, 'El Guapo', 'parroquia', 214);
INSERT INTO public.lugar VALUES (71625, 'Tacarigua de la Laguna', 'parroquia', 214);
INSERT INTO public.lugar VALUES (71626, 'Paparo', 'parroquia', 214);
INSERT INTO public.lugar VALUES (71627, 'San Fernando del Guapo', 'parroquia', 214);
INSERT INTO public.lugar VALUES (71628, 'Santa Lucía del Tuy', 'parroquia', 215);
INSERT INTO public.lugar VALUES (71629, 'Cúpira', 'parroquia', 216);
INSERT INTO public.lugar VALUES (71630, 'Machurucuto', 'parroquia', 216);
INSERT INTO public.lugar VALUES (71631, 'Guarenas', 'parroquia', 217);
INSERT INTO public.lugar VALUES (71632, 'San Antonio de Yare', 'parroquia', 218);
INSERT INTO public.lugar VALUES (71633, 'San Francisco de Yare', 'parroquia', 218);
INSERT INTO public.lugar VALUES (71634, 'Leoncio Martínez', 'parroquia', 219);
INSERT INTO public.lugar VALUES (71635, 'Petare', 'parroquia', 219);
INSERT INTO public.lugar VALUES (71636, 'Caucagüita', 'parroquia', 219);
INSERT INTO public.lugar VALUES (71637, 'Filas de Mariche', 'parroquia', 219);
INSERT INTO public.lugar VALUES (71638, 'La Dolorita', 'parroquia', 219);
INSERT INTO public.lugar VALUES (71639, 'Cúa', 'parroquia', 220);
INSERT INTO public.lugar VALUES (71640, 'Nueva Cúa', 'parroquia', 220);
INSERT INTO public.lugar VALUES (71641, 'Guatire', 'parroquia', 221);
INSERT INTO public.lugar VALUES (71642, 'Bolívar', 'parroquia', 221);
INSERT INTO public.lugar VALUES (71643, 'San Antonio de Maturín', 'parroquia', 222);
INSERT INTO public.lugar VALUES (71644, 'San Francisco de Maturín', 'parroquia', 222);
INSERT INTO public.lugar VALUES (71645, 'Aguasay', 'parroquia', 223);
INSERT INTO public.lugar VALUES (71646, 'Caripito', 'parroquia', 224);
INSERT INTO public.lugar VALUES (71647, 'El Guácharo', 'parroquia', 225);
INSERT INTO public.lugar VALUES (71648, 'La Guanota', 'parroquia', 225);
INSERT INTO public.lugar VALUES (71649, 'Sabana de Piedra', 'parroquia', 225);
INSERT INTO public.lugar VALUES (71650, 'San Agustín', 'parroquia', 225);
INSERT INTO public.lugar VALUES (71651, 'Teresen', 'parroquia', 225);
INSERT INTO public.lugar VALUES (71652, 'Caripe', 'parroquia', 225);
INSERT INTO public.lugar VALUES (71653, 'Areo', 'parroquia', 226);
INSERT INTO public.lugar VALUES (71654, 'Capital Cedeño', 'parroquia', 226);
INSERT INTO public.lugar VALUES (71655, 'San Félix de Cantalicio', 'parroquia', 226);
INSERT INTO public.lugar VALUES (71656, 'Viento Fresco', 'parroquia', 226);
INSERT INTO public.lugar VALUES (71657, 'El Tejero', 'parroquia', 227);
INSERT INTO public.lugar VALUES (71658, 'Punta de Mata', 'parroquia', 227);
INSERT INTO public.lugar VALUES (71659, 'Chaguaramas', 'parroquia', 228);
INSERT INTO public.lugar VALUES (71660, 'Las Alhuacas', 'parroquia', 228);
INSERT INTO public.lugar VALUES (71661, 'Tabasca', 'parroquia', 228);
INSERT INTO public.lugar VALUES (71662, 'Temblador', 'parroquia', 228);
INSERT INTO public.lugar VALUES (71663, 'Alto de los Godos', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71664, 'Boquerón', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71665, 'Las Cocuizas', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71666, 'La Cruz', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71667, 'San Simón', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71668, 'El Corozo', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71669, 'El Furrial', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71670, 'Jusepín', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71671, 'La Pica', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71672, 'San Vicente', 'parroquia', 229);
INSERT INTO public.lugar VALUES (71673, 'Aparicio', 'parroquia', 230);
INSERT INTO public.lugar VALUES (71674, 'Aragua de Maturín', 'parroquia', 230);
INSERT INTO public.lugar VALUES (71675, 'Chaguamal', 'parroquia', 230);
INSERT INTO public.lugar VALUES (71676, 'El Pinto', 'parroquia', 230);
INSERT INTO public.lugar VALUES (71677, 'Guanaguana', 'parroquia', 230);
INSERT INTO public.lugar VALUES (71678, 'La Toscana', 'parroquia', 230);
INSERT INTO public.lugar VALUES (71679, 'Taguaya', 'parroquia', 230);
INSERT INTO public.lugar VALUES (71680, 'Cachipo', 'parroquia', 231);
INSERT INTO public.lugar VALUES (71681, 'Quiriquire', 'parroquia', 231);
INSERT INTO public.lugar VALUES (71682, 'Santa Bárbara', 'parroquia', 232);
INSERT INTO public.lugar VALUES (71683, 'Morón', 'parroquia', 232);
INSERT INTO public.lugar VALUES (71684, 'Barrancas', 'parroquia', 233);
INSERT INTO public.lugar VALUES (71685, 'Los Barrancos de Fajardo', 'parroquia', 233);
INSERT INTO public.lugar VALUES (71686, 'Uracoa', 'parroquia', 234);
INSERT INTO public.lugar VALUES (71687, 'Antolín del Campo', 'parroquia', 235);
INSERT INTO public.lugar VALUES (71688, 'Arismendi', 'parroquia', 236);
INSERT INTO public.lugar VALUES (71689, 'García', 'parroquia', 237);
INSERT INTO public.lugar VALUES (71690, 'Francisco Fajardo', 'parroquia', 237);
INSERT INTO public.lugar VALUES (71691, 'Bolívar', 'parroquia', 238);
INSERT INTO public.lugar VALUES (71692, 'Guevara', 'parroquia', 238);
INSERT INTO public.lugar VALUES (71693, 'Matasiete', 'parroquia', 238);
INSERT INTO public.lugar VALUES (71694, 'Santa Ana', 'parroquia', 238);
INSERT INTO public.lugar VALUES (71695, 'Sucre', 'parroquia', 238);
INSERT INTO public.lugar VALUES (71696, 'Aguirre', 'parroquia', 239);
INSERT INTO public.lugar VALUES (71697, 'Maneiro', 'parroquia', 239);
INSERT INTO public.lugar VALUES (71698, 'Adrián', 'parroquia', 240);
INSERT INTO public.lugar VALUES (71699, 'Juan Griego', 'parroquia', 240);
INSERT INTO public.lugar VALUES (71700, 'Porlamar', 'parroquia', 241);
INSERT INTO public.lugar VALUES (71701, 'San Francisco de Macanao', 'parroquia', 242);
INSERT INTO public.lugar VALUES (71702, 'Boca de Río', 'parroquia', 242);
INSERT INTO public.lugar VALUES (71703, 'Tubores', 'parroquia', 243);
INSERT INTO public.lugar VALUES (71704, 'Los Baleales', 'parroquia', 243);
INSERT INTO public.lugar VALUES (71705, 'Vicente Fuentes', 'parroquia', 244);
INSERT INTO public.lugar VALUES (71706, 'Villalba', 'parroquia', 244);
INSERT INTO public.lugar VALUES (71707, 'San Juan Bautista', 'parroquia', 245);
INSERT INTO public.lugar VALUES (71708, 'Zabala', 'parroquia', 245);
INSERT INTO public.lugar VALUES (71709, 'Ahua Blanca', 'parroquia', 246);
INSERT INTO public.lugar VALUES (71710, 'Capital Araure', 'parroquia', 247);
INSERT INTO public.lugar VALUES (71711, 'Río Acarigua', 'parroquia', 247);
INSERT INTO public.lugar VALUES (71712, 'Capital Esteller', 'parroquia', 248);
INSERT INTO public.lugar VALUES (71713, 'Uveral', 'parroquia', 248);
INSERT INTO public.lugar VALUES (71714, 'Guanare', 'parroquia', 249);
INSERT INTO public.lugar VALUES (71715, 'Córdoba', 'parroquia', 249);
INSERT INTO public.lugar VALUES (71716, 'San José de la Montaña', 'parroquia', 249);
INSERT INTO public.lugar VALUES (71717, 'San Juan de Guanaguanare', 'parroquia', 249);
INSERT INTO public.lugar VALUES (71718, 'Virgen de la Coromoto', 'parroquia', 249);
INSERT INTO public.lugar VALUES (71719, 'Guanarito', 'parroquia', 250);
INSERT INTO public.lugar VALUES (71720, 'Trinidad de la Capilla', 'parroquia', 250);
INSERT INTO public.lugar VALUES (71721, 'Divina Pastora', 'parroquia', 250);
INSERT INTO public.lugar VALUES (71722, 'Monseñor José Vicente de Unda', 'parroquia', 251);
INSERT INTO public.lugar VALUES (71723, 'Peña Blanca', 'parroquia', 251);
INSERT INTO public.lugar VALUES (71724, 'Capital Ospino', 'parroquia', 252);
INSERT INTO public.lugar VALUES (71725, 'Aparición', 'parroquia', 252);
INSERT INTO public.lugar VALUES (71726, 'La Estación', 'parroquia', 252);
INSERT INTO public.lugar VALUES (71727, 'Páez', 'parroquia', 253);
INSERT INTO public.lugar VALUES (71728, 'Payara', 'parroquia', 253);
INSERT INTO public.lugar VALUES (71729, 'Pimpinela', 'parroquia', 253);
INSERT INTO public.lugar VALUES (71730, 'Ramón Peraza', 'parroquia', 253);
INSERT INTO public.lugar VALUES (71731, 'Papelón', 'parroquia', 254);
INSERT INTO public.lugar VALUES (71732, 'Caño Delgadito', 'parroquia', 254);
INSERT INTO public.lugar VALUES (71733, 'San Genaro de Boconoito', 'parroquia', 255);
INSERT INTO public.lugar VALUES (71734, 'Antolín Tovar', 'parroquia', 255);
INSERT INTO public.lugar VALUES (71735, 'San Rafael de Onoto', 'parroquia', 256);
INSERT INTO public.lugar VALUES (71736, 'Santa Fe', 'parroquia', 256);
INSERT INTO public.lugar VALUES (71737, 'Thermo Morles', 'parroquia', 256);
INSERT INTO public.lugar VALUES (71738, 'Santa Rosalía', 'parroquia', 257);
INSERT INTO public.lugar VALUES (71739, 'Florida', 'parroquia', 257);
INSERT INTO public.lugar VALUES (71740, 'Sucre', 'parroquia', 258);
INSERT INTO public.lugar VALUES (71741, 'Concepción', 'parroquia', 258);
INSERT INTO public.lugar VALUES (71742, 'San Rafael de Palo Alzado', 'parroquia', 258);
INSERT INTO public.lugar VALUES (71743, 'Uvencio Antonio Velásquez', 'parroquia', 258);
INSERT INTO public.lugar VALUES (71744, 'San José de Saguaz', 'parroquia', 258);
INSERT INTO public.lugar VALUES (71745, 'Villa Rosa', 'parroquia', 258);
INSERT INTO public.lugar VALUES (71746, 'Turén', 'parroquia', 259);
INSERT INTO public.lugar VALUES (71747, 'Canelones', 'parroquia', 259);
INSERT INTO public.lugar VALUES (71748, 'Santa Cruz', 'parroquia', 259);
INSERT INTO public.lugar VALUES (71749, 'San Isidro Labrador', 'parroquia', 259);
INSERT INTO public.lugar VALUES (71750, 'Mariño', 'parroquia', 260);
INSERT INTO public.lugar VALUES (71751, 'Rómulo Gallegos', 'parroquia', 260);
INSERT INTO public.lugar VALUES (71752, 'San José de Aerocuar', 'parroquia', 261);
INSERT INTO public.lugar VALUES (71753, 'Tavera Acosta', 'parroquia', 261);
INSERT INTO public.lugar VALUES (71754, 'Río Caribe', 'parroquia', 262);
INSERT INTO public.lugar VALUES (71755, 'Antonio José de Sucre', 'parroquia', 262);
INSERT INTO public.lugar VALUES (71756, 'El Morro de Puerto Santo', 'parroquia', 262);
INSERT INTO public.lugar VALUES (71757, 'Puerto Santo', 'parroquia', 262);
INSERT INTO public.lugar VALUES (71758, 'San Juan de las Galdonas', 'parroquia', 262);
INSERT INTO public.lugar VALUES (71759, 'El Pilar', 'parroquia', 263);
INSERT INTO public.lugar VALUES (71760, 'El Rincón', 'parroquia', 263);
INSERT INTO public.lugar VALUES (71761, 'General Francisco Antonio Váquez', 'parroquia', 263);
INSERT INTO public.lugar VALUES (71762, 'Guaraúnos', 'parroquia', 263);
INSERT INTO public.lugar VALUES (71763, 'Tunapuicito', 'parroquia', 263);
INSERT INTO public.lugar VALUES (71764, 'Unión', 'parroquia', 263);
INSERT INTO public.lugar VALUES (71765, 'Santa Catalina', 'parroquia', 264);
INSERT INTO public.lugar VALUES (71766, 'Santa Rosa', 'parroquia', 264);
INSERT INTO public.lugar VALUES (71767, 'Santa Teresa', 'parroquia', 264);
INSERT INTO public.lugar VALUES (71768, 'Bolívar', 'parroquia', 264);
INSERT INTO public.lugar VALUES (71769, 'Maracapana', 'parroquia', 264);
INSERT INTO public.lugar VALUES (71770, 'Mariguitar', 'parroquia', 265);
INSERT INTO public.lugar VALUES (71771, 'Libertad', 'parroquia', 266);
INSERT INTO public.lugar VALUES (71772, 'El Paujil', 'parroquia', 266);
INSERT INTO public.lugar VALUES (71773, 'Yaguaraparo', 'parroquia', 266);
INSERT INTO public.lugar VALUES (71774, 'Cruz Salmerón Acosta', 'parroquia', 267);
INSERT INTO public.lugar VALUES (71775, 'Chacopata', 'parroquia', 267);
INSERT INTO public.lugar VALUES (71776, 'Manicuare', 'parroquia', 267);
INSERT INTO public.lugar VALUES (71777, 'Tunapuy', 'parroquia', 268);
INSERT INTO public.lugar VALUES (71778, 'Campo Elías', 'parroquia', 268);
INSERT INTO public.lugar VALUES (71779, 'Irapa', 'parroquia', 269);
INSERT INTO public.lugar VALUES (71780, 'Campo Claro', 'parroquia', 269);
INSERT INTO public.lugar VALUES (71781, 'Maraval', 'parroquia', 269);
INSERT INTO public.lugar VALUES (71782, 'San Antonio de Irapa', 'parroquia', 269);
INSERT INTO public.lugar VALUES (71783, 'Soro', 'parroquia', 269);
INSERT INTO public.lugar VALUES (71784, 'Mejía', 'parroquia', 270);
INSERT INTO public.lugar VALUES (71785, 'Cumanacoa', 'parroquia', 271);
INSERT INTO public.lugar VALUES (71786, 'Arenas', 'parroquia', 271);
INSERT INTO public.lugar VALUES (71787, 'Aricagua', 'parroquia', 271);
INSERT INTO public.lugar VALUES (71788, 'Cogollar', 'parroquia', 271);
INSERT INTO public.lugar VALUES (71789, 'San Fernando', 'parroquia', 271);
INSERT INTO public.lugar VALUES (71790, 'San Lorenzo', 'parroquia', 271);
INSERT INTO public.lugar VALUES (71791, 'Villa Frontado (Muelle de Cariaco)', 'parroquia', 272);
INSERT INTO public.lugar VALUES (71792, 'Catuaro', 'parroquia', 272);
INSERT INTO public.lugar VALUES (71793, 'Rendón', 'parroquia', 272);
INSERT INTO public.lugar VALUES (71794, 'San Cruz', 'parroquia', 272);
INSERT INTO public.lugar VALUES (71795, 'Santa María', 'parroquia', 272);
INSERT INTO public.lugar VALUES (71796, 'Altagracia', 'parroquia', 273);
INSERT INTO public.lugar VALUES (71797, 'Santa Inés', 'parroquia', 273);
INSERT INTO public.lugar VALUES (71798, 'Valentín Valiente', 'parroquia', 273);
INSERT INTO public.lugar VALUES (71799, 'Ayacucho', 'parroquia', 273);
INSERT INTO public.lugar VALUES (71800, 'San Juan', 'parroquia', 273);
INSERT INTO public.lugar VALUES (71801, 'Raúl Leoni', 'parroquia', 273);
INSERT INTO public.lugar VALUES (71802, 'Gran Mariscal', 'parroquia', 273);
INSERT INTO public.lugar VALUES (71803, 'Cristóbal Colón', 'parroquia', 274);
INSERT INTO public.lugar VALUES (71804, 'Bideau', 'parroquia', 274);
INSERT INTO public.lugar VALUES (71805, 'Punta de Piedras', 'parroquia', 274);
INSERT INTO public.lugar VALUES (71806, 'Güiria', 'parroquia', 274);
INSERT INTO public.lugar VALUES (71807, 'Andrés Bello', 'parroquia', 275);
INSERT INTO public.lugar VALUES (71808, 'Antonio Rómulo Costa', 'parroquia', 276);
INSERT INTO public.lugar VALUES (71809, 'Ayacucho', 'parroquia', 277);
INSERT INTO public.lugar VALUES (71810, 'Rivas Berti', 'parroquia', 277);
INSERT INTO public.lugar VALUES (71811, 'San Pedro del Río', 'parroquia', 277);
INSERT INTO public.lugar VALUES (71812, 'Bolívar', 'parroquia', 278);
INSERT INTO public.lugar VALUES (71813, 'Palotal', 'parroquia', 278);
INSERT INTO public.lugar VALUES (71814, 'General Juan Vicente Gómez', 'parroquia', 278);
INSERT INTO public.lugar VALUES (71815, 'Isaías Medina Angarita', 'parroquia', 278);
INSERT INTO public.lugar VALUES (71816, 'Táriba', 'parroquia', 279);
INSERT INTO public.lugar VALUES (71817, 'Amenodoro Ángel Lamus', 'parroquia', 279);
INSERT INTO public.lugar VALUES (71818, 'La Florida', 'parroquia', 279);
INSERT INTO public.lugar VALUES (71819, 'Córdoba', 'parroquia', 280);
INSERT INTO public.lugar VALUES (71820, 'Fernández Feo', 'parroquia', 281);
INSERT INTO public.lugar VALUES (71821, 'Alberto Adriani', 'parroquia', 281);
INSERT INTO public.lugar VALUES (71822, 'Santo Domingo', 'parroquia', 281);
INSERT INTO public.lugar VALUES (71823, 'Francisco de Miranda', 'parroquia', 282);
INSERT INTO public.lugar VALUES (71824, 'García de Hevia', 'parroquia', 283);
INSERT INTO public.lugar VALUES (71825, 'Boca de Grita', 'parroquia', 283);
INSERT INTO public.lugar VALUES (71826, 'José Antonio Páez', 'parroquia', 283);
INSERT INTO public.lugar VALUES (71827, 'Guásimos', 'parroquia', 284);
INSERT INTO public.lugar VALUES (71828, 'Independencia', 'parroquia', 285);
INSERT INTO public.lugar VALUES (71829, 'Juan Germán Roscio', 'parroquia', 285);
INSERT INTO public.lugar VALUES (71830, 'Román Cárdenas', 'parroquia', 285);
INSERT INTO public.lugar VALUES (71831, 'Jáuregui', 'parroquia', 286);
INSERT INTO public.lugar VALUES (71832, 'Emilio Constantino Guerrero', 'parroquia', 286);
INSERT INTO public.lugar VALUES (71833, 'Monseñor Miguel Antonio Salas', 'parroquia', 286);
INSERT INTO public.lugar VALUES (71834, 'José María Vargas', 'parroquia', 287);
INSERT INTO public.lugar VALUES (71835, 'Junín', 'parroquia', 288);
INSERT INTO public.lugar VALUES (71836, 'La Petrólea', 'parroquia', 288);
INSERT INTO public.lugar VALUES (71837, 'Quinimarí', 'parroquia', 288);
INSERT INTO public.lugar VALUES (71838, 'Bramón', 'parroquia', 288);
INSERT INTO public.lugar VALUES (71839, 'Libertad', 'parroquia', 289);
INSERT INTO public.lugar VALUES (71840, 'Cipriano Castro', 'parroquia', 289);
INSERT INTO public.lugar VALUES (71841, 'Manuel Felipe Rugeles', 'parroquia', 289);
INSERT INTO public.lugar VALUES (71842, 'Libertador', 'parroquia', 290);
INSERT INTO public.lugar VALUES (71843, 'Doradas', 'parroquia', 290);
INSERT INTO public.lugar VALUES (71844, 'Emeterio Ochoa', 'parroquia', 290);
INSERT INTO public.lugar VALUES (71845, 'San Joaquín de Navay', 'parroquia', 290);
INSERT INTO public.lugar VALUES (71846, 'Lobatera', 'parroquia', 291);
INSERT INTO public.lugar VALUES (71847, 'Constitución', 'parroquia', 291);
INSERT INTO public.lugar VALUES (71848, 'Michelena', 'parroquia', 292);
INSERT INTO public.lugar VALUES (71849, 'Panamericano', 'parroquia', 293);
INSERT INTO public.lugar VALUES (71850, 'La Palmita', 'parroquia', 293);
INSERT INTO public.lugar VALUES (71851, 'Pedro María Ureña', 'parroquia', 294);
INSERT INTO public.lugar VALUES (71852, 'Nueva Arcadia', 'parroquia', 294);
INSERT INTO public.lugar VALUES (71853, 'Delicias', 'parroquia', 295);
INSERT INTO public.lugar VALUES (71854, 'Samuel Darío Maldonado', 'parroquia', 296);
INSERT INTO public.lugar VALUES (71855, 'Boconó', 'parroquia', 296);
INSERT INTO public.lugar VALUES (71856, 'Hernández', 'parroquia', 296);
INSERT INTO public.lugar VALUES (71857, 'La Concordia', 'parroquia', 297);
INSERT INTO public.lugar VALUES (71858, 'San Juan Bautista', 'parroquia', 297);
INSERT INTO public.lugar VALUES (71859, 'Pedro María Morantes', 'parroquia', 297);
INSERT INTO public.lugar VALUES (71860, 'San Sebastián', 'parroquia', 297);
INSERT INTO public.lugar VALUES (71861, 'Dr. Francisco Romero Lobo', 'parroquia', 297);
INSERT INTO public.lugar VALUES (71862, 'Seboruco', 'parroquia', 298);
INSERT INTO public.lugar VALUES (71863, 'Simón Rodríguez', 'parroquia', 299);
INSERT INTO public.lugar VALUES (71864, 'Sucre', 'parroquia', 300);
INSERT INTO public.lugar VALUES (71865, 'Eleazar López Contreras', 'parroquia', 300);
INSERT INTO public.lugar VALUES (71866, 'San Pablo', 'parroquia', 300);
INSERT INTO public.lugar VALUES (71867, 'Torbes', 'parroquia', 301);
INSERT INTO public.lugar VALUES (71868, 'Uribante', 'parroquia', 302);
INSERT INTO public.lugar VALUES (71869, 'Cárdenas', 'parroquia', 302);
INSERT INTO public.lugar VALUES (71870, 'Juan Pablo Peñalosa', 'parroquia', 302);
INSERT INTO public.lugar VALUES (71871, 'Potosí', 'parroquia', 302);
INSERT INTO public.lugar VALUES (71872, 'San Judas Tadeo', 'parroquia', 303);
INSERT INTO public.lugar VALUES (71873, 'Araguaney', 'parroquia', 304);
INSERT INTO public.lugar VALUES (71874, 'El Jaguito', 'parroquia', 304);
INSERT INTO public.lugar VALUES (71875, 'La Esperanza', 'parroquia', 304);
INSERT INTO public.lugar VALUES (71876, 'Santa Isabel', 'parroquia', 304);
INSERT INTO public.lugar VALUES (71877, 'Boconó', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71878, 'El Carmen', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71879, 'Mosquey', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71880, 'Ayacucho', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71881, 'Burbusay', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71882, 'General Ribas', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71883, 'Guaramacal', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71884, 'Vega de Guaramacal', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71885, 'Monseñor Jáuregui', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71886, 'Rafael Rangel', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71887, 'San Miguel', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71888, 'San José', 'parroquia', 305);
INSERT INTO public.lugar VALUES (71889, 'Sabana Grande', 'parroquia', 306);
INSERT INTO public.lugar VALUES (71890, 'Cheregüé', 'parroquia', 306);
INSERT INTO public.lugar VALUES (71891, 'Granados', 'parroquia', 306);
INSERT INTO public.lugar VALUES (71892, 'Arnoldo Gabaldón', 'parroquia', 307);
INSERT INTO public.lugar VALUES (71893, 'Bolivia', 'parroquia', 307);
INSERT INTO public.lugar VALUES (71894, 'Carrillo', 'parroquia', 307);
INSERT INTO public.lugar VALUES (71895, 'Cegarra', 'parroquia', 307);
INSERT INTO public.lugar VALUES (71896, 'Chejendé', 'parroquia', 307);
INSERT INTO public.lugar VALUES (71897, 'Manuel Salvador Ulloa', 'parroquia', 307);
INSERT INTO public.lugar VALUES (71898, 'San José', 'parroquia', 307);
INSERT INTO public.lugar VALUES (71899, 'Carache', 'parroquia', 308);
INSERT INTO public.lugar VALUES (71900, 'La Concepción', 'parroquia', 308);
INSERT INTO public.lugar VALUES (71901, 'Cuicas', 'parroquia', 308);
INSERT INTO public.lugar VALUES (71902, 'Panamericana', 'parroquia', 308);
INSERT INTO public.lugar VALUES (71903, 'Santa Cruz', 'parroquia', 308);
INSERT INTO public.lugar VALUES (71904, 'Escuque', 'parroquia', 309);
INSERT INTO public.lugar VALUES (71905, 'La Unión', 'parroquia', 309);
INSERT INTO public.lugar VALUES (71906, 'Santa Rita', 'parroquia', 309);
INSERT INTO public.lugar VALUES (71907, 'Sabana Libre', 'parroquia', 309);
INSERT INTO public.lugar VALUES (71908, 'El Socorro', 'parroquia', 310);
INSERT INTO public.lugar VALUES (71909, 'Los Caprichos', 'parroquia', 310);
INSERT INTO public.lugar VALUES (71910, 'Antonio José de Sucre', 'parroquia', 310);
INSERT INTO public.lugar VALUES (71911, 'Campo Elías', 'parroquia', 311);
INSERT INTO public.lugar VALUES (71912, 'Arnoldo Gabaldón', 'parroquia', 311);
INSERT INTO public.lugar VALUES (71913, 'Santa Apolonia', 'parroquia', 312);
INSERT INTO public.lugar VALUES (71914, 'El Progreso', 'parroquia', 312);
INSERT INTO public.lugar VALUES (71915, 'La Ceiba', 'parroquia', 312);
INSERT INTO public.lugar VALUES (71916, 'Tres de Febrero', 'parroquia', 312);
INSERT INTO public.lugar VALUES (71917, 'El Dividive', 'parroquia', 313);
INSERT INTO public.lugar VALUES (71918, 'Agua Santa', 'parroquia', 313);
INSERT INTO public.lugar VALUES (71919, 'Agua Caliente', 'parroquia', 313);
INSERT INTO public.lugar VALUES (71920, 'El Cenizo', 'parroquia', 313);
INSERT INTO public.lugar VALUES (71921, 'Valerita', 'parroquia', 313);
INSERT INTO public.lugar VALUES (71922, 'Monte Carmelo', 'parroquia', 314);
INSERT INTO public.lugar VALUES (71923, 'Buena Vista', 'parroquia', 314);
INSERT INTO public.lugar VALUES (71924, 'Santa María del Horcón', 'parroquia', 314);
INSERT INTO public.lugar VALUES (71925, 'Motatán', 'parroquia', 315);
INSERT INTO public.lugar VALUES (71926, 'El Baño', 'parroquia', 315);
INSERT INTO public.lugar VALUES (71927, 'Jalisco', 'parroquia', 315);
INSERT INTO public.lugar VALUES (71928, 'Pampán', 'parroquia', 316);
INSERT INTO public.lugar VALUES (71929, 'Flor de Patria', 'parroquia', 316);
INSERT INTO public.lugar VALUES (71930, 'La Paz', 'parroquia', 316);
INSERT INTO public.lugar VALUES (71931, 'Santa Ana', 'parroquia', 316);
INSERT INTO public.lugar VALUES (71932, 'Pampanito', 'parroquia', 317);
INSERT INTO public.lugar VALUES (71933, 'La Concepción', 'parroquia', 317);
INSERT INTO public.lugar VALUES (71934, 'Pampanito II', 'parroquia', 317);
INSERT INTO public.lugar VALUES (71935, 'Betijoque', 'parroquia', 318);
INSERT INTO public.lugar VALUES (71936, 'José Gregorio Hernández', 'parroquia', 318);
INSERT INTO public.lugar VALUES (71937, 'La Pueblita', 'parroquia', 318);
INSERT INTO public.lugar VALUES (71938, 'Los Cedros', 'parroquia', 318);
INSERT INTO public.lugar VALUES (71939, 'Carvajal', 'parroquia', 319);
INSERT INTO public.lugar VALUES (71940, 'Campo Alegre', 'parroquia', 319);
INSERT INTO public.lugar VALUES (71941, 'Antonio Nicolás Briceño', 'parroquia', 319);
INSERT INTO public.lugar VALUES (71942, 'José Leonardo Suárez', 'parroquia', 319);
INSERT INTO public.lugar VALUES (71943, 'Sabana de Mendoza', 'parroquia', 320);
INSERT INTO public.lugar VALUES (71944, 'Junín', 'parroquia', 320);
INSERT INTO public.lugar VALUES (71945, 'Valmore Rodríguez', 'parroquia', 320);
INSERT INTO public.lugar VALUES (71946, 'El Paraíso', 'parroquia', 320);
INSERT INTO public.lugar VALUES (71947, 'Andrés Linares', 'parroquia', 321);
INSERT INTO public.lugar VALUES (71948, 'Chiquinquirá', 'parroquia', 321);
INSERT INTO public.lugar VALUES (71949, 'Cristóbal Mendoza', 'parroquia', 321);
INSERT INTO public.lugar VALUES (71950, 'Cruz Carrillo', 'parroquia', 321);
INSERT INTO public.lugar VALUES (71951, 'Matriz', 'parroquia', 321);
INSERT INTO public.lugar VALUES (71952, 'Monseñor Carrillo', 'parroquia', 321);
INSERT INTO public.lugar VALUES (71953, 'Tres Esquinas', 'parroquia', 321);
INSERT INTO public.lugar VALUES (71954, 'Cabimbú', 'parroquia', 322);
INSERT INTO public.lugar VALUES (71955, 'Jajó', 'parroquia', 322);
INSERT INTO public.lugar VALUES (71956, 'La Mesa de Esnujaque', 'parroquia', 322);
INSERT INTO public.lugar VALUES (71957, 'Santiago', 'parroquia', 322);
INSERT INTO public.lugar VALUES (71958, 'Tuñame', 'parroquia', 322);
INSERT INTO public.lugar VALUES (71959, 'La Quebrada', 'parroquia', 322);
INSERT INTO public.lugar VALUES (71960, 'Juan Ignacio Montilla', 'parroquia', 323);
INSERT INTO public.lugar VALUES (71961, 'La Beatriz', 'parroquia', 323);
INSERT INTO public.lugar VALUES (71962, 'La Puerta', 'parroquia', 323);
INSERT INTO public.lugar VALUES (71963, 'Mendoza del Valle de Momboy', 'parroquia', 323);
INSERT INTO public.lugar VALUES (71964, 'Mercedes Díaz', 'parroquia', 323);
INSERT INTO public.lugar VALUES (71965, 'San Luis', 'parroquia', 323);
INSERT INTO public.lugar VALUES (71966, 'Caraballeda', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71967, 'Carayaca', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71968, 'Carlos Soublette', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71969, 'Caruao Chuspa', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71970, 'Catia La Mar', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71971, 'El Junko', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71972, 'La Guaira', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71973, 'Macuto', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71974, 'Maiquetía', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71975, 'Naiguatá', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71976, 'Urimare', 'parroquia', 324);
INSERT INTO public.lugar VALUES (71977, 'Arístides Bastidas', 'parroquia', 325);
INSERT INTO public.lugar VALUES (71978, 'Bolívar', 'parroquia', 326);
INSERT INTO public.lugar VALUES (71979, 'Chivacoa', 'parroquia', 327);
INSERT INTO public.lugar VALUES (71980, 'Campo Elías', 'parroquia', 327);
INSERT INTO public.lugar VALUES (71981, 'Cocorote', 'parroquia', 328);
INSERT INTO public.lugar VALUES (71982, 'Independencia', 'parroquia', 329);
INSERT INTO public.lugar VALUES (71983, 'José Antonio Páez', 'parroquia', 330);
INSERT INTO public.lugar VALUES (71984, 'La Trinidad', 'parroquia', 331);
INSERT INTO public.lugar VALUES (71985, 'Manuel Monge', 'parroquia', 332);
INSERT INTO public.lugar VALUES (71986, 'Nirgua', 'parroquia', 333);
INSERT INTO public.lugar VALUES (71987, 'Salóm', 'parroquia', 333);
INSERT INTO public.lugar VALUES (71988, 'Temerla', 'parroquia', 333);
INSERT INTO public.lugar VALUES (71989, 'San Andrés', 'parroquia', 334);
INSERT INTO public.lugar VALUES (71990, 'Yaritagua', 'parroquia', 334);
INSERT INTO public.lugar VALUES (71991, 'San Javier', 'parroquia', 335);
INSERT INTO public.lugar VALUES (71992, 'Albarico', 'parroquia', 335);
INSERT INTO public.lugar VALUES (71993, 'San Felipe', 'parroquia', 335);
INSERT INTO public.lugar VALUES (71994, 'Sucre', 'parroquia', 336);
INSERT INTO public.lugar VALUES (71995, 'Urachiche', 'parroquia', 337);
INSERT INTO public.lugar VALUES (71996, 'El Guayabo', 'parroquia', 338);
INSERT INTO public.lugar VALUES (71997, 'Farriar', 'parroquia', 338);
INSERT INTO public.lugar VALUES (71998, 'Isla de Toas', 'parroquia', 339);
INSERT INTO public.lugar VALUES (71999, 'Monagas', 'parroquia', 339);
INSERT INTO public.lugar VALUES (72000, 'San Fernando', 'parroquia', 339);
INSERT INTO public.lugar VALUES (72001, 'San Timoteo', 'parroquia', 340);
INSERT INTO public.lugar VALUES (72002, 'General Urdaneta', 'parroquia', 340);
INSERT INTO public.lugar VALUES (72003, 'Libertador', 'parroquia', 340);
INSERT INTO public.lugar VALUES (72004, 'Marcelino Briceño', 'parroquia', 340);
INSERT INTO public.lugar VALUES (72005, 'Pueblo Nuevo', 'parroquia', 340);
INSERT INTO public.lugar VALUES (72006, 'Manuel Guanipa Matos', 'parroquia', 340);
INSERT INTO public.lugar VALUES (72007, 'Ambrosio', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72008, 'Carmen Herrera', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72009, 'La Rosa', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72010, 'Germán Ríos Linares', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72011, 'San Benito', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72012, 'Rómulo Betancourt', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72013, 'Jorge Hernández', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72014, 'Punta Gorda', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72015, 'Arístides Calvani', 'parroquia', 341);
INSERT INTO public.lugar VALUES (72016, 'Encontrados', 'parroquia', 342);
INSERT INTO public.lugar VALUES (72017, 'Udón Pérez', 'parroquia', 342);
INSERT INTO public.lugar VALUES (72018, 'Moralito', 'parroquia', 343);
INSERT INTO public.lugar VALUES (72019, 'San Carlos del Zulia', 'parroquia', 343);
INSERT INTO public.lugar VALUES (72020, 'Santa Cruz del Zulia', 'parroquia', 343);
INSERT INTO public.lugar VALUES (72021, 'Santa Bárbara', 'parroquia', 343);
INSERT INTO public.lugar VALUES (72022, 'Urribarrí', 'parroquia', 343);
INSERT INTO public.lugar VALUES (72023, 'Carlos Quevedo', 'parroquia', 344);
INSERT INTO public.lugar VALUES (72024, 'Francisco Javier Pulgar', 'parroquia', 344);
INSERT INTO public.lugar VALUES (72025, 'Simón Rodríguez', 'parroquia', 344);
INSERT INTO public.lugar VALUES (72026, 'Guamo-Gavilanes', 'parroquia', 344);
INSERT INTO public.lugar VALUES (72027, 'Sinamaica', 'parroquia', 345);
INSERT INTO public.lugar VALUES (72028, 'Alta Guajira', 'parroquia', 345);
INSERT INTO public.lugar VALUES (72029, 'Elías Sánchez Rubio', 'parroquia', 345);
INSERT INTO public.lugar VALUES (72030, 'Guajira', 'parroquia', 345);
INSERT INTO public.lugar VALUES (72031, 'La Concepción', 'parroquia', 346);
INSERT INTO public.lugar VALUES (72032, 'San José', 'parroquia', 346);
INSERT INTO public.lugar VALUES (72033, 'Mariano Parra León', 'parroquia', 346);
INSERT INTO public.lugar VALUES (72034, 'José Ramón Yépez', 'parroquia', 346);
INSERT INTO public.lugar VALUES (72035, 'Jesús María Semprún', 'parroquia', 347);
INSERT INTO public.lugar VALUES (72036, 'Barí', 'parroquia', 347);
INSERT INTO public.lugar VALUES (72037, 'Concepción', 'parroquia', 348);
INSERT INTO public.lugar VALUES (72038, 'Andrés Bello', 'parroquia', 348);
INSERT INTO public.lugar VALUES (72039, 'Chiquinquirá', 'parroquia', 348);
INSERT INTO public.lugar VALUES (72040, 'El Carmelo', 'parroquia', 348);
INSERT INTO public.lugar VALUES (72041, 'Potreritos', 'parroquia', 348);
INSERT INTO public.lugar VALUES (72042, 'Libertad', 'parroquia', 349);
INSERT INTO public.lugar VALUES (72043, 'Alonso de Ojeda', 'parroquia', 349);
INSERT INTO public.lugar VALUES (72044, 'Venezuela', 'parroquia', 349);
INSERT INTO public.lugar VALUES (72045, 'Eleazar López Contreras', 'parroquia', 349);
INSERT INTO public.lugar VALUES (72046, 'Campo Lara', 'parroquia', 349);
INSERT INTO public.lugar VALUES (72047, 'Bartolomé de las Casas', 'parroquia', 350);
INSERT INTO public.lugar VALUES (72048, 'Libertad', 'parroquia', 350);
INSERT INTO public.lugar VALUES (72049, 'Río Negro', 'parroquia', 350);
INSERT INTO public.lugar VALUES (72050, 'San José de Perijá', 'parroquia', 350);
INSERT INTO public.lugar VALUES (72051, 'San Rafael', 'parroquia', 351);
INSERT INTO public.lugar VALUES (72052, 'La Sierrita', 'parroquia', 351);
INSERT INTO public.lugar VALUES (72053, 'Las Parcelas', 'parroquia', 351);
INSERT INTO public.lugar VALUES (72054, 'Luis de Vicente', 'parroquia', 351);
INSERT INTO public.lugar VALUES (72055, 'Monseñor Marcos Sergio Godoy', 'parroquia', 351);
INSERT INTO public.lugar VALUES (72056, 'Ricaurte', 'parroquia', 351);
INSERT INTO public.lugar VALUES (72057, 'Tamare', 'parroquia', 351);
INSERT INTO public.lugar VALUES (72058, 'Antonio Borjas Romero', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72059, 'Bolívar', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72060, 'Cacique Mara', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72061, 'Carracciolo Parra Pérez', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72062, 'Cecilio Acosta', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72063, 'Cristo de Aranza', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72064, 'Coquivacoa', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72065, 'Chiquinquirá', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72066, 'Francisco Eugenio Bustamante', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72067, 'Idelfonzo Vásquez', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72068, 'Juana de Ávila', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72069, 'Luis Hurtado Higuera', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72070, 'Manuel Dagnino', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72071, 'Olegario Villalobos', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72072, 'Raúl Leoni', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72073, 'Santa Lucía', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72074, 'Venancio Pulgar', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72075, 'San Isidro', 'parroquia', 352);
INSERT INTO public.lugar VALUES (72076, 'Altagracia', 'parroquia', 353);
INSERT INTO public.lugar VALUES (72077, 'Faría', 'parroquia', 353);
INSERT INTO public.lugar VALUES (72078, 'Ana María Campos', 'parroquia', 353);
INSERT INTO public.lugar VALUES (72079, 'San Antonio', 'parroquia', 353);
INSERT INTO public.lugar VALUES (72080, 'San José', 'parroquia', 353);
INSERT INTO public.lugar VALUES (72081, 'Donaldo García', 'parroquia', 354);
INSERT INTO public.lugar VALUES (72082, 'El Rosario', 'parroquia', 354);
INSERT INTO public.lugar VALUES (72083, 'Sixto Zambrano', 'parroquia', 354);
INSERT INTO public.lugar VALUES (72084, 'San Francisco', 'parroquia', 355);
INSERT INTO public.lugar VALUES (72085, 'El Bajo', 'parroquia', 355);
INSERT INTO public.lugar VALUES (72086, 'Domitila Flores', 'parroquia', 355);
INSERT INTO public.lugar VALUES (72087, 'Francisco Ochoa', 'parroquia', 355);
INSERT INTO public.lugar VALUES (72088, 'Los Cortijos', 'parroquia', 355);
INSERT INTO public.lugar VALUES (72089, 'Marcial Hernández', 'parroquia', 355);
INSERT INTO public.lugar VALUES (72090, 'José Domingo Rus', 'parroquia', 355);
INSERT INTO public.lugar VALUES (72091, 'Santa Rita', 'parroquia', 356);
INSERT INTO public.lugar VALUES (72092, 'El Mene', 'parroquia', 356);
INSERT INTO public.lugar VALUES (72093, 'Pedro Lucas Urribarrí', 'parroquia', 356);
INSERT INTO public.lugar VALUES (72094, 'José Cenobio Urribarrí', 'parroquia', 356);
INSERT INTO public.lugar VALUES (72095, 'Rafael Maria Baralt', 'parroquia', 357);
INSERT INTO public.lugar VALUES (72096, 'Manuel Manrique', 'parroquia', 357);
INSERT INTO public.lugar VALUES (72097, 'Rafael Urdaneta', 'parroquia', 357);
INSERT INTO public.lugar VALUES (72098, 'Bobures', 'parroquia', 358);
INSERT INTO public.lugar VALUES (72099, 'Gibraltar', 'parroquia', 358);
INSERT INTO public.lugar VALUES (72100, 'Heras', 'parroquia', 358);
INSERT INTO public.lugar VALUES (72101, 'Monseñor Arturo Álvarez', 'parroquia', 358);
INSERT INTO public.lugar VALUES (72102, 'Rómulo Gallegos', 'parroquia', 358);
INSERT INTO public.lugar VALUES (72103, 'El Batey', 'parroquia', 358);
INSERT INTO public.lugar VALUES (72104, 'Rafael Urdaneta', 'parroquia', 359);
INSERT INTO public.lugar VALUES (72105, 'La Victoria', 'parroquia', 359);
INSERT INTO public.lugar VALUES (72106, 'Raúl Cuenca', 'parroquia', 359);
INSERT INTO public.lugar VALUES (72107, 'Altagracia', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72108, 'Antímano', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72109, 'Caricuao', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72110, 'Catedral', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72111, 'Coche', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72112, 'El Junquito', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72113, 'El Paraíso', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72114, 'El Recreo', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72115, 'El Valle', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72116, 'La Candelaria', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72117, 'La Pastora', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72118, 'La Vega', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72119, 'Macarao', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72120, 'San Agustín', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72121, 'San Bernardino', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72122, 'San José', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72123, 'San Juan', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72124, 'San Pedro', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72125, 'Santa Rosalía', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72126, 'Santa Teresa', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72127, 'Sucre (Catia)', 'parroquia', 360);
INSERT INTO public.lugar VALUES (72128, '23 de enero', 'parroquia', 360);


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.proveedor VALUES (1, 'J345678901', 'Maltas Venezolanas', 'Maltas Venezolanas C.A.', 'https://www.maltasvenezolanas.com', 'Zona Industrial Los Cortijos, Caracas', 360);
INSERT INTO public.proveedor VALUES (2, 'J345678902', 'Lupulos del Caribe', 'Lupulos del Caribe S.A.', 'https://www.lupulosdelcaribe.com', 'Complejo Agroindustrial Valencia, Carabobo', 115);
INSERT INTO public.proveedor VALUES (3, 'J345678903', 'Levaduras Tropicales', 'Levaduras Tropicales C.A.', 'https://www.levadurastropicales.com', 'Parque Industrial Maracaibo, Zulia', 352);
INSERT INTO public.proveedor VALUES (4, 'J345678904', 'Envases Cerveceros Unidos', 'Envases Cerveceros Unidos S.A.', 'https://www.envasescerveceros.com', 'Zona Industrial La Victoria, Aragua', 61);
INSERT INTO public.proveedor VALUES (5, 'J345678905', 'Ingredientes Premium', 'Ingredientes Premium C.A.', 'https://www.ingredientespremium.com', 'Sector Industrial Barquisimeto, Lara', 171);
INSERT INTO public.proveedor VALUES (6, 'J345678906', 'Tecnologia Cervecera', 'Tecnologia Cervecera S.R.L.', 'https://www.tecnologiacervecera.com', 'Av. Principal Puerto La Cruz, Anzoategui', 43);
INSERT INTO public.proveedor VALUES (7, 'J345678907', 'Distribuidora Andina Supplies', 'Distribuidora Andina Supplies C.A.', 'https://www.andinasupplies.com', 'Zona Franca Merida, Merida', 189);
INSERT INTO public.proveedor VALUES (8, 'J345678908', 'Equipos Industriales del Sur', 'Equipos Industriales del Sur S.A.', 'https://www.equipossur.com', 'Parque Industrial Ciudad Bolivar, Bolivar', 95);
INSERT INTO public.proveedor VALUES (9, 'J345678909', 'Materias Primas Centrales', 'Materias Primas Centrales C.A.', 'https://www.materiasprimas.com', 'Centro Industrial Los Teques, Miranda', 210);
INSERT INTO public.proveedor VALUES (10, 'J345678910', 'Suministros Cerveceros Falcon', 'Suministros Cerveceros Falcon S.A.', 'https://www.suministrosfalcon.com', 'Zona Petrolera Punto Fijo, Falcon', 133);
INSERT INTO public.proveedor VALUES (11, 'J345678911', 'Insumos Especializados', 'Insumos Especializados C.A.', 'https://www.insumosespecializados.com', 'Complejo Industrial Guarenas, Miranda', 217);
INSERT INTO public.proveedor VALUES (12, 'J345678912', 'Maquinaria Cervecera Nacional', 'Maquinaria Cervecera Nacional S.A.', 'https://www.maquinarianacional.com', 'Sector Industrial Maturin, Monagas', 229);
INSERT INTO public.proveedor VALUES (13, 'J345678913', 'Productos Organicos del Llano', 'Productos Organicos del Llano C.A.', 'https://www.organicosllano.com', 'Zona Agricola Acarigua, Portuguesa', 247);
INSERT INTO public.proveedor VALUES (14, 'J345678914', 'Conservantes y Aditivos', 'Conservantes y Aditivos S.R.L.', 'https://www.conservantesaditivos.com', 'Parque Industrial Carora, Lara', 176);
INSERT INTO public.proveedor VALUES (15, 'J345678915', 'Sistemas de Filtrado', 'Sistemas de Filtrado C.A.', 'https://www.sistemasfiltrado.com', 'Zona Industrial Valera, Trujillo', 323);
INSERT INTO public.proveedor VALUES (16, 'J345678916', 'Embalajes Especiales', 'Embalajes Especiales S.A.', 'https://www.embalajesespeciales.com', 'Puerto La Guaira, Vargas', 324);
INSERT INTO public.proveedor VALUES (17, 'J345678917', 'Laboratorios de Control', 'Laboratorios de Control C.A.', 'https://www.laboratorioscontrol.com', 'Ciudad Universitaria, Caracas', 360);
INSERT INTO public.proveedor VALUES (18, 'J345678918', 'Refrigeracion Industrial', 'Refrigeracion Industrial S.A.', 'https://www.refrigeracionindustrial.com', 'Zona Industrial San Felix, Bolivar', 95);
INSERT INTO public.proveedor VALUES (19, 'J345678919', 'Automatizacion Cervecera', 'Automatizacion Cervecera C.A.', 'https://www.automatizacioncervecera.com', 'Parque Tecnologico Valencia, Carabobo', 115);
INSERT INTO public.proveedor VALUES (20, 'J345678920', 'Servicios Integrales Cerveceros', 'Servicios Integrales Cerveceros S.A.', 'https://www.serviciosintegrales.com', 'Complejo Petroquimico Jose, Anzoategui', 33);


--
-- Data for Name: tienda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tienda VALUES (1, 'Cerveceria Central Caracas', 'Av. Francisco de Miranda 500, Caracas', 'FISICA', 360);
INSERT INTO public.tienda VALUES (2, 'Beer Store Valencia', 'Centro Comercial Sambil, Valencia', 'FISICA', 115);
INSERT INTO public.tienda VALUES (3, 'Maracaibo Beer House', 'Av. Bella Vista 123, Maracaibo', 'FISICA', 352);
INSERT INTO public.tienda VALUES (4, 'Cerveza Online Venezuela', 'Plataforma Digital Nacional', 'ONLINE', 360);
INSERT INTO public.tienda VALUES (5, 'Barquisimeto Brewery Shop', 'Av. Venezuela 456, Barquisimeto', 'FISICA', 171);
INSERT INTO public.tienda VALUES (6, 'Puerto La Cruz Beer Center', 'Paseo Colon 789, Puerto La Cruz', 'FISICA', 43);
INSERT INTO public.tienda VALUES (7, 'Andean Beer Store', 'Av. Los Proceres 321, Merida', 'FISICA', 189);
INSERT INTO public.tienda VALUES (8, 'Craft Beer Boutique', 'Torre Financiera, Piso 5, Caracas', 'FISICA', 360);
INSERT INTO public.tienda VALUES (9, 'Digital Beer Market', 'E-commerce Platform', 'ONLINE', 360);
INSERT INTO public.tienda VALUES (10, 'Regional Beer Distribution', 'Zona Industrial Sur, Ciudad Bolivar', 'FISICA', 95);


--
-- Data for Name: afiliacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.afiliacion VALUES (1, 'Contrato Suministro Maltas', 250000, 1, 1);
INSERT INTO public.afiliacion VALUES (2, 'Acuerdo Lupulos Premium', 180000, 2, 2);
INSERT INTO public.afiliacion VALUES (3, 'Contrato Levaduras Especiales', 95000, 3, 3);
INSERT INTO public.afiliacion VALUES (4, 'Suministro Envases Anuales', 320000, 4, 4);
INSERT INTO public.afiliacion VALUES (5, 'Ingredientes Artesanales', 140000, 5, 5);
INSERT INTO public.afiliacion VALUES (6, 'Tecnologia y Equipos', 280000, 6, 6);
INSERT INTO public.afiliacion VALUES (7, 'Distribucion Regional Andina', 200000, 7, 7);
INSERT INTO public.afiliacion VALUES (8, 'Equipamiento Industrial', 450000, 8, 8);
INSERT INTO public.afiliacion VALUES (9, 'Materias Primas Integrales', 350000, 9, 9);
INSERT INTO public.afiliacion VALUES (10, 'Suministros Especializados', 160000, 10, 10);


--
-- Data for Name: estatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.estatus VALUES (1, 'PENDIENTE', 'Estado inicial de cualquier proceso, esperando aprobacion o procesamiento.');
INSERT INTO public.estatus VALUES (2, 'APROBADO', 'Proceso aprobado y autorizado para continuar con la siguiente etapa.');
INSERT INTO public.estatus VALUES (3, 'RECHAZADO', 'Proceso rechazado por no cumplir con los requisitos establecidos.');
INSERT INTO public.estatus VALUES (4, 'EN PROCESO', 'Proceso en ejecucion, siendo trabajado actualmente.');
INSERT INTO public.estatus VALUES (5, 'FINALIZADO', 'Proceso completado exitosamente y cerrado.');
INSERT INTO public.estatus VALUES (6, 'LISTO PARA LA ENTREGA', 'Pedido listo para ser entregado al cliente');
INSERT INTO public.estatus VALUES (7, 'ENTREGADO', 'Pedido entregado al cliente');


--
-- Data for Name: afi_est; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.afi_est VALUES (646, '2024-01-01', '2024-01-02', 1, 1);
INSERT INTO public.afi_est VALUES (647, '2024-01-02', '2024-01-03', 1, 2);
INSERT INTO public.afi_est VALUES (648, '2024-01-03', NULL, 1, 5);
INSERT INTO public.afi_est VALUES (649, '2024-01-05', '2024-01-06', 2, 1);
INSERT INTO public.afi_est VALUES (650, '2024-01-06', '2024-01-07', 2, 2);
INSERT INTO public.afi_est VALUES (651, '2024-01-07', NULL, 2, 5);
INSERT INTO public.afi_est VALUES (652, '2024-01-10', '2024-01-11', 3, 1);
INSERT INTO public.afi_est VALUES (653, '2024-01-11', '2024-01-12', 3, 2);
INSERT INTO public.afi_est VALUES (654, '2024-01-12', NULL, 3, 5);
INSERT INTO public.afi_est VALUES (655, '2024-01-15', '2024-01-16', 4, 1);
INSERT INTO public.afi_est VALUES (656, '2024-01-16', '2024-01-17', 4, 2);
INSERT INTO public.afi_est VALUES (657, '2024-01-17', NULL, 4, 5);
INSERT INTO public.afi_est VALUES (658, '2024-01-20', '2024-01-21', 5, 1);
INSERT INTO public.afi_est VALUES (659, '2024-01-21', '2024-01-22', 5, 2);
INSERT INTO public.afi_est VALUES (660, '2024-01-22', NULL, 5, 5);


--
-- Data for Name: almacen; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.almacen VALUES (1, 'Almacén Central Caracas', 'Almacén principal de la tienda Cervecería Central Caracas con capacidad para 5000 unidades.', 1);
INSERT INTO public.almacen VALUES (2, 'Depósito Valencia', 'Almacén de distribución regional para el área metropolitana de Valencia.', 2);
INSERT INTO public.almacen VALUES (3, 'Bodega Maracaibo', 'Centro de almacenamiento para la región occidental del país.', 3);
INSERT INTO public.almacen VALUES (4, 'Centro Digital Nacional', 'Almacén virtual para gestión de inventario online y logística digital.', 4);
INSERT INTO public.almacen VALUES (5, 'Almacén Barquisimeto', 'Depósito regional para atender la demanda del centro-oeste venezolano.', 5);
INSERT INTO public.almacen VALUES (6, 'Bodega Puerto La Cruz', 'Almacén para distribución en la región oriental del país.', 6);
INSERT INTO public.almacen VALUES (7, 'Depósito Andino Mérida', 'Centro de almacenamiento especializado para la región andina.', 7);
INSERT INTO public.almacen VALUES (8, 'Almacén Boutique Premium', 'Depósito especializado para productos premium y de colección.', 8);
INSERT INTO public.almacen VALUES (9, 'Centro Logístico Digital', 'Hub tecnológico para gestión automatizada de inventario online.', 9);
INSERT INTO public.almacen VALUES (10, 'Almacén Regional Sur', 'Centro de distribución para atender la región sur del país.', 10);


--
-- Data for Name: lugar_tienda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lugar_tienda VALUES (1, 'Cervezas Nacionales', 'ZONA', NULL, 1);
INSERT INTO public.lugar_tienda VALUES (2, 'Cervezas Importadas', 'ZONA', NULL, 1);
INSERT INTO public.lugar_tienda VALUES (3, 'Cervezas Nacionales', 'ZONA', NULL, 2);
INSERT INTO public.lugar_tienda VALUES (4, 'Cervezas Importadas', 'ZONA', NULL, 2);
INSERT INTO public.lugar_tienda VALUES (5, '1', 'PASILLO', 1, 1);
INSERT INTO public.lugar_tienda VALUES (6, '2', 'PASILLO', 1, 1);
INSERT INTO public.lugar_tienda VALUES (7, '3', 'PASILLO', 2, 1);
INSERT INTO public.lugar_tienda VALUES (8, '1', 'PASILLO', 3, 2);
INSERT INTO public.lugar_tienda VALUES (9, '2', 'PASILLO', 3, 2);
INSERT INTO public.lugar_tienda VALUES (10, '3', 'PASILLO', 4, 2);
INSERT INTO public.lugar_tienda VALUES (11, '1.1', 'ZONA-PASILLO', 5, 1);
INSERT INTO public.lugar_tienda VALUES (12, '1.2', 'ZONA-PASILLO', 5, 1);
INSERT INTO public.lugar_tienda VALUES (13, '2.1', 'ZONA-PASILLO', 6, 1);
INSERT INTO public.lugar_tienda VALUES (14, '2.2', 'ZONA-PASILLO', 6, 1);
INSERT INTO public.lugar_tienda VALUES (15, '3.1', 'ZONA-PASILLO', 7, 1);
INSERT INTO public.lugar_tienda VALUES (16, '3.2', 'ZONA-PASILLO', 7, 1);
INSERT INTO public.lugar_tienda VALUES (17, '1.1', 'ZONA-PASILLO', 8, 2);
INSERT INTO public.lugar_tienda VALUES (18, '1.2', 'ZONA-PASILLO', 8, 2);
INSERT INTO public.lugar_tienda VALUES (19, '2.1', 'ZONA-PASILLO', 9, 2);
INSERT INTO public.lugar_tienda VALUES (20, '2.2', 'ZONA-PASILLO', 9, 2);
INSERT INTO public.lugar_tienda VALUES (21, '3.1', 'ZONA-PASILLO', 10, 2);
INSERT INTO public.lugar_tienda VALUES (22, '3.2', 'ZONA-PASILLO', 10, 2);


--
-- Data for Name: anaquel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.anaquel VALUES (1, 101, 11);
INSERT INTO public.anaquel VALUES (2, 201, 11);
INSERT INTO public.anaquel VALUES (3, 301, 12);
INSERT INTO public.anaquel VALUES (4, 401, 12);
INSERT INTO public.anaquel VALUES (5, 501, 13);
INSERT INTO public.anaquel VALUES (6, 601, 13);
INSERT INTO public.anaquel VALUES (7, 701, 14);
INSERT INTO public.anaquel VALUES (8, 801, 14);
INSERT INTO public.anaquel VALUES (9, 901, 15);
INSERT INTO public.anaquel VALUES (10, 1001, 16);
INSERT INTO public.anaquel VALUES (11, 1101, 16);
INSERT INTO public.anaquel VALUES (12, 101, 17);
INSERT INTO public.anaquel VALUES (13, 201, 17);
INSERT INTO public.anaquel VALUES (14, 301, 18);
INSERT INTO public.anaquel VALUES (15, 401, 18);
INSERT INTO public.anaquel VALUES (16, 501, 19);
INSERT INTO public.anaquel VALUES (17, 601, 19);
INSERT INTO public.anaquel VALUES (18, 701, 20);
INSERT INTO public.anaquel VALUES (19, 801, 20);
INSERT INTO public.anaquel VALUES (20, 901, 21);
INSERT INTO public.anaquel VALUES (21, 1001, 22);
INSERT INTO public.anaquel VALUES (22, 1101, 22);


--
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.empleado VALUES (1, 'V18456789', 'Carlos', 'Eduardo', 'Ramirez', 'Silva', 'Av. Principal 123, Caracas', '1985-03-15', 'M', 360);
INSERT INTO public.empleado VALUES (2, 'V19567890', 'Maria', 'Isabel', 'Gonzalez', 'Martinez', 'Calle Real 456, Valencia', '1990-07-22', 'F', 115);
INSERT INTO public.empleado VALUES (3, 'V20678901', 'Jose', 'Antonio', 'Rodriguez', 'Lopez', 'Av. Bella Vista 789, Maracaibo', '1988-11-10', 'M', 352);
INSERT INTO public.empleado VALUES (4, 'V21789012', 'Ana', 'Lucia', 'Fernandez', 'Garcia', 'Urbanización Norte 321, Caracas', '1992-05-18', 'F', 360);
INSERT INTO public.empleado VALUES (5, 'V22890123', 'Luis', 'Miguel', 'Torres', 'Moreno', 'Av. Venezuela 654, Barquisimeto', '1987-09-03', 'M', 171);
INSERT INTO public.empleado VALUES (6, 'V23901234', 'Carmen', 'Rosa', 'Herrera', 'Castillo', 'Paseo Colon 987, Puerto La Cruz', '1991-12-08', 'F', 43);
INSERT INTO public.empleado VALUES (7, 'V24012345', 'Ricardo', 'Enrique', 'Mendoza', 'Vargas', 'Av. Los Proceres 147, Merida', '1989-04-25', 'M', 189);
INSERT INTO public.empleado VALUES (8, 'V25123456', 'Patricia', 'Alejandra', 'Suarez', 'Romero', 'Torre Empresarial 258, Caracas', '1993-08-14', 'F', 360);
INSERT INTO public.empleado VALUES (9, 'V26234567', 'Fernando', 'Jose', 'Delgado', 'Jimenez', 'Centro Comercial 369, Caracas', '1986-01-30', 'M', 360);
INSERT INTO public.empleado VALUES (10, 'V27345678', 'Gabriela', 'Antonieta', 'Vega', 'Paredes', 'Zona Industrial 741, Ciudad Bolivar', '1994-06-12', 'F', 95);


--
-- Data for Name: asistencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.asistencia VALUES (521, '2024-01-15 08:00:00-04', '2024-01-15 17:00:00-04', 1);
INSERT INTO public.asistencia VALUES (522, '2024-01-16 08:00:00-04', '2024-01-16 17:00:00-04', 2);
INSERT INTO public.asistencia VALUES (523, '2024-01-17 08:00:00-04', '2024-01-17 17:00:00-04', 3);
INSERT INTO public.asistencia VALUES (524, '2024-01-18 08:00:00-04', '2024-01-18 17:00:00-04', 4);
INSERT INTO public.asistencia VALUES (525, '2024-01-19 08:00:00-04', '2024-01-19 17:00:00-04', 5);
INSERT INTO public.asistencia VALUES (526, '2024-01-20 09:00:00-04', '2024-01-20 18:00:00-04', 6);
INSERT INTO public.asistencia VALUES (527, '2024-01-21 10:00:00-04', '2024-01-21 16:00:00-04', 7);
INSERT INTO public.asistencia VALUES (528, '2024-01-22 14:00:00-04', '2024-01-22 22:00:00-04', 8);
INSERT INTO public.asistencia VALUES (529, '2024-01-23 08:00:00-04', '2024-01-23 14:00:00-04', 9);
INSERT INTO public.asistencia VALUES (530, '2024-01-24 12:00:00-04', '2024-01-24 20:00:00-04', 10);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cliente VALUES (1, 'J123456789', 'Av. Libertador 123, Caracas', 'NATURAL', 'V12345678', 'Carlos', 'Alberto', 'Rodriguez', 'Perez', 'M', NULL, NULL, NULL, NULL, NULL, 150, 360);
INSERT INTO public.cliente VALUES (2, 'J123456790', 'Calle Real 456, Maracay', 'NATURAL', 'V23456789', 'Maria', 'Elena', 'Gonzalez', 'Martinez', 'F', NULL, NULL, NULL, NULL, NULL, 200, 61);
INSERT INTO public.cliente VALUES (3, 'J123456791', 'Av. Universidad 789, Valencia', 'NATURAL', 'V34567890', 'Jose', 'Luis', 'Fernandez', 'Lopez', 'M', NULL, NULL, NULL, NULL, NULL, 75, 115);
INSERT INTO public.cliente VALUES (4, 'J123456792', 'Calle Bolivar 321, Barquisimeto', 'NATURAL', 'V45678901', 'Ana', 'Maria', 'Sanchez', 'Garcia', 'F', NULL, NULL, NULL, NULL, NULL, 300, 171);
INSERT INTO public.cliente VALUES (5, 'J123456793', 'Av. 5 de Julio 654, Maracaibo', 'NATURAL', 'V56789012', 'Luis', 'Fernando', 'Ramirez', 'Morales', 'M', NULL, NULL, NULL, NULL, NULL, 120, 352);
INSERT INTO public.cliente VALUES (6, 'J123456794', 'Calle Miranda 987, Puerto La Cruz', 'NATURAL', 'V67890123', 'Carmen', 'Rosa', 'Herrera', 'Vargas', 'F', NULL, NULL, NULL, NULL, NULL, 180, 43);
INSERT INTO public.cliente VALUES (7, 'J123456795', 'Av. Las Americas 147, San Cristobal', 'NATURAL', 'V78901234', 'Pedro', 'Antonio', 'Castillo', 'Romero', 'M', NULL, NULL, NULL, NULL, NULL, 90, 297);
INSERT INTO public.cliente VALUES (8, 'J123456796', 'Calle Sucre 258, Cumana', 'NATURAL', 'V89012345', 'Rosa', 'Isabel', 'Mendoza', 'Silva', 'F', NULL, NULL, NULL, NULL, NULL, 250, 273);
INSERT INTO public.cliente VALUES (9, 'J123456797', 'Av. Intercomunal 369, Barinas', 'NATURAL', 'V90123456', 'Miguel', 'Angel', 'Torres', 'Jimenez', 'M', NULL, NULL, NULL, NULL, NULL, 160, 83);
INSERT INTO public.cliente VALUES (10, 'J123456798', 'Calle Paez 741, Merida', 'NATURAL', 'V01234567', 'Luisa', 'Fernanda', 'Moreno', 'Ruiz', 'F', NULL, NULL, NULL, NULL, NULL, 210, 189);
INSERT INTO public.cliente VALUES (11, 'J123456799', 'Av. Principal 852, Ciudad Bolivar', 'NATURAL', 'V12345679', 'Roberto', 'Carlos', 'Gutierrez', 'Diaz', 'M', NULL, NULL, NULL, NULL, NULL, 110, 95);
INSERT INTO public.cliente VALUES (12, 'J123456800', 'Calle Comercio 963, Punto Fijo', 'NATURAL', 'V23456780', 'Elena', 'Victoria', 'Navarro', 'Cruz', 'F', NULL, NULL, NULL, NULL, NULL, 175, 133);
INSERT INTO public.cliente VALUES (13, 'J123456801', 'Av. Fuerzas Armadas 159, Los Teques', 'NATURAL', 'V34567891', 'Jorge', 'Eduardo', 'Ramos', 'Ortega', 'M', NULL, NULL, NULL, NULL, NULL, 135, 210);
INSERT INTO public.cliente VALUES (14, 'J123456802', 'Calle Ayacucho 357, Guarenas', 'NATURAL', 'V45678902', 'Patricia', 'Alejandra', 'Vega', 'Molina', 'F', NULL, NULL, NULL, NULL, NULL, 195, 217);
INSERT INTO public.cliente VALUES (15, 'J123456803', 'Av. Romulo Gallegos 468, Maturin', 'NATURAL', 'V56789013', 'Fernando', 'Jose', 'Delgado', 'Paredes', 'M', NULL, NULL, NULL, NULL, NULL, 85, 229);
INSERT INTO public.cliente VALUES (16, 'J123456804', 'Calle Urdaneta 579, Porlamar', 'NATURAL', 'V67890124', 'Gabriela', 'Antonieta', 'Campos', 'Rivero', 'F', NULL, NULL, NULL, NULL, NULL, 220, 241);
INSERT INTO public.cliente VALUES (17, 'J123456805', 'Av. Rotaria 680, Acarigua', 'NATURAL', 'V78901235', 'Andres', 'Manuel', 'Suarez', 'Acosta', 'M', NULL, NULL, NULL, NULL, NULL, 140, 247);
INSERT INTO public.cliente VALUES (18, 'J123456806', 'Calle Carabobo 791, Carora', 'NATURAL', 'V89012346', 'Beatriz', 'Esperanza', 'Flores', 'Vera', 'F', NULL, NULL, NULL, NULL, NULL, 265, 176);
INSERT INTO public.cliente VALUES (19, 'J123456807', 'Av. Los Proceres 802, Valera', 'NATURAL', 'V90123457', 'Ricardo', 'Enrique', 'Medina', 'Aguilar', 'M', NULL, NULL, NULL, NULL, NULL, 100, 323);
INSERT INTO public.cliente VALUES (20, 'J123456808', 'Calle Democracia 913, Catia La Mar', 'NATURAL', 'V01234568', 'Maritza', 'del Carmen', 'Ponce', 'Guerrero', 'F', NULL, NULL, NULL, NULL, NULL, 230, 324);
INSERT INTO public.cliente VALUES (21, 'J234567890', 'Torre Empresarial, Piso 15, Caracas', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Distribuidora Andina', 'Distribuidora Andina C.A.', 'https://www.distribuidoraandina.com', 5000000, 'Av. Francisco de Miranda, Caracas', 500, 360);
INSERT INTO public.cliente VALUES (22, 'J234567891', 'Centro Comercial El Recreo, Local 25, Caracas', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Cerveceria Nacional', 'Cerveceria Nacional S.A.', 'https://www.cerveceranacional.com', 8000000, 'Zona Industrial Los Ruices, Caracas', 1200, 360);
INSERT INTO public.cliente VALUES (23, 'J234567892', 'Complejo Industrial Zona Norte, Valencia', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Malteria Central', 'Malteria Central C.A.', 'https://www.malteriacentral.com', 3500000, 'Av. Universidad Norte, Valencia', 850, 115);
INSERT INTO public.cliente VALUES (24, 'J234567893', 'Edificio Comercial Plaza Mayor, Maracaibo', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Grupo Cervecero Zulia', 'Grupo Cervecero Zulia S.A.', 'https://www.grupocervecerozulia.com', 6200000, 'Av. Bella Vista, Maracaibo', 950, 352);
INSERT INTO public.cliente VALUES (25, 'J234567894', 'Parque Industrial La Victoria, Aragua', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Bebidas Premium', 'Bebidas Premium C.A.', 'https://www.bebidaspremium.com', 4100000, 'Zona Industrial La Victoria, Aragua', 750, 61);
INSERT INTO public.cliente VALUES (26, 'J234567895', 'Centro de Distribución Regional, Barquisimeto', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Comercial Lara', 'Comercial Lara S.R.L.', 'https://www.comerciallara.com', 2800000, 'Av. Venezuela, Barquisimeto', 620, 171);
INSERT INTO public.cliente VALUES (27, 'J234567896', 'Plaza Comercial Oriente, Puerto La Cruz', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Distribuciones Oriente', 'Distribuciones Oriente C.A.', 'https://www.distribucionesoriente.com', 3200000, 'Complejo Jose, Puerto La Cruz', 710, 43);
INSERT INTO public.cliente VALUES (28, 'J234567897', 'Zona Industrial San Tome, Anzoategui', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Petroleo y Bebidas', 'Petroleo y Bebidas S.A.', 'https://www.petroleoybebidas.com', 7500000, 'Av. Principal San Tome, Anzoategui', 1100, 33);
INSERT INTO public.cliente VALUES (29, 'J234567898', 'Centro Empresarial Los Llanos, Barinas', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Agroindustrial Barinas', 'Agroindustrial Barinas C.A.', 'https://www.agroindustrialbarinas.com', 1900000, 'Sector Industrial, Barinas', 480, 83);
INSERT INTO public.cliente VALUES (30, 'J234567899', 'Complejo Comercial Andino, Merida', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Montana Brewery', 'Montana Brewery C.A.', 'https://www.montanabrewery.com', 2500000, 'Zona Industrial Ejido, Merida', 680, 189);
INSERT INTO public.cliente VALUES (31, 'J234567900', 'Parque Tecnologico Guayana, Ciudad Bolivar', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Minera Cervecera', 'Minera Cervecera S.A.', 'https://www.mineracervecera.com', 9200000, 'Sector Puerto Ordaz, Ciudad Bolivar', 1350, 95);
INSERT INTO public.cliente VALUES (32, 'J234567901', 'Centro Logistico Falcon, Punto Fijo', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Costa Dorada Beverages', 'Costa Dorada Beverages C.A.', 'https://www.costadorada.com', 1800000, 'Refineria El Palito, Punto Fijo', 420, 133);
INSERT INTO public.cliente VALUES (33, 'J234567902', 'Plaza Miranda Business Center, Los Teques', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Valles del Tuy Distribuidora', 'Valles del Tuy Distribuidora C.A.', 'https://www.vallesdeltuy.com', 1400000, 'Av. Intercomunal, Los Teques', 380, 210);
INSERT INTO public.cliente VALUES (34, 'J234567903', 'Centro Industrial Guarenas, Miranda', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Nueva Era Bebidas', 'Nueva Era Bebidas S.A.', 'https://www.nuevaerabebidas.com', 3800000, 'Zona Industrial Guarenas, Miranda', 820, 217);
INSERT INTO public.cliente VALUES (35, 'J234567904', 'Complejo Petrochemico Monagas, Maturin', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Oriente Brewery Group', 'Oriente Brewery Group C.A.', 'https://www.orientebrewery.com', 6800000, 'Jose Industrial Complex, Maturin', 1050, 229);
INSERT INTO public.cliente VALUES (36, 'J234567905', 'Marina Plaza Commercial, Porlamar', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Isla Margarita Beverages', 'Isla Margarita Beverages C.A.', 'https://www.islamargarita.com', 2200000, 'Sector Pampatar, Porlamar', 580, 241);
INSERT INTO public.cliente VALUES (37, 'J234567906', 'Parque Agroindustrial Portuguesa, Acarigua', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Llanos Brewery', 'Llanos Brewery C.A.', 'https://www.llanosbrewery.com', 1600000, 'Zona Agricola Norte, Acarigua', 440, 247);
INSERT INTO public.cliente VALUES (38, 'J234567907', 'Centro Comercial Carora Mall, Carora', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Tradicion Cervecera Lara', 'Tradicion Cervecera Lara S.A.', 'https://www.tradicioncervecera.com', 2100000, 'Av. Lara, Carora', 550, 176);
INSERT INTO public.cliente VALUES (39, 'J234567908', 'Zona Industrial Trujillo, Valera', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Andes Mountain Brewery', 'Andes Mountain Brewery C.A.', 'https://www.andesmountain.com', 2700000, 'Sector Industrial Valera, Trujillo', 650, 323);
INSERT INTO public.cliente VALUES (40, 'J234567909', 'Puerto Internacional La Guaira, Vargas', 'JURIDICO', NULL, NULL, NULL, NULL, NULL, NULL, 'Puerto Cervecero Internacional', 'Puerto Cervecero Internacional S.A.', 'https://www.puertocervecero.com', 4500000, 'Zona Portuaria La Guaira, Vargas', 890, 324);


--
-- Data for Name: tipo_evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_evento VALUES (1, 'Festival', 'Evento a gran escala con multiples cervecerias y musica en vivo.', NULL);
INSERT INTO public.tipo_evento VALUES (2, 'Cata', 'Sesion de degustacion para evaluar y disfrutar diferentes tipos de cerveza.', NULL);
INSERT INTO public.tipo_evento VALUES (3, 'Taller de Elaboracion', 'Curso practico sobre el proceso de fabricacion de cerveza artesanal.', NULL);
INSERT INTO public.tipo_evento VALUES (4, 'Competencia', 'Certamen para premiar a las mejores cervezas en diversas categorias.', NULL);
INSERT INTO public.tipo_evento VALUES (5, 'Lanzamiento', 'Evento para presentar una nueva cerveza o linea de productos al mercado.', NULL);
INSERT INTO public.tipo_evento VALUES (6, 'Evento de Maridaje', 'Experiencia gastronomica que combina cervezas con alimentos especificos.', NULL);
INSERT INTO public.tipo_evento VALUES (7, 'Feria', 'Evento que reúne a productores locales y artesanales para exhibir sus productos.', NULL);
INSERT INTO public.tipo_evento VALUES (8, 'Exposición', 'Evento donde se exhiben productos cerveceros, maquinaria y tecnología relacionada.', NULL);
INSERT INTO public.tipo_evento VALUES (9, 'Feria de Cerveceros Locales', 'Festival enfocado en productores de la region.', 1);
INSERT INTO public.tipo_evento VALUES (10, 'Cata Guiada', 'Degustacion dirigida por un sommelier de cervezas o beer server.', 2);
INSERT INTO public.tipo_evento VALUES (11, 'Taller de Iniciacion', 'Curso basico para aprender a hacer cerveza en casa.', 3);
INSERT INTO public.tipo_evento VALUES (12, 'Taller de Estilos Avanzados', 'Curso enfocado en la elaboracion de estilos complejos como Sours o Barleywines.', 3);
INSERT INTO public.tipo_evento VALUES (13, 'Competencia Homebrew', 'Concurso para cerveceros caseros no profesionales.', 4);
INSERT INTO public.tipo_evento VALUES (14, 'Lanzamiento de Cerveza de Temporada', 'Presentacion de una cerveza estacional como una Pumpkin Ale.', 5);


--
-- Data for Name: evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.evento VALUES (1, 'Cata Selvatica', 'Degustacion de cervezas con frutas exoticas del amazonas.', '2025-07-20 19:00:00-04', 50, 1, 2);
INSERT INTO public.evento VALUES (2, 'Taller de Cerveza Ancestral', 'Aprende tecnicas de fermentacion con ingredientes locales.', '2025-08-15 09:00:00-04', 40, 1, 3);
INSERT INTO public.evento VALUES (3, 'Noche de Maridaje Amazonico', 'Cervezas artesanales combinadas con gastronomia local.', '2025-09-10 20:00:00-04', 60, 1, 6);
INSERT INTO public.evento VALUES (4, 'Lanzamiento de la Orinoco IPA', 'Presentacion de nuestra nueva Indian Pale Ale.', '2025-10-01 18:30:00-04', 100, 1, 5);
INSERT INTO public.evento VALUES (5, 'Competencia de Cerveza Casera del Sur', 'Concurso para homebrewers de la region.', '2025-11-22 14:00:00-04', 150, 1, 4);
INSERT INTO public.evento VALUES (6, 'Festival de la Cerveza Playera', 'Musica, playa y las mejores cervezas del oriente.', '2025-08-01 12:00:00-04', 500, 2, 1);
INSERT INTO public.evento VALUES (7, 'Cata Guiada de Lagers', 'Un viaje por las cervezas mas refrescantes.', '2025-08-25 19:30:00-04', 80, 2, 9);
INSERT INTO public.evento VALUES (8, 'Taller de Iniciacion Cervecera PLC', 'Tu primer lote de cerveza hecho por ti mismo.', '2025-09-20 10:00:00-04', 30, 2, 11);
INSERT INTO public.evento VALUES (9, 'Oktoberfest Lecheria', 'La tradicion alemana en el morro.', '2025-10-18 17:00:00-04', 400, 2, 8);
INSERT INTO public.evento VALUES (10, 'Maridaje Marino', 'Cervezas y los mejores platos del mar.', '2025-11-15 20:00:00-04', 70, 2, 12);
INSERT INTO public.evento VALUES (11, 'Festival del Llano Cervecero', 'Joropo, carne en vara y cerveza artesanal.', '2025-12-05 15:00:00-04', 300, 3, 1);
INSERT INTO public.evento VALUES (12, 'Cata de Cervezas de Maiz', 'Explorando cervezas hechas con cereales alternativos.', '2024-01-20 19:00:00-04', 50, 3, 2);
INSERT INTO public.evento VALUES (13, 'Competencia Homebrew Llanera', 'Buscando al mejor cervecero casero de Apure.', '2024-02-15 13:00:00-04', 100, 3, 13);
INSERT INTO public.evento VALUES (14, 'Taller Basico en San Fernando', 'Aprende lo esencial de la elaboracion casera.', '2024-03-10 09:30:00-04', 45, 3, 11);
INSERT INTO public.evento VALUES (15, 'Lanzamiento de la Apurena Stout', 'Una cerveza oscura con notas de cafe y cacao.', '2024-04-01 19:00:00-04', 90, 3, 5);
INSERT INTO public.evento VALUES (16, 'Oktoberfest Colonia Tovar', 'La fiesta de la cerveza mas famosa de Venezuela.', '2025-10-24 12:00:00-04', 1500, 4, 8);
INSERT INTO public.evento VALUES (17, 'Feria de Cerveceros de Aragua', 'Los mejores productores del centro del pais reunidos.', '2025-11-28 17:00:00-04', 600, 4, 7);
INSERT INTO public.evento VALUES (18, 'Taller de Estilos Avanzados', 'Perfecciona tu tecnica con estilos complejos.', '2024-01-15 09:00:00-04', 25, 4, 12);
INSERT INTO public.evento VALUES (19, 'Cata a Ciegas Maracay', 'Pon a prueba tu paladar sin ver las etiquetas.', '2024-02-20 20:00:00-04', 60, 4, 10);
INSERT INTO public.evento VALUES (20, 'Maridaje con Chocolates de Chuao', 'Una experiencia sensorial unica con cervezas y cacao.', '2024-03-18 19:30:00-04', 50, 4, 6);
INSERT INTO public.evento VALUES (21, 'Festival de la Cerveza Ganadera', 'El sabor del llano con la mejor cerveza.', '2025-10-10 16:00:00-04', 400, 5, 1);
INSERT INTO public.evento VALUES (22, 'Taller de Iniciacion Barinas', 'El primer paso para ser un maestro cervecero.', '2025-11-08 10:00:00-04', 35, 5, 11);
INSERT INTO public.evento VALUES (23, 'Cata de Stouts y Porters', 'Explorando el lado oscuro de la cerveza.', '2025-12-12 19:00:00-04', 70, 5, 2);
INSERT INTO public.evento VALUES (24, 'Lanzamiento de la Barinas Pale Ale', 'Una cerveza refrescante y con caracter.', '2024-01-30 18:00:00-04', 120, 5, 5);
INSERT INTO public.evento VALUES (25, 'Competencia de Cerveza Casera', 'Demuestra tu talento en nuestra competencia anual.', '2024-02-28 14:00:00-04', 90, 5, 13);
INSERT INTO public.evento VALUES (26, 'Festival Dorado de Cerveza', 'El oro liquido de Guayana en un solo lugar.', '2024-03-20 18:00:00-04', 700, 6, 1);
INSERT INTO public.evento VALUES (27, 'Cata a Orillas del Orinoco', 'Degustacion con vistas al rio mas grande de Venezuela.', '2024-04-17 17:00:00-04', 100, 6, 9);
INSERT INTO public.evento VALUES (28, 'Lanzamiento de la Tepuy Stout', 'Una cerveza robusta inspirada en nuestras formaciones rocosas.', '2025-05-15 19:30:00-04', 150, 6, 14);
INSERT INTO public.evento VALUES (29, 'Taller de Elaboracion Guayanes', 'Aprende los secretos de la cerveza de la region.', '2025-06-12 09:00:00-04', 40, 6, 11);
INSERT INTO public.evento VALUES (30, 'Maridaje con Queso Guayanes', 'La combinacion perfecta de la tradicion y la innovacion.', '2025-07-10 20:00:00-04', 80, 6, 12);
INSERT INTO public.evento VALUES (31, 'Valencia Beer Fest', 'El festival mas grande del centro del pais.', '2025-11-07 16:00:00-04', 1200, 7, 7);
INSERT INTO public.evento VALUES (32, 'Copa Cervecera Industrial', 'La competencia que reune a los mejores cerveceros.', '2025-02-06 11:00:00-04', 300, 7, 4);
INSERT INTO public.evento VALUES (33, 'Taller de Lupulos en Naguanagua', 'Un curso intensivo sobre el alma de la IPA.', '2025-03-06 10:00:00-04', 30, 7, 12);
INSERT INTO public.evento VALUES (34, 'Cata de Cervezas Belgas', 'Descubre la complejidad de los estilos de Belgica.', '2025-04-03 19:00:00-04', 90, 7, 9);
INSERT INTO public.evento VALUES (35, 'Lanzamiento de la Valencia Lager', 'Presentacion de una nueva lager para la ciudad.', '2025-05-01 18:00:00-04', 250, 7, 14);
INSERT INTO public.evento VALUES (36, 'Festival Cervecero de Cojedes', 'Apoyando a los productores locales.', '2025-09-12 17:00:00-04', 200, 8, 1);
INSERT INTO public.evento VALUES (37, 'Taller Basico en San Carlos', 'Iniciate en el mundo de la cerveza casera.', '2025-10-10 09:30:00-04', 50, 8, 11);
INSERT INTO public.evento VALUES (38, 'Cata de Cervezas Nacionales', 'Un recorrido por los sabores de Venezuela.', '2025-11-14 19:00:00-04', 60, 8, 2);
INSERT INTO public.evento VALUES (39, 'Competencia Homebrew Cojedes', 'El concurso para cerveceros caseros de la region.', '2025-12-12 14:00:00-04', 80, 8, 13);
INSERT INTO public.evento VALUES (40, 'Maridaje Criollo', 'Cervezas artesanales con platos tipicos de la region.', '2025-01-09 20:00:00-04', 50, 8, 6);
INSERT INTO public.evento VALUES (41, 'Cata Flotante en el Delta', 'Una experiencia unica en los canos del Orinoco.', '2025-05-22 16:00:00-04', 40, 9, 9);
INSERT INTO public.evento VALUES (42, 'Taller con Frutos del Delta', 'Elaboracion de cerveza usando ingredientes exoticos.', '2025-06-19 10:00:00-04', 25, 9, 3);
INSERT INTO public.evento VALUES (43, 'Lanzamiento de la Warao Ale', 'Una cerveza inspirada en la cultura indigena local.', '2025-07-17 18:00:00-04', 70, 9, 5);
INSERT INTO public.evento VALUES (44, 'Festival del Pescador Cervecero', 'Combinando la pesca del dia con cerveza fresca.', '2025-08-14 15:00:00-04', 150, 9, 1);
INSERT INTO public.evento VALUES (45, 'Noche de Maridaje de Rio', 'Pescado de rio y cervezas artesanales.', '2025-09-11 19:30:00-04', 50, 9, 13);
INSERT INTO public.evento VALUES (46, 'Festival de la Cerveza Medanal', 'Cerveza y viento en los Medanos de Coro.', '2025-12-26 13:00:00-04', 500, 10, 1);
INSERT INTO public.evento VALUES (47, 'Cata de Gose y Sours', 'Explorando cervezas acidas y salinas, perfectas para el calor.', '2025-01-23 19:00:00-04', 70, 10, 2);
INSERT INTO public.evento VALUES (48, 'Taller de Elaboracion en Paraguaná', 'Aprende a hacer cerveza en la peninsula.', '2025-02-20 09:00:00-04', 40, 10, 3);
INSERT INTO public.evento VALUES (49, 'Lanzamiento de la Cardon IPA', 'Una IPA con un toque desertico.', '2025-03-20 19:00:00-04', 120, 10, 14);
INSERT INTO public.evento VALUES (50, 'Maridaje con Chivo Al Coco', 'La tradicion falconiana se une a la cerveza artesanal.', '2025-04-17 20:30:00-04', 60, 10, 6);
INSERT INTO public.evento VALUES (51, 'Festival del Estero Cervecero', 'El llano se viste de fiesta y cerveza.', '2023-03-13 13:00:00-04', 250, 11, 7);
INSERT INTO public.evento VALUES (52, 'Taller de Cerveza en Calabozo', 'Conceptos basicos y avanzados de elaboracion.', '2023-04-10 09:00:00-04', 35, 11, 3);
INSERT INTO public.evento VALUES (53, 'Cata de Cervezas Rojas', 'Un recorrido por los estilos Amber, Red Ale y mas.', '2023-05-08 19:30:00-04', 50, 11, 2);
INSERT INTO public.evento VALUES (54, 'Lanzamiento de la Guariquena Pilsner', 'Una cerveza ligera y refrescante para el calor.', '2023-06-05 18:30:00-04', 100, 11, 5);
INSERT INTO public.evento VALUES (55, 'Competencia de Cerveceros del Llano', 'El evento que premia la creatividad llanera.', '2024-07-03 13:00:00-04', 90, 11, 4);
INSERT INTO public.evento VALUES (56, 'Barquisimeto Beer Festival', 'La capital musical se llena de la mejor cerveza.', '2025-09-12 17:00:00-04', 900, 12, 1);
INSERT INTO public.evento VALUES (57, 'Taller de Elaboracion con Cocuy', 'Innovando con el destilado local en la cerveza.', '2025-10-17 10:00:00-04', 30, 12, 12);
INSERT INTO public.evento VALUES (58, 'Cata a Ciegas Crepuscular', 'Degusta y adivina bajo los atardeceres de Barquisimeto.', '2025-11-21 18:30:00-04', 80, 12, 10);
INSERT INTO public.evento VALUES (59, 'Lanzamiento de la Divina Pastora Ale', 'Una cerveza de edicion especial para la feria.', '2024-01-13 19:00:00-04', 200, 12, 14);
INSERT INTO public.evento VALUES (60, 'Maridaje con Lomo Prensado', 'Sabores de Lara en armonia con cervezas unicas.', '2024-02-13 20:00:00-04', 70, 12, 13);
INSERT INTO public.evento VALUES (61, 'Festival de Cerveza del Paramo', 'Cervezas de altura en el corazon de los Andes.', '2024-01-02 14:00:00-04', 450, 13, 1);
INSERT INTO public.evento VALUES (62, 'Cata de Cervezas de Trigo', 'Estilos Hefeweizen, Witbier y mas en el clima frio.', '2024-01-30 19:00:00-04', 60, 13, 2);
INSERT INTO public.evento VALUES (63, 'Taller de Elaboracion en Frio', 'Aprende las tecnicas de fermentacion a bajas temperaturas.', '2022-02-27 09:30:00-04', 25, 13, 3);
INSERT INTO public.evento VALUES (64, 'Maridaje con Trucha Ahumada', 'La delicadeza de la trucha con cervezas seleccionadas.', '2022-03-27 20:00:00-04', 50, 13, 13);
INSERT INTO public.evento VALUES (65, 'Competencia Homebrew de los Andes', 'El concurso mas alto de Venezuela.', '2022-04-24 12:00:00-04', 120, 13, 13);
INSERT INTO public.evento VALUES (66, 'Gran Feria Cervecera de Caracas', 'El evento que reune a toda la capital y sus alrededores.', '2025-11-14 15:00:00-04', 2000, 14, 7);
INSERT INTO public.evento VALUES (67, 'Taller de Estilos IPA en Los Teques', 'Un dia completo dedicado al lupulo.', '2025-12-05 09:00:00-04', 40, 14, 12);
INSERT INTO public.evento VALUES (68, 'Lanzamiento de Cerveza de Temporada', 'Presentacion de la cerveza de navidad.', '2025-12-19 19:00:00-04', 300, 14, 14);
INSERT INTO public.evento VALUES (69, 'Cata Guiada en El Hatillo', 'Un paseo por los sabores de la cerveza en un ambiente colonial.', '2022-01-23 19:30:00-04', 80, 14, 9);
INSERT INTO public.evento VALUES (70, 'Maridaje con Quesos y Fiambres', 'Una noche de sabores intensos.', '2022-02-20 20:30:00-04', 100, 14, 10);
INSERT INTO public.evento VALUES (71, 'Festival Cervecero de Oriente', 'Maturin se convierte en la capital de la cerveza.', '2022-06-12 17:00:00-04', 600, 15, 1);
INSERT INTO public.evento VALUES (72, 'Cata de Cervezas Ahumadas', 'Explorando el caracter del Rauchbier y otras.', '2022-07-10 19:00:00-04', 50, 15, 2);
INSERT INTO public.evento VALUES (73, 'Taller de Iniciacion en Maturin', 'Empieza tu camino como cervecero casero.', '2022-08-07 10:00:00-04', 40, 15, 11);
INSERT INTO public.evento VALUES (74, 'Lanzamiento de la Petrolera Porter', 'Una porter robusta y oscura como el oro negro.', '2022-09-04 18:30:00-04', 150, 15, 5);
INSERT INTO public.evento VALUES (75, 'Competencia de Cervezas de Monagas', 'Buscando la mejor cerveza del estado.', '2022-10-02 14:00:00-04', 100, 15, 4);
INSERT INTO public.evento VALUES (76, 'Margarita Craft Beer Fest', 'La perla del caribe se llena de cerveza artesanal.', '2025-12-12 16:00:00-04', 800, 16, 7);
INSERT INTO public.evento VALUES (77, 'Cata de Cervezas Tropicales', 'Degustacion de cervezas con sabores a mango, parchita y mas.', '2024-01-16 18:00:00-04', 100, 16, 2);
INSERT INTO public.evento VALUES (78, 'Maridaje con Pescados y Mariscos', 'La mejor combinacion en la isla.', '2024-02-13 20:00:00-04', 90, 16, 14);
INSERT INTO public.evento VALUES (79, 'Lanzamiento de la Pampatar Pils', 'Una pilsner refrescante para disfrutar en la playa.', '2024-03-13 17:00:00-04', 200, 16, 5);
INSERT INTO public.evento VALUES (80, 'Taller de Cerveza para el Calor', 'Aprende a hacer estilos ligeros y refrescantes.', '2024-04-10 10:00:00-04', 30, 16, 3);
INSERT INTO public.evento VALUES (81, 'Festival de la Cosecha Cervecera', 'Celebrando los granos de Portuguesa con cerveza.', '2024-02-06 16:00:00-04', 350, 17, 1);
INSERT INTO public.evento VALUES (82, 'Taller Basico en Acarigua', 'El ABC de la elaboracion de cerveza.', '2024-03-06 09:00:00-04', 45, 17, 11);
INSERT INTO public.evento VALUES (83, 'Cata de Cervezas de Arroz', 'Explorando un adjunto clasico en las lagers.', '2024-04-03 19:00:00-04', 60, 17, 2);
INSERT INTO public.evento VALUES (84, 'Competencia del Granero de Venezuela', 'El concurso cervecero de Portuguesa.', '2024-05-01 13:00:00-04', 100, 17, 13);
INSERT INTO public.evento VALUES (85, 'Lanzamiento de la Coromotana Ale', 'Una cerveza en honor a la patrona de Venezuela.', '2025-05-29 18:00:00-04', 120, 17, 5);
INSERT INTO public.evento VALUES (86, 'Festival Cumaná 500 y Cerveza', 'Celebrando la historia con la mejor cerveza de oriente.', '2025-11-27 17:00:00-04', 550, 18, 7);
INSERT INTO public.evento VALUES (87, 'Cata de Cervezas en Mochima', 'Una degustacion en un paraiso natural.', '2025-01-23 16:00:00-04', 70, 18, 9);
INSERT INTO public.evento VALUES (88, 'Maridaje con Chorizo de Carupano', 'Un clasico local con un giro artesanal.', '2025-02-20 19:30:00-04', 60, 18, 6);
INSERT INTO public.evento VALUES (89, 'Taller de Elaboracion en Cumana', 'Aprende de los pioneros de la cerveza en Sucre.', '2025-03-20 09:00:00-04', 35, 18, 3);
INSERT INTO public.evento VALUES (90, 'Lanzamiento de la Mariscala Session IPA', 'Una IPA suave para disfrutar todo el dia.', '2025-04-17 18:00:00-04', 130, 18, 14);
INSERT INTO public.evento VALUES (91, 'Feria Cervecera de San Cristobal', 'El gran evento cervecero de los Andes.', '2025-01-16 16:00:00-04', 750, 19, 7);
INSERT INTO public.evento VALUES (92, 'Cata de Cervezas de Cafe', 'Combinando las dos grandes pasiones del Tachira.', '2025-02-13 19:00:00-04', 80, 19, 2);
INSERT INTO public.evento VALUES (93, 'Competencia de la Frontera', 'El concurso que une a cerveceros de ambos paises.', '2025-03-13 11:00:00-04', 200, 19, 4);
INSERT INTO public.evento VALUES (94, 'Taller de Estilos Europeos', 'Aprende a elaborar lagers alemanas y ales inglesas.', '2025-04-10 09:30:00-04', 30, 19, 12);
INSERT INTO public.evento VALUES (95, 'Lanzamiento de la Gocha Pils', 'La pilsner con el sabor de la cordialidad.', '2025-05-08 19:00:00-04', 180, 19, 5);
INSERT INTO public.evento VALUES (96, 'Festival de Cerveza de las 7 Colinas', 'Valera se viste de gala cervecera.', '2025-06-05 17:00:00-04', 300, 20, 1);
INSERT INTO public.evento VALUES (97, 'Cata en Honor a la Virgen de la Paz', 'Una degustacion con vistas al monumento.', '2025-07-03 16:00:00-04', 60, 20, 9);
INSERT INTO public.evento VALUES (98, 'Taller de Elaboracion en Valera', 'Desde el grano hasta el vaso, aprende todo el proceso.', '2025-07-31 09:00:00-04', 40, 20, 11);
INSERT INTO public.evento VALUES (99, 'Maridaje con Mojo Trujillano', 'Sabores autoctonos y cerveza artesanal.', '2025-08-28 20:00:00-04', 50, 20, 6);
INSERT INTO public.evento VALUES (100, 'Lanzamiento de la Andes Ale', 'Una cerveza ambar con caracter andino.', '2025-09-25 18:30:00-04', 100, 20, 14);
INSERT INTO public.evento VALUES (101, 'Festival Cervecero del Litoral', 'La brisa del mar y la mejor cerveza.', '2025-10-24 17:00:00-04', 600, 21, 1);
INSERT INTO public.evento VALUES (102, 'Taller de Cerveza en la Playa', 'Aprende a hacer cerveza con los pies en la arena.', '2025-11-21 10:00:00-04', 35, 21, 3);
INSERT INTO public.evento VALUES (103, 'Cata de Session IPAs', 'Cervezas lupuladas y refrescantes para el calor.', '2025-12-19 18:30:00-04', 80, 21, 2);
INSERT INTO public.evento VALUES (104, 'Maridaje con Tostones y Pescado Frito', 'El sabor del litoral en tu copa.', '2025-01-16 19:30:00-04', 70, 21, 6);
INSERT INTO public.evento VALUES (105, 'Lanzamiento de la Guaira Summer Ale', 'La cerveza oficial del verano.', '2025-02-13 17:00:00-04', 150, 21, 5);
INSERT INTO public.evento VALUES (106, 'Festival de Cerveza y Esoterismo', 'Una fiesta magica en las montanas de Sorte.', '2025-03-13 18:00:00-04', 400, 22, 1);
INSERT INTO public.evento VALUES (107, 'Cata de Cervezas con Maiz', 'Explorando el sabor del maiz en la cerveza.', '2025-04-10 19:00:00-04', 50, 22, 2);
INSERT INTO public.evento VALUES (108, 'Taller de Elaboracion en San Felipe', 'Aprende de los maestros cerveceros de Yaracuy.', '2025-05-08 09:00:00-04', 40, 22, 11);
INSERT INTO public.evento VALUES (109, 'Lanzamiento de la Maria Lionza Ale', 'Una cerveza mistica y llena de sabor.', '2025-06-05 19:00:00-04', 120, 22, 14);
INSERT INTO public.evento VALUES (110, 'Maridaje con Sapasapo', 'La tradicion culinaria de Yaracuy y la cerveza.', '2025-07-03 20:00:00-04', 60, 22, 6);
INSERT INTO public.evento VALUES (111, 'Festival de la Chinita Cervecera', 'La feria y la cerveza se unen en Maracaibo.', '2025-11-14 18:00:00-04', 1500, 23, 7);
INSERT INTO public.evento VALUES (112, 'Cata en el Puente Sobre el Lago', 'Una degustacion con una vista iconica.', '2025-12-12 17:30:00-04', 100, 23, 9);
INSERT INTO public.evento VALUES (113, 'Lanzamiento de la Relampago IPA', 'Una explosion de lupulo como el relampago del Catatumbo.', '2025-01-09 19:00:00-04', 250, 23, 5);
INSERT INTO public.evento VALUES (114, 'Taller de Cervezas para el Calor', 'Estilos ligeros para el clima de Maracaibo.', '2025-02-06 09:00:00-04', 35, 23, 11);
INSERT INTO public.evento VALUES (115, 'Maridaje con Patacones', 'La combinacion zuliana por excelencia.', '2025-03-06 20:00:00-04', 90, 23, 10);
INSERT INTO public.evento VALUES (116, 'Caracas Beer Week', 'Una semana completa de eventos cerveceros por toda la ciudad.', '2024-04-20 12:00:00-04', 2500, 24, 1);
INSERT INTO public.evento VALUES (117, 'Cata Vertical de Barleywines', 'Una degustacion de diferentes anadas de Barleywine.', '2024-05-15 19:30:00-04', 40, 24, 2);
INSERT INTO public.evento VALUES (118, 'Taller de Fermentacion Avanzada', 'Control de levaduras y fermentaciones complejas.', '2024-06-12 09:00:00-04', 25, 24, 12);
INSERT INTO public.evento VALUES (119, 'Competencia Copa Cerveza de Caracas', 'El evento mas prestigioso para cerveceros del pais.', '2024-07-10 10:00:00-04', 300, 24, 4);
INSERT INTO public.evento VALUES (120, 'Lanzamiento de la Avila Ale', 'Una cerveza inspirada en la montana que custodia la ciudad.', '2024-08-07 18:30:00-04', 400, 24, 14);
INSERT INTO public.evento VALUES (121, 'Festival Cervecero Los Roques', 'Cerveza artesanal en el paraiso.', '2024-04-10 15:00:00-04', 250, 25, 1);
INSERT INTO public.evento VALUES (122, 'Cata de Cervezas Ligeras', 'Ideal para el calor del caribe.', '2024-05-15 18:00:00-04', 80, 25, 2);
INSERT INTO public.evento VALUES (123, 'Maridaje con Langosta', 'La combinacion perfecta de lujo y sabor.', '2024-06-20 20:00:00-04', 60, 25, 10);
INSERT INTO public.evento VALUES (124, 'Lanzamiento de la Caribe Ale', 'Una cerveza edicion especial para el verano.', '2024-07-01 19:00:00-04', 100, 25, 14);
INSERT INTO public.evento VALUES (125, 'Taller de Cerveza en el Archipielago', 'Aprende a hacer cerveza con vista al mar.', '2024-08-05 10:00:00-04', 30, 25, 3);


--
-- Data for Name: venta_boleto_evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.venta_boleto_evento VALUES (1, '2025-06-16 18:30:00-04', 25.00, 'Venta de 1 boleto para Cata Selvatica');
INSERT INTO public.venta_boleto_evento VALUES (2, '2025-06-25 10:15:00-04', 50.00, 'Venta de 2 boletos para Festival de la Cerveza Playera');
INSERT INTO public.venta_boleto_evento VALUES (3, '2025-07-01 11:00:00-04', 75.00, 'Venta de 3 boletos para Oktoberfest Colonia Tovar');
INSERT INTO public.venta_boleto_evento VALUES (4, '2025-07-15 14:20:00-04', 35.00, 'Venta de 1 boleto para Taller de Estilos Avanzados');
INSERT INTO public.venta_boleto_evento VALUES (5, '2025-07-20 09:05:00-04', 100.00, 'Venta de 4 boletos para Festival Dorado de Cerveza');
INSERT INTO public.venta_boleto_evento VALUES (6, '2025-08-02 19:45:00-04', 60.00, 'Venta de 2 boletos para Valencia Beer Fest');
INSERT INTO public.venta_boleto_evento VALUES (7, '2025-08-10 12:00:00-04', 20.00, 'Venta de 1 boleto para Festival Cervecero de Cojedes');
INSERT INTO public.venta_boleto_evento VALUES (8, '2025-08-18 21:00:00-04', 30.00, 'Venta de 1 boleto para Festival de la Cerveza Medanal');
INSERT INTO public.venta_boleto_evento VALUES (9, '2025-09-05 13:10:00-04', 100.00, 'Venta de 2 boletos para Barquisimeto Beer Festival');
INSERT INTO public.venta_boleto_evento VALUES (10, '2025-09-12 15:30:00-04', 80.00, 'Venta de 2 boletos para Festival de Cerveza del Paramo');
INSERT INTO public.venta_boleto_evento VALUES (11, '2025-09-25 17:00:00-04', 200.00, 'Venta de 4 boletos para Gran Feria Cervecera de Caracas');
INSERT INTO public.venta_boleto_evento VALUES (12, '2025-10-10 18:50:00-04', 90.00, 'Venta de 3 boletos para Festival Cervecero de Oriente');
INSERT INTO public.venta_boleto_evento VALUES (13, '2025-10-20 20:00:00-04', 50.00, 'Venta de 1 boleto para Margarita Craft Beer Fest');
INSERT INTO public.venta_boleto_evento VALUES (14, '2025-11-05 10:40:00-04', 40.00, 'Venta de 2 boletos para Festival de la Cosecha Cervecera');
INSERT INTO public.venta_boleto_evento VALUES (15, '2025-11-15 11:25:00-04', 60.00, 'Venta de 2 boletos para Festival Cumana 500 y Cerveza');
INSERT INTO public.venta_boleto_evento VALUES (16, '2025-12-02 16:00:00-04', 70.00, 'Venta de 2 boletos para Feria Cervecera de San Cristobal');
INSERT INTO public.venta_boleto_evento VALUES (17, '2025-12-20 19:15:00-04', 45.00, 'Venta de 1 boleto para Festival Cervecero del Litoral');
INSERT INTO public.venta_boleto_evento VALUES (18, '2026-01-10 22:00:00-04', 120.00, 'Venta de 3 boletos para Festival de la Chinita Cervecera');
INSERT INTO public.venta_boleto_evento VALUES (19, '2026-02-15 08:30:00-04', 300.00, 'Venta de 5 boletos para Caracas Beer Week');
INSERT INTO public.venta_boleto_evento VALUES (20, '2026-03-05 14:00:00-04', 150.00, 'Venta de 2 boletos para Taller de Cerveza en el Archipielago');


--
-- Data for Name: asistencia_evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.asistencia_evento VALUES (1, '2025-07-20 19:00:00-04', 1, 1, 1);
INSERT INTO public.asistencia_evento VALUES (2, '2025-08-01 16:00:00-04', 2, 6, 2);
INSERT INTO public.asistencia_evento VALUES (3, '2025-10-24 12:00:00-04', 3, 16, 3);
INSERT INTO public.asistencia_evento VALUES (4, '2026-01-15 09:00:00-04', 4, 18, 4);
INSERT INTO public.asistencia_evento VALUES (5, '2026-03-20 18:00:00-04', 5, 26, 5);
INSERT INTO public.asistencia_evento VALUES (6, '2025-11-07 16:00:00-04', 6, 31, 6);
INSERT INTO public.asistencia_evento VALUES (7, '2025-09-12 17:00:00-04', 7, 36, 7);
INSERT INTO public.asistencia_evento VALUES (8, '2025-12-26 16:00:00-04', 8, 46, 8);
INSERT INTO public.asistencia_evento VALUES (9, '2025-09-12 17:00:00-04', 9, 56, 9);
INSERT INTO public.asistencia_evento VALUES (10, '2026-01-02 14:00:00-04', 10, 61, 10);
INSERT INTO public.asistencia_evento VALUES (11, '2025-11-14 15:00:00-04', 11, 66, 11);
INSERT INTO public.asistencia_evento VALUES (12, '2026-06-12 17:00:00-04', 12, 71, 12);
INSERT INTO public.asistencia_evento VALUES (13, '2025-12-12 16:00:00-04', 13, 76, 13);
INSERT INTO public.asistencia_evento VALUES (14, '2026-02-06 16:00:00-04', 14, 81, 14);
INSERT INTO public.asistencia_evento VALUES (15, '2025-11-27 17:00:00-04', 15, 86, 15);
INSERT INTO public.asistencia_evento VALUES (16, '2026-01-16 16:00:00-04', 1, 91, 16);
INSERT INTO public.asistencia_evento VALUES (17, '2025-10-24 17:00:00-04', 2, 101, 17);
INSERT INTO public.asistencia_evento VALUES (18, '2025-11-14 18:00:00-04', 3, 111, 18);
INSERT INTO public.asistencia_evento VALUES (19, '2026-04-20 12:00:00-04', 4, 121, 19);
INSERT INTO public.asistencia_evento VALUES (20, '2026-08-05 10:00:00-04', 5, 125, 20);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_content_type VALUES (1, 'admin_interface', 'theme');
INSERT INTO public.django_content_type VALUES (2, 'admin', 'logentry');
INSERT INTO public.django_content_type VALUES (3, 'auth', 'permission');
INSERT INTO public.django_content_type VALUES (4, 'auth', 'group');
INSERT INTO public.django_content_type VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO public.django_content_type VALUES (6, 'sessions', 'session');
INSERT INTO public.django_content_type VALUES (7, 'store', 'afiliacion');
INSERT INTO public.django_content_type VALUES (8, 'store', 'almacen');
INSERT INTO public.django_content_type VALUES (9, 'store', 'caracteristica');
INSERT INTO public.django_content_type VALUES (10, 'store', 'cargo');
INSERT INTO public.django_content_type VALUES (11, 'store', 'cerveza');
INSERT INTO public.django_content_type VALUES (12, 'store', 'cliente');
INSERT INTO public.django_content_type VALUES (13, 'store', 'contacto_proveedor');
INSERT INTO public.django_content_type VALUES (14, 'store', 'departamento');
INSERT INTO public.django_content_type VALUES (15, 'store', 'empleado');
INSERT INTO public.django_content_type VALUES (16, 'store', 'estatus');
INSERT INTO public.django_content_type VALUES (17, 'store', 'estilo_cerveza');
INSERT INTO public.django_content_type VALUES (18, 'store', 'evento');
INSERT INTO public.django_content_type VALUES (19, 'store', 'historico_precio_punto');
INSERT INTO public.django_content_type VALUES (20, 'store', 'horario');
INSERT INTO public.django_content_type VALUES (21, 'store', 'ingrediente');
INSERT INTO public.django_content_type VALUES (22, 'store', 'instruccion');
INSERT INTO public.django_content_type VALUES (23, 'store', 'moneda');
INSERT INTO public.django_content_type VALUES (24, 'store', 'oferta');
INSERT INTO public.django_content_type VALUES (25, 'store', 'receta');
INSERT INTO public.django_content_type VALUES (26, 'store', 'tipo_beneficio');
INSERT INTO public.django_content_type VALUES (27, 'store', 'tipo_cerveza');
INSERT INTO public.django_content_type VALUES (28, 'store', 'venta_boleto_evento');
INSERT INTO public.django_content_type VALUES (29, 'store', 'usuario');
INSERT INTO public.django_content_type VALUES (30, 'store', 'cerv_car');
INSERT INTO public.django_content_type VALUES (31, 'store', 'contacto_cliente');
INSERT INTO public.django_content_type VALUES (32, 'store', 'cuenta_punto');
INSERT INTO public.django_content_type VALUES (33, 'store', 'asistencia');
INSERT INTO public.django_content_type VALUES (34, 'store', 'afi_est');
INSERT INTO public.django_content_type VALUES (35, 'store', 'eve_pro');
INSERT INTO public.django_content_type VALUES (36, 'store', 'lugar');
INSERT INTO public.django_content_type VALUES (37, 'store', 'lugar_tienda');
INSERT INTO public.django_content_type VALUES (38, 'store', 'anaquel');
INSERT INTO public.django_content_type VALUES (39, 'store', 'metodo_pago');
INSERT INTO public.django_content_type VALUES (40, 'store', 'historico_moneda');
INSERT INTO public.django_content_type VALUES (41, 'store', 'pago_efectivo');
INSERT INTO public.django_content_type VALUES (42, 'store', 'presentacion');
INSERT INTO public.django_content_type VALUES (43, 'store', 'pre_alm');
INSERT INTO public.django_content_type VALUES (44, 'store', 'inventario');
INSERT INTO public.django_content_type VALUES (45, 'store', 'existencia_evento');
INSERT INTO public.django_content_type VALUES (46, 'store', 'proveedor');
INSERT INTO public.django_content_type VALUES (47, 'store', 'correo_electronico');
INSERT INTO public.django_content_type VALUES (48, 'store', 'rec_ins');
INSERT INTO public.django_content_type VALUES (49, 'store', 'rec_ing');
INSERT INTO public.django_content_type VALUES (50, 'store', 'solicitud_compra');
INSERT INTO public.django_content_type VALUES (51, 'store', 'sol_com_est');
INSERT INTO public.django_content_type VALUES (52, 'store', 'detalle_compra');
INSERT INTO public.django_content_type VALUES (53, 'store', 'solicitud_reposicion');
INSERT INTO public.django_content_type VALUES (54, 'store', 'sol_rep_est');
INSERT INTO public.django_content_type VALUES (55, 'store', 'telefono');
INSERT INTO public.django_content_type VALUES (56, 'store', 'tienda');
INSERT INTO public.django_content_type VALUES (57, 'store', 'emp_car_hor');
INSERT INTO public.django_content_type VALUES (58, 'store', 'dep_tie');
INSERT INTO public.django_content_type VALUES (59, 'store', 'emp_tip_ben');
INSERT INTO public.django_content_type VALUES (60, 'store', 'car_tip_cer');
INSERT INTO public.django_content_type VALUES (61, 'store', 'tipo_estilo_cerveza');
INSERT INTO public.django_content_type VALUES (62, 'store', 'tipo_evento');
INSERT INTO public.django_content_type VALUES (63, 'store', 'vacacion');
INSERT INTO public.django_content_type VALUES (64, 'store', 'asistencia_evento');
INSERT INTO public.django_content_type VALUES (65, 'store', 'venta_evento');
INSERT INTO public.django_content_type VALUES (66, 'store', 'detalle_venta_evento');
INSERT INTO public.django_content_type VALUES (67, 'store', 'venta_fisica');
INSERT INTO public.django_content_type VALUES (68, 'store', 'detalle_venta_fisica');
INSERT INTO public.django_content_type VALUES (69, 'store', 'venta_online');
INSERT INTO public.django_content_type VALUES (70, 'store', 'ven_onl_est');
INSERT INTO public.django_content_type VALUES (71, 'store', 'pago');
INSERT INTO public.django_content_type VALUES (72, 'store', 'detalle_venta_online');
INSERT INTO public.django_content_type VALUES (73, 'store', 'emp_car');


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.auth_permission VALUES (1, 'Can add Theme', 1, 'add_theme');
INSERT INTO public.auth_permission VALUES (2, 'Can change Theme', 1, 'change_theme');
INSERT INTO public.auth_permission VALUES (3, 'Can delete Theme', 1, 'delete_theme');
INSERT INTO public.auth_permission VALUES (4, 'Can view Theme', 1, 'view_theme');
INSERT INTO public.auth_permission VALUES (5, 'Can add log entry', 2, 'add_logentry');
INSERT INTO public.auth_permission VALUES (6, 'Can change log entry', 2, 'change_logentry');
INSERT INTO public.auth_permission VALUES (7, 'Can delete log entry', 2, 'delete_logentry');
INSERT INTO public.auth_permission VALUES (8, 'Can view log entry', 2, 'view_logentry');
INSERT INTO public.auth_permission VALUES (9, 'Can add permission', 3, 'add_permission');
INSERT INTO public.auth_permission VALUES (10, 'Can change permission', 3, 'change_permission');
INSERT INTO public.auth_permission VALUES (11, 'Can delete permission', 3, 'delete_permission');
INSERT INTO public.auth_permission VALUES (12, 'Can view permission', 3, 'view_permission');
INSERT INTO public.auth_permission VALUES (13, 'Can add group', 4, 'add_group');
INSERT INTO public.auth_permission VALUES (14, 'Can change group', 4, 'change_group');
INSERT INTO public.auth_permission VALUES (15, 'Can delete group', 4, 'delete_group');
INSERT INTO public.auth_permission VALUES (16, 'Can view group', 4, 'view_group');
INSERT INTO public.auth_permission VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO public.auth_permission VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO public.auth_permission VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO public.auth_permission VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO public.auth_permission VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO public.auth_permission VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO public.auth_permission VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO public.auth_permission VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO public.auth_permission VALUES (25, 'Can add afiliacion', 7, 'add_afiliacion');
INSERT INTO public.auth_permission VALUES (26, 'Can change afiliacion', 7, 'change_afiliacion');
INSERT INTO public.auth_permission VALUES (27, 'Can delete afiliacion', 7, 'delete_afiliacion');
INSERT INTO public.auth_permission VALUES (28, 'Can view afiliacion', 7, 'view_afiliacion');
INSERT INTO public.auth_permission VALUES (29, 'Can add almacen', 8, 'add_almacen');
INSERT INTO public.auth_permission VALUES (30, 'Can change almacen', 8, 'change_almacen');
INSERT INTO public.auth_permission VALUES (31, 'Can delete almacen', 8, 'delete_almacen');
INSERT INTO public.auth_permission VALUES (32, 'Can view almacen', 8, 'view_almacen');
INSERT INTO public.auth_permission VALUES (33, 'Can add caracteristica', 9, 'add_caracteristica');
INSERT INTO public.auth_permission VALUES (34, 'Can change caracteristica', 9, 'change_caracteristica');
INSERT INTO public.auth_permission VALUES (35, 'Can delete caracteristica', 9, 'delete_caracteristica');
INSERT INTO public.auth_permission VALUES (36, 'Can view caracteristica', 9, 'view_caracteristica');
INSERT INTO public.auth_permission VALUES (37, 'Can add cargo', 10, 'add_cargo');
INSERT INTO public.auth_permission VALUES (38, 'Can change cargo', 10, 'change_cargo');
INSERT INTO public.auth_permission VALUES (39, 'Can delete cargo', 10, 'delete_cargo');
INSERT INTO public.auth_permission VALUES (40, 'Can view cargo', 10, 'view_cargo');
INSERT INTO public.auth_permission VALUES (41, 'Can add cerveza', 11, 'add_cerveza');
INSERT INTO public.auth_permission VALUES (42, 'Can change cerveza', 11, 'change_cerveza');
INSERT INTO public.auth_permission VALUES (43, 'Can delete cerveza', 11, 'delete_cerveza');
INSERT INTO public.auth_permission VALUES (44, 'Can view cerveza', 11, 'view_cerveza');
INSERT INTO public.auth_permission VALUES (45, 'Can add cliente', 12, 'add_cliente');
INSERT INTO public.auth_permission VALUES (46, 'Can change cliente', 12, 'change_cliente');
INSERT INTO public.auth_permission VALUES (47, 'Can delete cliente', 12, 'delete_cliente');
INSERT INTO public.auth_permission VALUES (48, 'Can view cliente', 12, 'view_cliente');
INSERT INTO public.auth_permission VALUES (49, 'Can add contacto_proveedor', 13, 'add_contacto_proveedor');
INSERT INTO public.auth_permission VALUES (50, 'Can change contacto_proveedor', 13, 'change_contacto_proveedor');
INSERT INTO public.auth_permission VALUES (51, 'Can delete contacto_proveedor', 13, 'delete_contacto_proveedor');
INSERT INTO public.auth_permission VALUES (52, 'Can view contacto_proveedor', 13, 'view_contacto_proveedor');
INSERT INTO public.auth_permission VALUES (53, 'Can add departamento', 14, 'add_departamento');
INSERT INTO public.auth_permission VALUES (54, 'Can change departamento', 14, 'change_departamento');
INSERT INTO public.auth_permission VALUES (55, 'Can delete departamento', 14, 'delete_departamento');
INSERT INTO public.auth_permission VALUES (56, 'Can view departamento', 14, 'view_departamento');
INSERT INTO public.auth_permission VALUES (57, 'Can add empleado', 15, 'add_empleado');
INSERT INTO public.auth_permission VALUES (58, 'Can change empleado', 15, 'change_empleado');
INSERT INTO public.auth_permission VALUES (59, 'Can delete empleado', 15, 'delete_empleado');
INSERT INTO public.auth_permission VALUES (60, 'Can view empleado', 15, 'view_empleado');
INSERT INTO public.auth_permission VALUES (61, 'Can add estatus', 16, 'add_estatus');
INSERT INTO public.auth_permission VALUES (62, 'Can change estatus', 16, 'change_estatus');
INSERT INTO public.auth_permission VALUES (63, 'Can delete estatus', 16, 'delete_estatus');
INSERT INTO public.auth_permission VALUES (64, 'Can view estatus', 16, 'view_estatus');
INSERT INTO public.auth_permission VALUES (65, 'Can add estilo_cerveza', 17, 'add_estilo_cerveza');
INSERT INTO public.auth_permission VALUES (66, 'Can change estilo_cerveza', 17, 'change_estilo_cerveza');
INSERT INTO public.auth_permission VALUES (67, 'Can delete estilo_cerveza', 17, 'delete_estilo_cerveza');
INSERT INTO public.auth_permission VALUES (68, 'Can view estilo_cerveza', 17, 'view_estilo_cerveza');
INSERT INTO public.auth_permission VALUES (69, 'Can add evento', 18, 'add_evento');
INSERT INTO public.auth_permission VALUES (70, 'Can change evento', 18, 'change_evento');
INSERT INTO public.auth_permission VALUES (71, 'Can delete evento', 18, 'delete_evento');
INSERT INTO public.auth_permission VALUES (72, 'Can view evento', 18, 'view_evento');
INSERT INTO public.auth_permission VALUES (73, 'Can add historico_precio_punto', 19, 'add_historico_precio_punto');
INSERT INTO public.auth_permission VALUES (74, 'Can change historico_precio_punto', 19, 'change_historico_precio_punto');
INSERT INTO public.auth_permission VALUES (75, 'Can delete historico_precio_punto', 19, 'delete_historico_precio_punto');
INSERT INTO public.auth_permission VALUES (76, 'Can view historico_precio_punto', 19, 'view_historico_precio_punto');
INSERT INTO public.auth_permission VALUES (77, 'Can add horario', 20, 'add_horario');
INSERT INTO public.auth_permission VALUES (78, 'Can change horario', 20, 'change_horario');
INSERT INTO public.auth_permission VALUES (79, 'Can delete horario', 20, 'delete_horario');
INSERT INTO public.auth_permission VALUES (80, 'Can view horario', 20, 'view_horario');
INSERT INTO public.auth_permission VALUES (81, 'Can add ingrediente', 21, 'add_ingrediente');
INSERT INTO public.auth_permission VALUES (82, 'Can change ingrediente', 21, 'change_ingrediente');
INSERT INTO public.auth_permission VALUES (83, 'Can delete ingrediente', 21, 'delete_ingrediente');
INSERT INTO public.auth_permission VALUES (84, 'Can view ingrediente', 21, 'view_ingrediente');
INSERT INTO public.auth_permission VALUES (85, 'Can add instruccion', 22, 'add_instruccion');
INSERT INTO public.auth_permission VALUES (86, 'Can change instruccion', 22, 'change_instruccion');
INSERT INTO public.auth_permission VALUES (87, 'Can delete instruccion', 22, 'delete_instruccion');
INSERT INTO public.auth_permission VALUES (88, 'Can view instruccion', 22, 'view_instruccion');
INSERT INTO public.auth_permission VALUES (89, 'Can add moneda', 23, 'add_moneda');
INSERT INTO public.auth_permission VALUES (90, 'Can change moneda', 23, 'change_moneda');
INSERT INTO public.auth_permission VALUES (91, 'Can delete moneda', 23, 'delete_moneda');
INSERT INTO public.auth_permission VALUES (92, 'Can view moneda', 23, 'view_moneda');
INSERT INTO public.auth_permission VALUES (93, 'Can add oferta', 24, 'add_oferta');
INSERT INTO public.auth_permission VALUES (94, 'Can change oferta', 24, 'change_oferta');
INSERT INTO public.auth_permission VALUES (95, 'Can delete oferta', 24, 'delete_oferta');
INSERT INTO public.auth_permission VALUES (96, 'Can view oferta', 24, 'view_oferta');
INSERT INTO public.auth_permission VALUES (97, 'Can add receta', 25, 'add_receta');
INSERT INTO public.auth_permission VALUES (98, 'Can change receta', 25, 'change_receta');
INSERT INTO public.auth_permission VALUES (99, 'Can delete receta', 25, 'delete_receta');
INSERT INTO public.auth_permission VALUES (100, 'Can view receta', 25, 'view_receta');
INSERT INTO public.auth_permission VALUES (101, 'Can add tipo_beneficio', 26, 'add_tipo_beneficio');
INSERT INTO public.auth_permission VALUES (102, 'Can change tipo_beneficio', 26, 'change_tipo_beneficio');
INSERT INTO public.auth_permission VALUES (103, 'Can delete tipo_beneficio', 26, 'delete_tipo_beneficio');
INSERT INTO public.auth_permission VALUES (104, 'Can view tipo_beneficio', 26, 'view_tipo_beneficio');
INSERT INTO public.auth_permission VALUES (105, 'Can add tipo_cerveza', 27, 'add_tipo_cerveza');
INSERT INTO public.auth_permission VALUES (106, 'Can change tipo_cerveza', 27, 'change_tipo_cerveza');
INSERT INTO public.auth_permission VALUES (107, 'Can delete tipo_cerveza', 27, 'delete_tipo_cerveza');
INSERT INTO public.auth_permission VALUES (108, 'Can view tipo_cerveza', 27, 'view_tipo_cerveza');
INSERT INTO public.auth_permission VALUES (109, 'Can add venta_boleto_evento', 28, 'add_venta_boleto_evento');
INSERT INTO public.auth_permission VALUES (110, 'Can change venta_boleto_evento', 28, 'change_venta_boleto_evento');
INSERT INTO public.auth_permission VALUES (111, 'Can delete venta_boleto_evento', 28, 'delete_venta_boleto_evento');
INSERT INTO public.auth_permission VALUES (112, 'Can view venta_boleto_evento', 28, 'view_venta_boleto_evento');
INSERT INTO public.auth_permission VALUES (113, 'Can add usuario', 29, 'add_usuario');
INSERT INTO public.auth_permission VALUES (114, 'Can change usuario', 29, 'change_usuario');
INSERT INTO public.auth_permission VALUES (115, 'Can delete usuario', 29, 'delete_usuario');
INSERT INTO public.auth_permission VALUES (116, 'Can view usuario', 29, 'view_usuario');
INSERT INTO public.auth_permission VALUES (117, 'Can add cerv_car', 30, 'add_cerv_car');
INSERT INTO public.auth_permission VALUES (118, 'Can change cerv_car', 30, 'change_cerv_car');
INSERT INTO public.auth_permission VALUES (119, 'Can delete cerv_car', 30, 'delete_cerv_car');
INSERT INTO public.auth_permission VALUES (120, 'Can view cerv_car', 30, 'view_cerv_car');
INSERT INTO public.auth_permission VALUES (121, 'Can add contacto_cliente', 31, 'add_contacto_cliente');
INSERT INTO public.auth_permission VALUES (122, 'Can change contacto_cliente', 31, 'change_contacto_cliente');
INSERT INTO public.auth_permission VALUES (123, 'Can delete contacto_cliente', 31, 'delete_contacto_cliente');
INSERT INTO public.auth_permission VALUES (124, 'Can view contacto_cliente', 31, 'view_contacto_cliente');
INSERT INTO public.auth_permission VALUES (125, 'Can add cuenta_punto', 32, 'add_cuenta_punto');
INSERT INTO public.auth_permission VALUES (126, 'Can change cuenta_punto', 32, 'change_cuenta_punto');
INSERT INTO public.auth_permission VALUES (127, 'Can delete cuenta_punto', 32, 'delete_cuenta_punto');
INSERT INTO public.auth_permission VALUES (128, 'Can view cuenta_punto', 32, 'view_cuenta_punto');
INSERT INTO public.auth_permission VALUES (129, 'Can add asistencia', 33, 'add_asistencia');
INSERT INTO public.auth_permission VALUES (130, 'Can change asistencia', 33, 'change_asistencia');
INSERT INTO public.auth_permission VALUES (131, 'Can delete asistencia', 33, 'delete_asistencia');
INSERT INTO public.auth_permission VALUES (132, 'Can view asistencia', 33, 'view_asistencia');
INSERT INTO public.auth_permission VALUES (133, 'Can add afi_est', 34, 'add_afi_est');
INSERT INTO public.auth_permission VALUES (134, 'Can change afi_est', 34, 'change_afi_est');
INSERT INTO public.auth_permission VALUES (135, 'Can delete afi_est', 34, 'delete_afi_est');
INSERT INTO public.auth_permission VALUES (136, 'Can view afi_est', 34, 'view_afi_est');
INSERT INTO public.auth_permission VALUES (137, 'Can add eve_pro', 35, 'add_eve_pro');
INSERT INTO public.auth_permission VALUES (138, 'Can change eve_pro', 35, 'change_eve_pro');
INSERT INTO public.auth_permission VALUES (139, 'Can delete eve_pro', 35, 'delete_eve_pro');
INSERT INTO public.auth_permission VALUES (140, 'Can view eve_pro', 35, 'view_eve_pro');
INSERT INTO public.auth_permission VALUES (141, 'Can add lugar', 36, 'add_lugar');
INSERT INTO public.auth_permission VALUES (142, 'Can change lugar', 36, 'change_lugar');
INSERT INTO public.auth_permission VALUES (143, 'Can delete lugar', 36, 'delete_lugar');
INSERT INTO public.auth_permission VALUES (144, 'Can view lugar', 36, 'view_lugar');
INSERT INTO public.auth_permission VALUES (145, 'Can add lugar_tienda', 37, 'add_lugar_tienda');
INSERT INTO public.auth_permission VALUES (146, 'Can change lugar_tienda', 37, 'change_lugar_tienda');
INSERT INTO public.auth_permission VALUES (147, 'Can delete lugar_tienda', 37, 'delete_lugar_tienda');
INSERT INTO public.auth_permission VALUES (148, 'Can view lugar_tienda', 37, 'view_lugar_tienda');
INSERT INTO public.auth_permission VALUES (149, 'Can add anaquel', 38, 'add_anaquel');
INSERT INTO public.auth_permission VALUES (150, 'Can change anaquel', 38, 'change_anaquel');
INSERT INTO public.auth_permission VALUES (151, 'Can delete anaquel', 38, 'delete_anaquel');
INSERT INTO public.auth_permission VALUES (152, 'Can view anaquel', 38, 'view_anaquel');
INSERT INTO public.auth_permission VALUES (153, 'Can add metodo_pago', 39, 'add_metodo_pago');
INSERT INTO public.auth_permission VALUES (154, 'Can change metodo_pago', 39, 'change_metodo_pago');
INSERT INTO public.auth_permission VALUES (155, 'Can delete metodo_pago', 39, 'delete_metodo_pago');
INSERT INTO public.auth_permission VALUES (156, 'Can view metodo_pago', 39, 'view_metodo_pago');
INSERT INTO public.auth_permission VALUES (157, 'Can add historico_moneda', 40, 'add_historico_moneda');
INSERT INTO public.auth_permission VALUES (158, 'Can change historico_moneda', 40, 'change_historico_moneda');
INSERT INTO public.auth_permission VALUES (159, 'Can delete historico_moneda', 40, 'delete_historico_moneda');
INSERT INTO public.auth_permission VALUES (160, 'Can view historico_moneda', 40, 'view_historico_moneda');
INSERT INTO public.auth_permission VALUES (161, 'Can add pago_efectivo', 41, 'add_pago_efectivo');
INSERT INTO public.auth_permission VALUES (162, 'Can change pago_efectivo', 41, 'change_pago_efectivo');
INSERT INTO public.auth_permission VALUES (163, 'Can delete pago_efectivo', 41, 'delete_pago_efectivo');
INSERT INTO public.auth_permission VALUES (164, 'Can view pago_efectivo', 41, 'view_pago_efectivo');
INSERT INTO public.auth_permission VALUES (165, 'Can add presentacion', 42, 'add_presentacion');
INSERT INTO public.auth_permission VALUES (166, 'Can change presentacion', 42, 'change_presentacion');
INSERT INTO public.auth_permission VALUES (167, 'Can delete presentacion', 42, 'delete_presentacion');
INSERT INTO public.auth_permission VALUES (168, 'Can view presentacion', 42, 'view_presentacion');
INSERT INTO public.auth_permission VALUES (169, 'Can add pre_alm', 43, 'add_pre_alm');
INSERT INTO public.auth_permission VALUES (170, 'Can change pre_alm', 43, 'change_pre_alm');
INSERT INTO public.auth_permission VALUES (171, 'Can delete pre_alm', 43, 'delete_pre_alm');
INSERT INTO public.auth_permission VALUES (172, 'Can view pre_alm', 43, 'view_pre_alm');
INSERT INTO public.auth_permission VALUES (173, 'Can add inventario', 44, 'add_inventario');
INSERT INTO public.auth_permission VALUES (174, 'Can change inventario', 44, 'change_inventario');
INSERT INTO public.auth_permission VALUES (175, 'Can delete inventario', 44, 'delete_inventario');
INSERT INTO public.auth_permission VALUES (176, 'Can view inventario', 44, 'view_inventario');
INSERT INTO public.auth_permission VALUES (177, 'Can add existencia_evento', 45, 'add_existencia_evento');
INSERT INTO public.auth_permission VALUES (178, 'Can change existencia_evento', 45, 'change_existencia_evento');
INSERT INTO public.auth_permission VALUES (179, 'Can delete existencia_evento', 45, 'delete_existencia_evento');
INSERT INTO public.auth_permission VALUES (180, 'Can view existencia_evento', 45, 'view_existencia_evento');
INSERT INTO public.auth_permission VALUES (181, 'Can add proveedor', 46, 'add_proveedor');
INSERT INTO public.auth_permission VALUES (182, 'Can change proveedor', 46, 'change_proveedor');
INSERT INTO public.auth_permission VALUES (183, 'Can delete proveedor', 46, 'delete_proveedor');
INSERT INTO public.auth_permission VALUES (184, 'Can view proveedor', 46, 'view_proveedor');
INSERT INTO public.auth_permission VALUES (185, 'Can add correo_electronico', 47, 'add_correo_electronico');
INSERT INTO public.auth_permission VALUES (186, 'Can change correo_electronico', 47, 'change_correo_electronico');
INSERT INTO public.auth_permission VALUES (187, 'Can delete correo_electronico', 47, 'delete_correo_electronico');
INSERT INTO public.auth_permission VALUES (188, 'Can view correo_electronico', 47, 'view_correo_electronico');
INSERT INTO public.auth_permission VALUES (189, 'Can add rec_ins', 48, 'add_rec_ins');
INSERT INTO public.auth_permission VALUES (190, 'Can change rec_ins', 48, 'change_rec_ins');
INSERT INTO public.auth_permission VALUES (191, 'Can delete rec_ins', 48, 'delete_rec_ins');
INSERT INTO public.auth_permission VALUES (192, 'Can view rec_ins', 48, 'view_rec_ins');
INSERT INTO public.auth_permission VALUES (193, 'Can add rec_ing', 49, 'add_rec_ing');
INSERT INTO public.auth_permission VALUES (194, 'Can change rec_ing', 49, 'change_rec_ing');
INSERT INTO public.auth_permission VALUES (195, 'Can delete rec_ing', 49, 'delete_rec_ing');
INSERT INTO public.auth_permission VALUES (196, 'Can view rec_ing', 49, 'view_rec_ing');
INSERT INTO public.auth_permission VALUES (197, 'Can add solicitud_compra', 50, 'add_solicitud_compra');
INSERT INTO public.auth_permission VALUES (198, 'Can change solicitud_compra', 50, 'change_solicitud_compra');
INSERT INTO public.auth_permission VALUES (199, 'Can delete solicitud_compra', 50, 'delete_solicitud_compra');
INSERT INTO public.auth_permission VALUES (200, 'Can view solicitud_compra', 50, 'view_solicitud_compra');
INSERT INTO public.auth_permission VALUES (201, 'Can add sol_com_est', 51, 'add_sol_com_est');
INSERT INTO public.auth_permission VALUES (202, 'Can change sol_com_est', 51, 'change_sol_com_est');
INSERT INTO public.auth_permission VALUES (203, 'Can delete sol_com_est', 51, 'delete_sol_com_est');
INSERT INTO public.auth_permission VALUES (204, 'Can view sol_com_est', 51, 'view_sol_com_est');
INSERT INTO public.auth_permission VALUES (205, 'Can add detalle_compra', 52, 'add_detalle_compra');
INSERT INTO public.auth_permission VALUES (206, 'Can change detalle_compra', 52, 'change_detalle_compra');
INSERT INTO public.auth_permission VALUES (207, 'Can delete detalle_compra', 52, 'delete_detalle_compra');
INSERT INTO public.auth_permission VALUES (208, 'Can view detalle_compra', 52, 'view_detalle_compra');
INSERT INTO public.auth_permission VALUES (209, 'Can add solicitud_reposicion', 53, 'add_solicitud_reposicion');
INSERT INTO public.auth_permission VALUES (210, 'Can change solicitud_reposicion', 53, 'change_solicitud_reposicion');
INSERT INTO public.auth_permission VALUES (211, 'Can delete solicitud_reposicion', 53, 'delete_solicitud_reposicion');
INSERT INTO public.auth_permission VALUES (212, 'Can view solicitud_reposicion', 53, 'view_solicitud_reposicion');
INSERT INTO public.auth_permission VALUES (213, 'Can add sol_rep_est', 54, 'add_sol_rep_est');
INSERT INTO public.auth_permission VALUES (214, 'Can change sol_rep_est', 54, 'change_sol_rep_est');
INSERT INTO public.auth_permission VALUES (215, 'Can delete sol_rep_est', 54, 'delete_sol_rep_est');
INSERT INTO public.auth_permission VALUES (216, 'Can view sol_rep_est', 54, 'view_sol_rep_est');
INSERT INTO public.auth_permission VALUES (217, 'Can add telefono', 55, 'add_telefono');
INSERT INTO public.auth_permission VALUES (218, 'Can change telefono', 55, 'change_telefono');
INSERT INTO public.auth_permission VALUES (219, 'Can delete telefono', 55, 'delete_telefono');
INSERT INTO public.auth_permission VALUES (220, 'Can view telefono', 55, 'view_telefono');
INSERT INTO public.auth_permission VALUES (221, 'Can add tienda', 56, 'add_tienda');
INSERT INTO public.auth_permission VALUES (222, 'Can change tienda', 56, 'change_tienda');
INSERT INTO public.auth_permission VALUES (223, 'Can delete tienda', 56, 'delete_tienda');
INSERT INTO public.auth_permission VALUES (224, 'Can view tienda', 56, 'view_tienda');
INSERT INTO public.auth_permission VALUES (225, 'Can add emp_car_hor', 57, 'add_emp_car_hor');
INSERT INTO public.auth_permission VALUES (226, 'Can change emp_car_hor', 57, 'change_emp_car_hor');
INSERT INTO public.auth_permission VALUES (227, 'Can delete emp_car_hor', 57, 'delete_emp_car_hor');
INSERT INTO public.auth_permission VALUES (228, 'Can view emp_car_hor', 57, 'view_emp_car_hor');
INSERT INTO public.auth_permission VALUES (229, 'Can add dep_tie', 58, 'add_dep_tie');
INSERT INTO public.auth_permission VALUES (230, 'Can change dep_tie', 58, 'change_dep_tie');
INSERT INTO public.auth_permission VALUES (231, 'Can delete dep_tie', 58, 'delete_dep_tie');
INSERT INTO public.auth_permission VALUES (232, 'Can view dep_tie', 58, 'view_dep_tie');
INSERT INTO public.auth_permission VALUES (233, 'Can add emp_tip_ben', 59, 'add_emp_tip_ben');
INSERT INTO public.auth_permission VALUES (234, 'Can change emp_tip_ben', 59, 'change_emp_tip_ben');
INSERT INTO public.auth_permission VALUES (235, 'Can delete emp_tip_ben', 59, 'delete_emp_tip_ben');
INSERT INTO public.auth_permission VALUES (236, 'Can view emp_tip_ben', 59, 'view_emp_tip_ben');
INSERT INTO public.auth_permission VALUES (237, 'Can add car_tip_cer', 60, 'add_car_tip_cer');
INSERT INTO public.auth_permission VALUES (238, 'Can change car_tip_cer', 60, 'change_car_tip_cer');
INSERT INTO public.auth_permission VALUES (239, 'Can delete car_tip_cer', 60, 'delete_car_tip_cer');
INSERT INTO public.auth_permission VALUES (240, 'Can view car_tip_cer', 60, 'view_car_tip_cer');
INSERT INTO public.auth_permission VALUES (241, 'Can add tipo_estilo_cerveza', 61, 'add_tipo_estilo_cerveza');
INSERT INTO public.auth_permission VALUES (242, 'Can change tipo_estilo_cerveza', 61, 'change_tipo_estilo_cerveza');
INSERT INTO public.auth_permission VALUES (243, 'Can delete tipo_estilo_cerveza', 61, 'delete_tipo_estilo_cerveza');
INSERT INTO public.auth_permission VALUES (244, 'Can view tipo_estilo_cerveza', 61, 'view_tipo_estilo_cerveza');
INSERT INTO public.auth_permission VALUES (245, 'Can add tipo_evento', 62, 'add_tipo_evento');
INSERT INTO public.auth_permission VALUES (246, 'Can change tipo_evento', 62, 'change_tipo_evento');
INSERT INTO public.auth_permission VALUES (247, 'Can delete tipo_evento', 62, 'delete_tipo_evento');
INSERT INTO public.auth_permission VALUES (248, 'Can view tipo_evento', 62, 'view_tipo_evento');
INSERT INTO public.auth_permission VALUES (249, 'Can add vacacion', 63, 'add_vacacion');
INSERT INTO public.auth_permission VALUES (250, 'Can change vacacion', 63, 'change_vacacion');
INSERT INTO public.auth_permission VALUES (251, 'Can delete vacacion', 63, 'delete_vacacion');
INSERT INTO public.auth_permission VALUES (252, 'Can view vacacion', 63, 'view_vacacion');
INSERT INTO public.auth_permission VALUES (253, 'Can add asistencia_evento', 64, 'add_asistencia_evento');
INSERT INTO public.auth_permission VALUES (254, 'Can change asistencia_evento', 64, 'change_asistencia_evento');
INSERT INTO public.auth_permission VALUES (255, 'Can delete asistencia_evento', 64, 'delete_asistencia_evento');
INSERT INTO public.auth_permission VALUES (256, 'Can view asistencia_evento', 64, 'view_asistencia_evento');
INSERT INTO public.auth_permission VALUES (257, 'Can add venta_evento', 65, 'add_venta_evento');
INSERT INTO public.auth_permission VALUES (258, 'Can change venta_evento', 65, 'change_venta_evento');
INSERT INTO public.auth_permission VALUES (259, 'Can delete venta_evento', 65, 'delete_venta_evento');
INSERT INTO public.auth_permission VALUES (260, 'Can view venta_evento', 65, 'view_venta_evento');
INSERT INTO public.auth_permission VALUES (261, 'Can add detalle_venta_evento', 66, 'add_detalle_venta_evento');
INSERT INTO public.auth_permission VALUES (262, 'Can change detalle_venta_evento', 66, 'change_detalle_venta_evento');
INSERT INTO public.auth_permission VALUES (263, 'Can delete detalle_venta_evento', 66, 'delete_detalle_venta_evento');
INSERT INTO public.auth_permission VALUES (264, 'Can view detalle_venta_evento', 66, 'view_detalle_venta_evento');
INSERT INTO public.auth_permission VALUES (265, 'Can add venta_fisica', 67, 'add_venta_fisica');
INSERT INTO public.auth_permission VALUES (266, 'Can change venta_fisica', 67, 'change_venta_fisica');
INSERT INTO public.auth_permission VALUES (267, 'Can delete venta_fisica', 67, 'delete_venta_fisica');
INSERT INTO public.auth_permission VALUES (268, 'Can view venta_fisica', 67, 'view_venta_fisica');
INSERT INTO public.auth_permission VALUES (269, 'Can add detalle_venta_fisica', 68, 'add_detalle_venta_fisica');
INSERT INTO public.auth_permission VALUES (270, 'Can change detalle_venta_fisica', 68, 'change_detalle_venta_fisica');
INSERT INTO public.auth_permission VALUES (271, 'Can delete detalle_venta_fisica', 68, 'delete_detalle_venta_fisica');
INSERT INTO public.auth_permission VALUES (272, 'Can view detalle_venta_fisica', 68, 'view_detalle_venta_fisica');
INSERT INTO public.auth_permission VALUES (273, 'Can add venta_online', 69, 'add_venta_online');
INSERT INTO public.auth_permission VALUES (274, 'Can change venta_online', 69, 'change_venta_online');
INSERT INTO public.auth_permission VALUES (275, 'Can delete venta_online', 69, 'delete_venta_online');
INSERT INTO public.auth_permission VALUES (276, 'Can view venta_online', 69, 'view_venta_online');
INSERT INTO public.auth_permission VALUES (277, 'Can add ven_onl_est', 70, 'add_ven_onl_est');
INSERT INTO public.auth_permission VALUES (278, 'Can change ven_onl_est', 70, 'change_ven_onl_est');
INSERT INTO public.auth_permission VALUES (279, 'Can delete ven_onl_est', 70, 'delete_ven_onl_est');
INSERT INTO public.auth_permission VALUES (280, 'Can view ven_onl_est', 70, 'view_ven_onl_est');
INSERT INTO public.auth_permission VALUES (281, 'Can add pago', 71, 'add_pago');
INSERT INTO public.auth_permission VALUES (282, 'Can change pago', 71, 'change_pago');
INSERT INTO public.auth_permission VALUES (283, 'Can delete pago', 71, 'delete_pago');
INSERT INTO public.auth_permission VALUES (284, 'Can view pago', 71, 'view_pago');
INSERT INTO public.auth_permission VALUES (285, 'Can add detalle_venta_online', 72, 'add_detalle_venta_online');
INSERT INTO public.auth_permission VALUES (286, 'Can change detalle_venta_online', 72, 'change_detalle_venta_online');
INSERT INTO public.auth_permission VALUES (287, 'Can delete detalle_venta_online', 72, 'delete_detalle_venta_online');
INSERT INTO public.auth_permission VALUES (288, 'Can view detalle_venta_online', 72, 'view_detalle_venta_online');
INSERT INTO public.auth_permission VALUES (289, 'Can add emp_car', 73, 'add_emp_car');
INSERT INTO public.auth_permission VALUES (290, 'Can change emp_car', 73, 'change_emp_car');
INSERT INTO public.auth_permission VALUES (291, 'Can delete emp_car', 73, 'delete_emp_car');
INSERT INTO public.auth_permission VALUES (292, 'Can view emp_car', 73, 'view_emp_car');


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: caracteristica; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.caracteristica VALUES (1, 'Aroma', 'Descripción de los olores que emite la cerveza.');
INSERT INTO public.caracteristica VALUES (2, 'Apariencia', 'Descripción del color, espuma y claridad de la cerveza.');
INSERT INTO public.caracteristica VALUES (3, 'Sabor', 'Descripción de los sabores presentes en la cerveza.');
INSERT INTO public.caracteristica VALUES (4, 'Sensacion en Boca', 'Descripción de la textura, cuerpo y carbonatación.');
INSERT INTO public.caracteristica VALUES (5, 'Impresion General', 'Resumen de las características y balance de la cerveza.');
INSERT INTO public.caracteristica VALUES (6, 'IBU', 'International Bitterness Units, medida del amargor del lúpulo.');
INSERT INTO public.caracteristica VALUES (7, 'SRM', 'Standard Reference Method, medida del color de la cerveza.');
INSERT INTO public.caracteristica VALUES (8, 'Densidad Inicial', 'Densidad del mosto antes de la fermentación.');
INSERT INTO public.caracteristica VALUES (9, 'Densidad Final', 'Densidad de la cerveza después de la fermentación.');
INSERT INTO public.caracteristica VALUES (10, 'Grado Alcoholico', 'Porcentaje de alcohol por volumen.');
INSERT INTO public.caracteristica VALUES (11, 'Comentarios', 'Notas adicionales sobre el estilo o la cerveza.');
INSERT INTO public.caracteristica VALUES (12, 'Historia', 'Origen e historia del estilo de la cerveza.');


--
-- Data for Name: tipo_cerveza; Type: TABLE DATA; Schema: public; Owner: postgres
--


INSERT INTO public.tipo_cerveza VALUES (1, 'Ale');
INSERT INTO public.tipo_cerveza VALUES (2, 'Lager');
INSERT INTO public.tipo_cerveza VALUES (3, 'Wheat Beer');
INSERT INTO public.tipo_cerveza VALUES (4, 'Bock');
INSERT INTO public.tipo_cerveza VALUES (5, 'Stout');
INSERT INTO public.tipo_cerveza VALUES (6, 'Porter');
INSERT INTO public.tipo_cerveza VALUES (7, 'Belgian Ale');
INSERT INTO public.tipo_cerveza VALUES (8, 'Lambic');
INSERT INTO public.tipo_cerveza VALUES (9, 'IPA');


--
-- Data for Name: car_tip_cer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.car_tip_cer VALUES (531, 'Lúpulo entre bajo y moderado, con notas cítricas. Carácter maltoso moderado, a menudo con notas caramelizadas.', 1, 1);
INSERT INTO public.car_tip_cer VALUES (532, 'Color entre ámbar y marrón cobrizo. Espuma amplia y blanca con buena retención. Clara, aunque con dry-hopping puede ser más turbia.', 2, 1);
INSERT INTO public.car_tip_cer VALUES (533, 'Lúpulo de moderado a alto. Malta de moderada a fuerte, con dulzura inicial y sabor a caramelo. Ésteres frutados moderados o inexistentes.', 3, 1);
INSERT INTO public.car_tip_cer VALUES (534, 'Cuerpo de medio a alto. Carbonatación de media a alta. Acabado suave sin astringencia.', 4, 1);
INSERT INTO public.car_tip_cer VALUES (535, '25 - 40', 6, 1);
INSERT INTO public.car_tip_cer VALUES (536, '10 - 17', 7, 1);
INSERT INTO public.car_tip_cer VALUES (537, '1.045 – 1.060', 8, 1);
INSERT INTO public.car_tip_cer VALUES (538, '1.010 – 1.015', 9, 1);
INSERT INTO public.car_tip_cer VALUES (539, '4.5 – 6.2%', 10, 1);
INSERT INTO public.car_tip_cer VALUES (540, 'Nació a finales del siglo XX en el Norte de California y Noroeste del Pacífico. También denominadas "Red Ales".', 12, 1);
INSERT INTO public.car_tip_cer VALUES (541, 'Aroma y sabor a lúpulo, con caracteres desde floral y frutal hasta cítrico o resinoso. Sabor a malta medio-bajo.', 1, 9);
INSERT INTO public.car_tip_cer VALUES (542, 'Aspecto similar a las IPA tradicionales, abarcando toda la gama de cobre, pudiendo tener tintes anaranjados.', 2, 9);
INSERT INTO public.car_tip_cer VALUES (543, '40 - 60', 6, 9);
INSERT INTO public.car_tip_cer VALUES (544, '5 - 7.5%', 10, 9);
INSERT INTO public.car_tip_cer VALUES (545, 'Aroma a lúpulo de moderado a fuerte (cítrico común). Aroma a malta de bajo a moderado. Ésteres frutados de nulo a moderado.', 1, 1);
INSERT INTO public.car_tip_cer VALUES (546, 'Color de dorado pálido a ámbar profundo. Espuma blanca con buena retención. Generalmente cristalina.', 2, 1);
INSERT INTO public.car_tip_cer VALUES (547, 'Sabor a lúpulo de moderado a alto (cítrico). Sabor a malta límpido que balancea al lúpulo. Acabado moderadamente seco.', 3, 1);
INSERT INTO public.car_tip_cer VALUES (548, 'Cuerpo medio-liviano a medio. Carbonatación de moderada a alta. Acabado suave.', 4, 1);
INSERT INTO public.car_tip_cer VALUES (549, 'Adaptación americana de las Pale Ales inglesas, con ingredientes nativos. Más claras y limpias que sus contrapartes inglesas.', 12, 1);
INSERT INTO public.car_tip_cer VALUES (550, 'Aromas complejos a malta (chocolate, caramelo), ésteres frutados (ciruelas, pasas) y fenoles especiados (clavo de olor).', 1, 7);
INSERT INTO public.car_tip_cer VALUES (551, 'Color de ámbar oscuro a cobre, con fondo rojizo. Cristalina. Espuma densa y cremosa.', 2, 7);
INSERT INTO public.car_tip_cer VALUES (552, 'Sabor rico y complejo a malta, con interacción de ésteres, alcoholes y fenoles. Balance hacia la malta. Acabado moderadamente seco.', 3, 7);
INSERT INTO public.car_tip_cer VALUES (553, 'Cuerpo medio-pleno. Carbonatación media-alta. Baja tibieza por alcohol.', 4, 7);
INSERT INTO public.car_tip_cer VALUES (554, '6.5 - 7%', 10, 7);
INSERT INTO public.car_tip_cer VALUES (555, 'Originarias de los monasterios en la Edad Media, resurgieron a mediados del siglo XIX.', 12, 7);
INSERT INTO public.car_tip_cer VALUES (556, 'Aroma complejo con ésteres frutados (pera, naranja, manzana), especias y alcohol. Carácter floral del lúpulo.', 1, 7);
INSERT INTO public.car_tip_cer VALUES (557, 'Color de amarillo a dorado medio. Buena claridad. Efervescente. Espuma blanca, densa y masiva.', 2, 7);
INSERT INTO public.car_tip_cer VALUES (558, 'Combinación de sabores frutados, especiados y alcohólicos, con suave carácter a malta. Amargor de medio a alto.', 3, 7);
INSERT INTO public.car_tip_cer VALUES (559, 'Altamente carbonatada. Cuerpo liviano a medio. Suave pero evidente tibieza por alcohol.', 4, 7);
INSERT INTO public.car_tip_cer VALUES (560, 'Desarrollada por Moortgat después de la SGM como respuesta a la popularidad de las Pilsner.', 12, 7); 


--
-- Data for Name: estilo_cerveza; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.estilo_cerveza VALUES (1, 'American Amber Ale', 'Una cerveza artesana americana, amber moderadamente fuerte con un sabor a malta de caramelo.');
INSERT INTO public.estilo_cerveza VALUES (2, 'American IPA', 'Versión americana de la IPA, menos maltosa y más lupulizada, a menudo con dry hopping.');
INSERT INTO public.estilo_cerveza VALUES (3, 'American Pale Ale', 'Adaptación americana de las Pale Ales inglesas, empleando ingredientes nativos.');
INSERT INTO public.estilo_cerveza VALUES (4, 'Belgian Dubbel', 'Una ale belga de color rojizo profundo, moderadamente fuerte, maltosa y compleja.');
INSERT INTO public.estilo_cerveza VALUES (5, 'Belgian Golden Strong Ale', 'Una ale belga dorada, compleja, efervescente y fuerte.');
INSERT INTO public.estilo_cerveza VALUES (6, 'Belgian Specialty Ale', 'Una amplia categoría de cervezas belgas que no se ajustan a otros estilos definidos.');
INSERT INTO public.estilo_cerveza VALUES (7, 'Pilsner', 'Una de las cervezas más comerciales, de sabor ligero pero intenso y fermentada con levadura de baja fermentación.');
INSERT INTO public.estilo_cerveza VALUES (8, 'Spezial', 'Un estilo de cerveza Lager alemana.');
INSERT INTO public.estilo_cerveza VALUES (9, 'Dortmunder', 'Un estilo de cerveza Lager alemana, de la ciudad de Dortmund.');
INSERT INTO public.estilo_cerveza VALUES (10, 'Schwarzbier', 'Cerveza negra alemana, de tipo Lager.');
INSERT INTO public.estilo_cerveza VALUES (11, 'Vienna Lager', 'Estilo de Lager de color ámbar rojizo, con un suave y sutil amargor de lúpulo.');
INSERT INTO public.estilo_cerveza VALUES (12, 'Bock', 'Lager alemana fuerte y maltosa.');
INSERT INTO public.estilo_cerveza VALUES (13, 'Pale Ale', 'Familia de cervezas ale de color claro, elaboradas con pequeñas proporciones de malta tostada.');
INSERT INTO public.estilo_cerveza VALUES (14, 'Dark Ale', 'Cervezas ale oscuras, como las Stouts y Porters.');
INSERT INTO public.estilo_cerveza VALUES (15, 'Weisse Beer', 'Cerveza de trigo alemana, clara y de baja graduación.');
INSERT INTO public.estilo_cerveza VALUES (16, 'Stout', 'Cerveza negra muy oscura, espesa y cremosa, con fuerte aroma a malta.');
INSERT INTO public.estilo_cerveza VALUES (17, 'Porter', 'Cerveza ale oscura, similar a la Stout pero menos potente.');
INSERT INTO public.estilo_cerveza VALUES (18, 'Cerveza de Abadía', 'Cerveza belga de sabor intenso, a menudo con fondo dulce.');
INSERT INTO public.estilo_cerveza VALUES (19, 'Trapense', 'Cerveza elaborada en monasterios trapenses, de alta fermentación.');
INSERT INTO public.estilo_cerveza VALUES (20, 'Ámbar Belga', 'Cerveza belga de tonos rojizos y sabor intenso.');
INSERT INTO public.estilo_cerveza VALUES (21, 'Flamenca', 'Estilo de cerveza ale belga.');
INSERT INTO public.estilo_cerveza VALUES (22, 'Barley Wine', 'Vino de cebada, cerveza muy alcohólica y con mucho cuerpo.');
INSERT INTO public.estilo_cerveza VALUES (23, 'Blonde Ale', 'Cerveza rubia de sabor ligero y cuerpo liviano.');
INSERT INTO public.estilo_cerveza VALUES (24, 'Bohemian Pilsener', 'Versión checa de la Pilsner, más maltosa y con un amargor más pronunciado.');
INSERT INTO public.estilo_cerveza VALUES (25, 'Dry Stout', 'Stout más seca y amarga que la versión dulce.');
INSERT INTO public.estilo_cerveza VALUES (26, 'Düsseldorf Altbier', 'Cerveza alemana de color cobre, fermentada como una ale pero madurada como una lager.');
INSERT INTO public.estilo_cerveza VALUES (27, 'English Pale Ale', 'Estilo tradicional inglés de Pale Ale, con más carácter a malta que las versiones americanas.');
INSERT INTO public.estilo_cerveza VALUES (28, 'Extra-Strong Bitter (ESB)', 'Una ale inglesa más fuerte y equilibrada que las bitter estándar.');
INSERT INTO public.estilo_cerveza VALUES (29, 'Fruit Lambic', 'Lambic a la que se le ha añadido fruta durante la fermentación.');
INSERT INTO public.estilo_cerveza VALUES (30, 'Imperial IPA', 'Una IPA más fuerte y lupulada que la American IPA estándar.');
INSERT INTO public.estilo_cerveza VALUES (31, 'Imperial Stout', 'Una Stout muy fuerte, oscura y compleja.');
INSERT INTO public.estilo_cerveza VALUES (32, 'India Pale Ale (IPA)', 'Cerveza pálida y espumosa con un alto nivel de alcohol y lúpulo.');
INSERT INTO public.estilo_cerveza VALUES (33, 'Irish Red Ale', 'Ale irlandesa de color rojizo, con un dulzor a malta de caramelo.');
INSERT INTO public.estilo_cerveza VALUES (34, 'Munich Helles', 'Lager alemana de color pálido, limpia y maltosa.');
INSERT INTO public.estilo_cerveza VALUES (35, 'Oktoberfest-Marzen', 'Lager alemana de color ámbar, rica en malta, tradicional del Oktoberfest.');
INSERT INTO public.estilo_cerveza VALUES (36, 'Red Ale', 'Ale de color rojo o ámbar, con un perfil de sabor maltoso.');
INSERT INTO public.estilo_cerveza VALUES (37, 'Spice, Herb or Vegetable Beer', 'Cerveza elaborada con especias, hierbas o vegetales para aportar sabor y aroma.');
INSERT INTO public.estilo_cerveza VALUES (38, 'Sweet Stout', 'Stout endulzada, a menudo con lactosa (Milk Stout).');
INSERT INTO public.estilo_cerveza VALUES (39, 'Weizen-Weissbier', 'Nombre alternativo para la cerveza de trigo alemana.');
INSERT INTO public.estilo_cerveza VALUES (40, 'Witbier', 'Cerveza de trigo belga, a menudo condimentada con cilantro y cáscara de naranja.');
INSERT INTO public.estilo_cerveza VALUES (41, 'Saison', 'Cerveza de granja belga, refrescante, afrutada y especiada.'); 

--
-- Data for Name: tipo_estilo_cerveza; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_estilo_cerveza VALUES (1, 'Ale - American Amber Ale', 'Estilo American Amber Ale de tipo Ale.', 1, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (2, 'IPA - American IPA', 'Estilo American IPA de tipo IPA.', 2, 9);
INSERT INTO public.tipo_estilo_cerveza VALUES (3, 'Ale - American Pale Ale', 'Estilo American Pale Ale de tipo Ale.', 3, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (4, 'Belgian Ale - Belgian Dubbel', 'Estilo Belgian Dubbel de tipo Belgian Ale.', 4, 7);
INSERT INTO public.tipo_estilo_cerveza VALUES (5, 'Belgian Ale - Belgian Golden Strong Ale', 'Estilo Belgian Golden Strong Ale de tipo Belgian Ale.', 5, 7);
INSERT INTO public.tipo_estilo_cerveza VALUES (6, 'Belgian Ale - Belgian Specialty Ale', 'Estilo Belgian Specialty Ale de tipo Belgian Ale.', 6, 7);
INSERT INTO public.tipo_estilo_cerveza VALUES (7, 'Lager - Pilsner', 'Estilo Pilsner de tipo Lager.', 7, 2);
INSERT INTO public.tipo_estilo_cerveza VALUES (8, 'Lager - Spezial', 'Estilo Spezial de tipo Lager.', 8, 2);
INSERT INTO public.tipo_estilo_cerveza VALUES (9, 'Lager - Dortmunder', 'Estilo Dortmunder de tipo Lager.', 9, 2);
INSERT INTO public.tipo_estilo_cerveza VALUES (10, 'Lager - Schwarzbier', 'Estilo Schwarzbier de tipo Lager.', 10, 2);
INSERT INTO public.tipo_estilo_cerveza VALUES (11, 'Lager - Vienna Lager', 'Estilo Vienna Lager de tipo Lager.', 11, 2);
INSERT INTO public.tipo_estilo_cerveza VALUES (12, 'Bock - Bock', 'Estilo Bock de tipo Bock.', 12, 4);
INSERT INTO public.tipo_estilo_cerveza VALUES (13, 'Ale - Pale Ale', 'Estilo Pale Ale de tipo Ale.', 13, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (14, 'Ale - Dark Ale', 'Estilo Dark Ale de tipo Ale.', 14, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (15, 'Wheat Beer - Weisse Beer', 'Estilo Weisse Beer de tipo Wheat Beer.', 15, 3);
INSERT INTO public.tipo_estilo_cerveza VALUES (16, 'Stout - Stout', 'Estilo Stout de tipo Stout.', 16, 5);
INSERT INTO public.tipo_estilo_cerveza VALUES (17, 'Porter - Porter', 'Estilo Porter de tipo Porter.', 17, 6);
INSERT INTO public.tipo_estilo_cerveza VALUES (18, 'Belgian Ale - Cerveza de Abadía', 'Estilo Cerveza de Abadía de tipo Belgian Ale.', 18, 7);
INSERT INTO public.tipo_estilo_cerveza VALUES (19, 'Belgian Ale - Trapense', 'Estilo Trapense de tipo Belgian Ale.', 19, 7);
INSERT INTO public.tipo_estilo_cerveza VALUES (20, 'Belgian Ale - Ámbar Belga', 'Estilo Ámbar Belga de tipo Belgian Ale.', 20, 7);
INSERT INTO public.tipo_estilo_cerveza VALUES (21, 'Belgian Ale - Flamenca', 'Estilo Flamenca de tipo Belgian Ale.', 21, 7);
INSERT INTO public.tipo_estilo_cerveza VALUES (22, 'Ale - Barley Wine', 'Estilo Barley Wine de tipo Ale.', 22, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (23, 'Ale - Blonde Ale', 'Estilo Blonde Ale de tipo Ale.', 23, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (24, 'Lager - Bohemian Pilsener', 'Estilo Bohemian Pilsener de tipo Lager.', 24, 2);
INSERT INTO public.tipo_estilo_cerveza VALUES (25, 'Stout - Dry Stout', 'Estilo Dry Stout de tipo Stout.', 25, 5);
INSERT INTO public.tipo_estilo_cerveza VALUES (26, 'Ale - Düsseldorf Altbier', 'Estilo Düsseldorf Altbier de tipo Ale.', 26, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (27, 'Ale - English Pale Ale', 'Estilo English Pale Ale de tipo Ale.', 27, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (28, 'Ale - Extra-Strong Bitter (ESB)', 'Estilo Extra-Strong Bitter (ESB) de tipo Ale.', 28, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (29, 'Lambic - Fruit Lambic', 'Estilo Fruit Lambic de tipo Lambic.', 29, 8);
INSERT INTO public.tipo_estilo_cerveza VALUES (30, 'IPA - Imperial IPA', 'Estilo Imperial IPA de tipo IPA.', 30, 9);
INSERT INTO public.tipo_estilo_cerveza VALUES (31, 'Stout - Imperial Stout', 'Estilo Imperial Stout de tipo Stout.', 31, 5);
INSERT INTO public.tipo_estilo_cerveza VALUES (32, 'IPA - India Pale Ale (IPA)', 'Estilo India Pale Ale (IPA) de tipo IPA.', 32, 9);
INSERT INTO public.tipo_estilo_cerveza VALUES (33, 'Ale - Irish Red Ale', 'Estilo Irish Red Ale de tipo Ale.', 33, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (34, 'Lager - Munich Helles', 'Estilo Munich Helles de tipo Lager.', 34, 2);
INSERT INTO public.tipo_estilo_cerveza VALUES (35, 'Lager - Oktoberfest-Marzen', 'Estilo Oktoberfest-Marzen de tipo Lager.', 35, 2);
INSERT INTO public.tipo_estilo_cerveza VALUES (36, 'Ale - Red Ale', 'Estilo Red Ale de tipo Ale.', 36, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (37, 'Ale - Spice, Herb or Vegetable Beer', 'Estilo Spice, Herb or Vegetable Beer de tipo Ale.', 37, 1);
INSERT INTO public.tipo_estilo_cerveza VALUES (38, 'Stout - Sweet Stout', 'Estilo Sweet Stout de tipo Stout.', 38, 5);
INSERT INTO public.tipo_estilo_cerveza VALUES (39, 'Wheat Beer - Weizen-Weissbier', 'Estilo Weizen-Weissbier de tipo Wheat Beer.', 39, 3);
INSERT INTO public.tipo_estilo_cerveza VALUES (40, 'Wheat Beer - Witbier', 'Estilo Witbier de tipo Wheat Beer.', 40, 3);
INSERT INTO public.tipo_estilo_cerveza VALUES (41, 'Belgian Ale - Saison', 'Estilo Saison de tipo Belgian Ale.', 41, 7);

--
-- Data for Name: cerveza; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cerveza VALUES (1, 'Destilo', 'Primera cerveza genuina ultra Premium tipo Ale hecha en Venezuela.', 5.0, 1);
INSERT INTO public.cerveza VALUES (2, 'Dos Leones Latin American Pale Ale', 'Suavemente lupulada con tonos cítricos.', 6.0, 2);
INSERT INTO public.cerveza VALUES (3, 'Benitz Pale Ale', 'Cerveza Pale Ale de producción 100% artesanal, con balance entre el dulce de las maltas y el suave amargor de los lúpulos.', 5.5, 3);
INSERT INTO public.cerveza VALUES (4, 'Mito Brewhouse Candileja de Abadía', 'Inspirada en las técnicas y procesos utilizados por los monjes en monasterios y abadías trapenses.', 7.0, 4);
INSERT INTO public.cerveza VALUES (5, 'Cervecería Lago Ángel o Demonio', 'De un dorado y una espuma blanca y fina, va indicando su intensidad de aromas y sabores.', 8.5, 5);
INSERT INTO public.cerveza VALUES (6, 'Barricas Saison Belga', 'Cerveza de temporada, afrutada con reminiscencias a especies.', 6.5, 41);
INSERT INTO public.cerveza VALUES (7, 'Aldarra Mantuana', 'Caracterizada por una mezcla de cereales, maltas y lúpulos americanos.', 4.8, 23);
INSERT INTO public.cerveza VALUES (8, 'Pilsner Urquell', 'La primera cerveza pilsner del mundo, originaria de la República Checa.', 4.4, 7);
INSERT INTO public.cerveza VALUES (9, 'Spezial Rauchbier', 'Una lager ahumada de Bamberg, Alemania.', 4.8, 8);
INSERT INTO public.cerveza VALUES (10, 'Dortmunder Gold', 'Lager clásica de Dortmund, bien balanceada.', 5.0, 9);
INSERT INTO public.cerveza VALUES (11, 'Köstritzer Schwarzbier', 'Una de las Schwarzbier más conocidas de Alemania.', 4.8, 10);
INSERT INTO public.cerveza VALUES (12, 'Ottakringer Vienna Lager', 'Ejemplo clásico del estilo Vienna.', 5.2, 11);
INSERT INTO public.cerveza VALUES (13, 'Paulaner Salvator', 'Un Doppelbock clásico, rico y maltoso.', 7.9, 12);
INSERT INTO public.cerveza VALUES (14, 'Sierra Nevada Pale Ale', 'Un ícono de la revolución de la cerveza artesanal americana.', 5.6, 13);
INSERT INTO public.cerveza VALUES (15, 'Anchor Porter', 'Un porter robusto y clásico americano.', 5.6, 17);
INSERT INTO public.cerveza VALUES (16, 'Weihenstephaner Hefeweissbier', 'Un referente mundial para las cervezas de trigo alemanas.', 5.4, 15);
INSERT INTO public.cerveza VALUES (17, 'Guinness Draught', 'La stout más famosa del mundo.', 4.2, 16);
INSERT INTO public.cerveza VALUES (18, 'Chimay Blue (Grande Réserve)', 'Una strong dark ale trapense, compleja y potente.', 9.0, 19);
INSERT INTO public.cerveza VALUES (19, 'Duvel', 'El referente del estilo Belgian Golden Strong Ale.', 8.5, 5);
INSERT INTO public.cerveza VALUES (20, 'Orval', 'Una cerveza trapense única con un carácter distintivo de Brettanomyces.', 6.2, 6);
INSERT INTO public.cerveza VALUES (21, 'Fuller''s London Porter', 'Un porter inglés clásico, suave y complejo.', 5.4, 17);
INSERT INTO public.cerveza VALUES (22, 'La Chouffe', 'Una Belgian Strong Pale Ale con notas especiadas y afrutadas.', 8.0, 7);
INSERT INTO public.cerveza VALUES (23, 'Thomas Hardy''s Ale', 'Un Barley Wine inglés histórico, muy fuerte y complejo.', 11.7, 22);
INSERT INTO public.cerveza VALUES (24, 'Hoegaarden Witbier', 'La witbier belga más reconocida internacionalmente.', 4.9, 40);
INSERT INTO public.cerveza VALUES (25, 'Pilsner Checa Artesanal', 'Ejemplo del estilo Bohemian Pilsener.', 5.0, 24);
INSERT INTO public.cerveza VALUES (26, 'Uerige Alt', 'Ejemplo clásico del estilo Düsseldorf Altbier.', 4.7, 26);
INSERT INTO public.cerveza VALUES (27, 'Fuller''s ESB', 'El ejemplo que definió el estilo Extra-Strong Bitter.', 5.9, 28);
INSERT INTO public.cerveza VALUES (28, 'Lindemans Kriek', 'Un lambic de cereza clásico de Bélgica.', 3.5, 29);
INSERT INTO public.cerveza VALUES (29, 'Pliny the Elder', 'Una de las Imperial IPAs más famosas y buscadas.', 8.0, 30);
INSERT INTO public.cerveza VALUES (30, 'North Coast Old Rasputin', 'Una aclamada Imperial Stout rusa.', 9.0, 31);
INSERT INTO public.cerveza VALUES (31, 'Bell''s Two Hearted Ale', 'Una IPA americana icónica, lupulada y balanceada.', 7.0, 32);
INSERT INTO public.cerveza VALUES (32, 'Smithwick''s Red Ale', 'Una de las Irish Red Ales más populares.', 4.5, 33);
INSERT INTO public.cerveza VALUES (33, 'Augustiner-Bräu Helles', 'Un clásico Munich Helles, suave y refrescante.', 5.2, 34);
INSERT INTO public.cerveza VALUES (34, 'Spaten Oktoberfest', 'Una cerveza Marzen tradicional para el Oktoberfest de Munich.', 5.9, 35);
INSERT INTO public.cerveza VALUES (35, 'Dogfish Head Punkin Ale', 'Una popular cerveza de calabaza de temporada.', 7.0, 37);
INSERT INTO public.cerveza VALUES (36, 'Left Hand Milk Stout', 'Un ejemplo clásico de Sweet Stout, cremosa y dulce.', 6.0, 38);
INSERT INTO public.cerveza VALUES (37, 'Schneider Weisse Original', 'Un referente del estilo Weizen-Weissbier.', 5.4, 39);
INSERT INTO public.cerveza VALUES (38, 'Saison Dupont', 'Considerada el estándar de oro para el estilo Saison.', 6.5, 41);
INSERT INTO public.cerveza VALUES (39, 'Dark Ale Genérica', 'Una cerveza ale oscura genérica para representar el estilo.', 5.5, 14);
INSERT INTO public.cerveza VALUES (40, 'Cerveza de Abadía Genérica', 'Representante del estilo de Abadía.', 6.8, 18);
INSERT INTO public.cerveza VALUES (41, 'Ámbar Belga Genérica', 'Representante del estilo Ámbar Belga.', 6.5, 20);
INSERT INTO public.cerveza VALUES (42, 'Flamenca Ale Genérica', 'Representante del estilo Flamenca.', 6.0, 21);
INSERT INTO public.cerveza VALUES (43, 'English Pale Ale Genérica', 'Representante del estilo English Pale Ale.', 5.0, 27);
INSERT INTO public.cerveza VALUES (44, 'Red Ale Genérica', 'Representante del estilo Red Ale.', 5.2, 36);
INSERT INTO public.cerveza VALUES (45, 'The Murphy''s Irish Stout', 'Stout seca irlandesa, referente del estilo Dry Stout', 4.0, 25);


--
-- Data for Name: cerv_car; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cerv_car VALUES (573, 'Se posiciona como una cerveza ultra premium.', 11, 1);
INSERT INTO public.cerv_car VALUES (574, 'Suavemente lupulada con tonos cítricos.', 3, 2);
INSERT INTO public.cerv_car VALUES (575, 'Balance entre el sabor dulce de las maltas y el suave amargor de los lúpulos.', 3, 3);
INSERT INTO public.cerv_car VALUES (576, 'Totalmente sin filtrar, por lo que posee un turbio natural ("Naturtrübes").', 2, 3);
INSERT INTO public.cerv_car VALUES (577, 'Aroma intenso a caramelo, con rasgos de durazno y ciruela.', 1, 4);
INSERT INTO public.cerv_car VALUES (578, 'Cuerpo denso y resplandeciente color ámbar.', 2, 4);
INSERT INTO public.cerv_car VALUES (579, 'Dorado intenso y una espuma blanca y fina.', 2, 5);
INSERT INTO public.cerv_car VALUES (580, 'Intensidad de aromas y sabores.', 1, 5);
INSERT INTO public.cerv_car VALUES (581, 'Afrutada con reminiscencias a especies.', 3, 6);
INSERT INTO public.cerv_car VALUES (582, 'Aroma que recuerda las frutas tropicales.', 1, 7);
INSERT INTO public.cerv_car VALUES (583, 'Sabor ligero y cuerpo liviano.', 3, 7);

--
-- Data for Name: presentacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.presentacion VALUES (4, 'Mito Candileja', 330.00, 'Botella de Vidrio', 'cerveza-polar_pLdZjYs.png', 2.90, 24.00, 6.50, 4);
INSERT INTO public.presentacion VALUES (9, 'Candileja 500ml', 500.00, 'Botella de Vidrio', 'cerveza-solera_kriek_mQ2MMu9.jpg', 3.40, 25.00, 6.80, 4);
INSERT INTO public.presentacion VALUES (2, 'Dos Leones', 330.00, 'Botella de Vidrio', 'corona combo.png', 2.80, 22.00, 6.00, 2);
INSERT INTO public.presentacion VALUES (6, 'Barricas Saison', 750.00, 'Botella de Vidrio con Corcho', 'collection-title-escerveza-1-43248638099783.jpg.webp', 5.50, 29.00, 8.00, 6);
INSERT INTO public.presentacion VALUES (3, 'Benitz', 355.00, 'Botella de Vidrio', '942dc9d6-034e-4632-9a79-f48febf55596_nube-220582656a0a30e3bf16161669860019-480-0.jpg', 3.00, 23.00, 6.20, 3);
INSERT INTO public.presentacion VALUES (8, 'Estilo Lata', 330.00, 'Lata de Aluminio', '1656110108632-8712000017941.png', 2.40, 11.50, 6.00, 1);
INSERT INTO public.presentacion VALUES (10, 'Benitz Pack x6', 1980.00, 'Pack de 6 Botellas', 'collection-title-escerveza-1-43248638099783.jpg.webp', 16.50, 24.00, 18.00, 3);
INSERT INTO public.presentacion VALUES (7, 'Aldarra Mantuana', 355.00, 'Lata de Aluminio', '1223128.png', 2.70, 12.20, 6.60, 7);
INSERT INTO public.presentacion VALUES (1, 'Estilo', 330.00, 'Botella de Vidrio', 'collection-title-escerveza-21707000741988.jpg.webp', 2.50, 22.00, 6.00, 1);
INSERT INTO public.presentacion VALUES (5, 'Lago A&D', 330.00, 'Botella de Vidrio', 'corona_combo.png', 3.10, 22.50, 6.00, 5);
INSERT INTO public.presentacion VALUES (11, 'Pilsner Urquell 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 1.80, 4.50, 4.40, 8);
INSERT INTO public.presentacion VALUES (12, 'Spezial Rauchbier 500ml', 500.00, 'Botella de Vidrio', 'placeholder.png', 2.20, 5.50, 4.80, 9);
INSERT INTO public.presentacion VALUES (13, 'Dortmunder Gold 330ml', 330.00, 'Lata de Aluminio', 'placeholder.png', 1.90, 4.80, 5.00, 10);
INSERT INTO public.presentacion VALUES (14, 'Köstritzer Schwarzbier 500ml', 500.00, 'Botella de Vidrio', 'placeholder.png', 2.10, 5.20, 4.80, 11);
INSERT INTO public.presentacion VALUES (15, 'Ottakringer Vienna Lager 500ml', 500.00, 'Lata de Aluminio', 'placeholder.png', 2.00, 5.00, 5.20, 12);
INSERT INTO public.presentacion VALUES (16, 'Paulaner Salvator 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 2.50, 6.00, 7.90, 13);
INSERT INTO public.presentacion VALUES (17, 'Sierra Nevada Pale Ale 355ml', 355.00, 'Botella de Vidrio', 'placeholder.png', 2.30, 5.80, 5.60, 14);
INSERT INTO public.presentacion VALUES (18, 'Anchor Porter 355ml', 355.00, 'Botella de Vidrio', 'placeholder.png', 2.40, 5.90, 5.60, 15);
INSERT INTO public.presentacion VALUES (19, 'Weihenstephaner Hefeweissbier 500ml', 500.00, 'Botella de Vidrio', 'placeholder.png', 2.60, 6.50, 5.40, 16);
INSERT INTO public.presentacion VALUES (20, 'Guinness Draught 440ml', 440.00, 'Lata de Aluminio con Nitrógeno', 'placeholder.png', 2.00, 5.00, 4.20, 17);
INSERT INTO public.presentacion VALUES (21, 'Chimay Blue 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 3.50, 8.00, 9.00, 18);
INSERT INTO public.presentacion VALUES (22, 'Duvel 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 3.20, 7.50, 8.50, 19);
INSERT INTO public.presentacion VALUES (23, 'Orval 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 3.30, 7.80, 6.20, 20);
INSERT INTO public.presentacion VALUES (24, 'Fuller''s London Porter 500ml', 500.00, 'Botella de Vidrio', 'placeholder.png', 2.80, 6.80, 5.40, 21);
INSERT INTO public.presentacion VALUES (25, 'La Chouffe 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 3.10, 7.20, 8.00, 22);
INSERT INTO public.presentacion VALUES (26, 'Thomas Hardy''s Ale 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 4.50, 10.00, 11.70, 23);
INSERT INTO public.presentacion VALUES (27, 'Hoegaarden Witbier 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 2.20, 5.50, 4.90, 24);
INSERT INTO public.presentacion VALUES (28, 'Pilsner Checa Artesanal 500ml', 500.00, 'Botella de Vidrio', 'placeholder.png', 2.30, 5.60, 5.00, 25);
INSERT INTO public.presentacion VALUES (29, 'Uerige Alt 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 2.40, 5.80, 4.70, 26);
INSERT INTO public.presentacion VALUES (30, 'Fuller''s ESB 500ml', 500.00, 'Botella de Vidrio', 'placeholder.png', 2.90, 7.00, 5.90, 27);
INSERT INTO public.presentacion VALUES (31, 'Lindemans Kriek 250ml', 250.00, 'Botella de Vidrio', 'placeholder.png', 2.70, 6.50, 3.50, 28);
INSERT INTO public.presentacion VALUES (32, 'Pliny the Elder 510ml', 510.00, 'Botella de Vidrio', 'placeholder.png', 5.00, 12.00, 8.00, 29);
INSERT INTO public.presentacion VALUES (33, 'North Coast Old Rasputin 355ml', 355.00, 'Botella de Vidrio', 'placeholder.png', 3.80, 9.00, 9.00, 30);
INSERT INTO public.presentacion VALUES (34, 'Bell''s Two Hearted Ale 355ml', 355.00, 'Lata de Aluminio', 'placeholder.png', 2.90, 7.00, 7.00, 31);
INSERT INTO public.presentacion VALUES (35, 'Smithwick''s Red Ale 500ml', 500.00, 'Lata de Aluminio', 'placeholder.png', 2.10, 5.20, 4.50, 32);
INSERT INTO public.presentacion VALUES (36, 'Augustiner-Bräu Helles 500ml', 500.00, 'Botella de Vidrio', 'placeholder.png', 2.30, 5.60, 5.20, 33);
INSERT INTO public.presentacion VALUES (37, 'Spaten Oktoberfest 355ml', 355.00, 'Botella de Vidrio', 'placeholder.png', 2.20, 5.40, 5.90, 34);
INSERT INTO public.presentacion VALUES (38, 'Dogfish Head Punkin Ale 355ml', 355.00, 'Botella de Vidrio', 'placeholder.png', 3.00, 7.20, 7.00, 35);
INSERT INTO public.presentacion VALUES (39, 'Left Hand Milk Stout 355ml', 355.00, 'Lata de Aluminio con Nitrógeno', 'placeholder.png', 2.80, 6.80, 6.00, 36);
INSERT INTO public.presentacion VALUES (40, 'Schneider Weisse Original 500ml', 500.00, 'Botella de Vidrio', 'placeholder.png', 2.70, 6.60, 5.40, 37);
INSERT INTO public.presentacion VALUES (41, 'Saison Dupont 375ml', 375.00, 'Botella de Vidrio con Corcho', 'placeholder.png', 3.40, 8.00, 6.50, 38);
INSERT INTO public.presentacion VALUES (42, 'Dark Ale Genérica 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 1.90, 4.80, 5.50, 39);
INSERT INTO public.presentacion VALUES (43, 'Cerveza de Abadía Genérica 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 2.80, 6.80, 6.80, 40);
INSERT INTO public.presentacion VALUES (44, 'Ámbar Belga Genérica 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 2.60, 6.40, 6.50, 41);
INSERT INTO public.presentacion VALUES (45, 'Flamenca Ale Genérica 330ml', 330.00, 'Botella de Vidrio', 'placeholder.png', 2.50, 6.20, 6.00, 42);
INSERT INTO public.presentacion VALUES (46, 'English Pale Ale Genérica 500ml', 500.00, 'Lata de Aluminio', 'placeholder.png', 2.20, 5.30, 5.00, 43);
INSERT INTO public.presentacion VALUES (47, 'Red Ale Genérica 355ml', 355.00, 'Lata de Aluminio', 'placeholder.png', 2.00, 5.00, 5.20, 44);
INSERT INTO public.presentacion VALUES (48, 'The Murphy''s Irish Stout 500ml', 500.00, 'Lata de Aluminio con Nitrógeno', 'placeholder.png', 2.30, 5.50, 4.00, 45);


--
-- Data for Name: cargo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cargo VALUES (1, 'Gerente General', 'Responsable de la dirección general de la tienda y supervisión de todas las operaciones', 2500000);
INSERT INTO public.cargo VALUES (2, 'Supervisor de Ventas', 'Encargado de supervisar el equipo de ventas y garantizar el cumplimiento de objetivos', 1800000);
INSERT INTO public.cargo VALUES (3, 'Vendedor Senior', 'Vendedor con experiencia en productos cerveceros y atención al cliente especializada', 1200000);
INSERT INTO public.cargo VALUES (4, 'Vendedor Junior', 'Personal de ventas de nivel inicial con conocimientos básicos de productos', 900000);
INSERT INTO public.cargo VALUES (5, 'Almacenista', 'Responsable del manejo de inventario, recepción y despacho de mercancía', 1000000);
INSERT INTO public.cargo VALUES (6, 'Cajero', 'Encargado del manejo de caja, cobros y atención directa al cliente en el punto de venta', 850000);
INSERT INTO public.cargo VALUES (7, 'Especialista en Cervezas', 'Experto en productos cerveceros, degustaciones y asesoría técnica a clientes', 1500000);
INSERT INTO public.cargo VALUES (8, 'Coordinador de Logistica', 'Responsable de la coordinación de envíos, distribución y logística de productos', 1400000);
INSERT INTO public.cargo VALUES (9, 'Asistente Administrativo', 'Apoyo en tareas administrativas, documentación y gestión de archivos', 950000);
INSERT INTO public.cargo VALUES (10, 'Analista de Marketing', 'Responsable de estrategias de marketing, promociones y análisis de mercado', 1600000);




--
-- Data for Name: contacto_cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contacto_cliente VALUES (1, 'Rafael', 'Montenegro', 21);
INSERT INTO public.contacto_cliente VALUES (2, 'Alejandra', 'Villarroel', 22);
INSERT INTO public.contacto_cliente VALUES (3, 'Francisco', 'Delgado', 23);
INSERT INTO public.contacto_cliente VALUES (4, 'Isabella', 'Contreras', 24);
INSERT INTO public.contacto_cliente VALUES (5, 'Mauricio', 'Espinoza', 25);
INSERT INTO public.contacto_cliente VALUES (6, 'Daniela', 'Quintero', 26);
INSERT INTO public.contacto_cliente VALUES (7, 'Sebastian', 'Morales', 27);
INSERT INTO public.contacto_cliente VALUES (8, 'Valentina', 'Rojas', 28);
INSERT INTO public.contacto_cliente VALUES (9, 'Alejandro', 'Gutierrez', 29);
INSERT INTO public.contacto_cliente VALUES (10, 'Camila', 'Hernandez', 30);


--
-- Data for Name: contacto_proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contacto_proveedor VALUES (1, 'Miguel', 'Guerrero', 1);
INSERT INTO public.contacto_proveedor VALUES (2, 'Sofia', 'Castillo', 2);
INSERT INTO public.contacto_proveedor VALUES (3, 'Roberto', 'Mendez', 3);
INSERT INTO public.contacto_proveedor VALUES (4, 'Adriana', 'Paredes', 4);
INSERT INTO public.contacto_proveedor VALUES (5, 'Eduardo', 'Silva', 5);
INSERT INTO public.contacto_proveedor VALUES (6, 'Natalia', 'Moreno', 6);
INSERT INTO public.contacto_proveedor VALUES (7, 'Fernando', 'Rojas', 7);
INSERT INTO public.contacto_proveedor VALUES (8, 'Carolina', 'Vega', 8);
INSERT INTO public.contacto_proveedor VALUES (9, 'Alejandro', 'Torres', 9);
INSERT INTO public.contacto_proveedor VALUES (10, 'Mariana', 'Jimenez', 10);


--
-- Data for Name: correo_electronico; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.correo_electronico VALUES (1, 'carlos.ramirez@acaucab.com', NULL, NULL, NULL, 1, NULL);
INSERT INTO public.correo_electronico VALUES (2, 'maria.gonzalez@acaucab.com', NULL, NULL, NULL, 2, NULL);
INSERT INTO public.correo_electronico VALUES (3, 'jose.rodriguez@acaucab.com', NULL, NULL, NULL, 3, NULL);
INSERT INTO public.correo_electronico VALUES (4, 'ana.fernandez@acaucab.com', NULL, NULL, NULL, 4, NULL);
INSERT INTO public.correo_electronico VALUES (5, 'luis.torres@acaucab.com', NULL, NULL, NULL, 5, NULL);
INSERT INTO public.correo_electronico VALUES (6, 'carmen.herrera@acaucab.com', NULL, NULL, NULL, 6, NULL);
INSERT INTO public.correo_electronico VALUES (7, 'ricardo.mendoza@acaucab.com', NULL, NULL, NULL, 7, NULL);
INSERT INTO public.correo_electronico VALUES (8, 'patricia.suarez@acaucab.com', NULL, NULL, NULL, 8, NULL);
INSERT INTO public.correo_electronico VALUES (9, 'fernando.delgado@acaucab.com', NULL, NULL, NULL, 9, NULL);
INSERT INTO public.correo_electronico VALUES (10, 'gabriela.vega@acaucab.com', NULL, NULL, NULL, 10, NULL);
INSERT INTO public.correo_electronico VALUES (11, 'carlos.rodriguez.personal@gmail.com', 1, NULL, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (12, 'maria.gonzalez.cli@hotmail.com', 2, NULL, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (13, 'jose.fernandez.cliente@yahoo.com', 3, NULL, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (14, 'ana.sanchez.personal@gmail.com', 4, NULL, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (15, 'luis.martinez.cli@outlook.com', 5, NULL, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (16, 'contacto.empresa1@negocio.com', NULL, 1, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (17, 'representante.corp2@empresa.com', NULL, 2, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (18, 'gerente.comercial3@corporativo.com', NULL, 3, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (19, 'director.ventas4@negocio.com', NULL, 4, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (20, 'coordinador.compras5@empresa.com', NULL, 5, NULL, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (21, 'ventas@maltasandinas.com', NULL, NULL, NULL, NULL, 1);
INSERT INTO public.correo_electronico VALUES (22, 'comercial@lupuloscaribe.com', NULL, NULL, NULL, NULL, 2);
INSERT INTO public.correo_electronico VALUES (23, 'info@levadurasgourmet.com', NULL, NULL, NULL, NULL, 3);
INSERT INTO public.correo_electronico VALUES (24, 'pedidos@envasespremium.com', NULL, NULL, NULL, NULL, 4);
INSERT INTO public.correo_electronico VALUES (25, 'soporte@beertech.com', NULL, NULL, NULL, NULL, 5);
INSERT INTO public.correo_electronico VALUES (26, 'juan.perez@maltasandinas.com', NULL, NULL, 1, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (27, 'maria.lopez@lupuloscaribe.com', NULL, NULL, 2, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (28, 'carlos.silva@levadurasgourmet.com', NULL, NULL, 3, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (29, 'ana.martinez@envasespremium.com', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.correo_electronico VALUES (30, 'luis.garcia@beertech.com', NULL, NULL, 5, NULL, NULL);


--
-- Data for Name: cuenta_punto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cuenta_punto VALUES (1, 125.00, 1, 1);
INSERT INTO public.cuenta_punto VALUES (2, 156.00, 2, 2);
INSERT INTO public.cuenta_punto VALUES (3, 78.50, 3, 3);
INSERT INTO public.cuenta_punto VALUES (4, 234.00, 4, 4);
INSERT INTO public.cuenta_punto VALUES (5, 98.70, 5, 5);
INSERT INTO public.cuenta_punto VALUES (6, 156.80, 6, 6);
INSERT INTO public.cuenta_punto VALUES (7, 201.50, 7, 7);
INSERT INTO public.cuenta_punto VALUES (8, 87.60, 8, 8);
INSERT INTO public.cuenta_punto VALUES (9, 167.50, 9, 9);
INSERT INTO public.cuenta_punto VALUES (10, 134.80, 10, 10);
INSERT INTO public.cuenta_punto VALUES (11, 189.20, 11, 11);
INSERT INTO public.cuenta_punto VALUES (12, 145.60, 12, 12);
INSERT INTO public.cuenta_punto VALUES (13, 198.70, 13, 13);
INSERT INTO public.cuenta_punto VALUES (14, 123.40, 14, 14);
INSERT INTO public.cuenta_punto VALUES (15, 167.80, 15, 15);


--
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.departamento VALUES (1, 'Ventas', 'Departamento encargado de la comercialización y venta directa de productos cerveceros');
INSERT INTO public.departamento VALUES (2, 'Administracion', 'Área administrativa responsable de la gestión financiera, contable y de recursos humanos');
INSERT INTO public.departamento VALUES (3, 'Almacen', 'Departamento de gestión de inventario, almacenamiento y control de stock');
INSERT INTO public.departamento VALUES (4, 'Marketing', 'Área de mercadeo, promociones, publicidad y estrategias comerciales');
INSERT INTO public.departamento VALUES (5, 'Logistica', 'Departamento de distribución, transporte y cadena de suministro');
INSERT INTO public.departamento VALUES (6, 'Atencion al Cliente', 'Servicio especializado en atención, soporte y satisfacción del cliente');
INSERT INTO public.departamento VALUES (7, 'Compras', 'Área de adquisiciones, negociación con proveedores y gestión de contratos');
INSERT INTO public.departamento VALUES (8, 'Control de Calidad', 'Departamento de verificación de calidad de productos y procesos');
INSERT INTO public.departamento VALUES (9, 'Tecnologia', 'Área de sistemas, tecnología de la información y comercio electrónico');
INSERT INTO public.departamento VALUES (10, 'Recursos Humanos', 'Gestión del talento humano, capacitación y desarrollo del personal');


--
-- Data for Name: dep_tie; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dep_tie VALUES (521, '2023-01-15', NULL, 1, 1);
INSERT INTO public.dep_tie VALUES (522, '2023-02-01', NULL, 2, 2);
INSERT INTO public.dep_tie VALUES (523, '2023-01-20', NULL, 3, 3);
INSERT INTO public.dep_tie VALUES (524, '2023-03-01', NULL, 4, 4);
INSERT INTO public.dep_tie VALUES (525, '2023-01-10', NULL, 5, 5);
INSERT INTO public.dep_tie VALUES (526, '2023-02-15', NULL, 6, 6);
INSERT INTO public.dep_tie VALUES (527, '2023-01-25', NULL, 7, 7);
INSERT INTO public.dep_tie VALUES (528, '2023-02-20', NULL, 8, 8);
INSERT INTO public.dep_tie VALUES (529, '2023-03-10', NULL, 9, 9);
INSERT INTO public.dep_tie VALUES (530, '2023-01-30', NULL, 10, 10);


--
-- Data for Name: oferta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.oferta VALUES (1, 'Black Friday 2024', 'Descuento especial por Black Friday en toda la tienda', '2024-11-25', '2024-11-30', 25);
INSERT INTO public.oferta VALUES (2, 'Descuento Cerveza Artesanal', 'Promoción especial en cervezas artesanales venezolanas', '2024-01-15', '2024-02-15', 15);
INSERT INTO public.oferta VALUES (3, 'Oferta de Temporada', 'Descuento por cambio de temporada en productos seleccionados', '2024-03-01', '2024-03-31', 20);
INSERT INTO public.oferta VALUES (4, 'Combo Degustación', 'Descuento en pack de degustación de diferentes estilos', '2024-04-01', '2024-04-30', 30);
INSERT INTO public.oferta VALUES (5, 'Promoción Fin de Semana', 'Oferta especial para compras de fin de semana', '2024-05-01', '2024-05-31', 10);
INSERT INTO public.oferta VALUES (6, 'Descuento Cliente Frecuente', 'Beneficio para clientes con múltiples compras', '2024-06-01', '2024-06-30', 12);
INSERT INTO public.oferta VALUES (7, 'Oferta Verano', 'Promoción especial de temporada de verano', '2024-07-01', '2024-08-31', 18);
INSERT INTO public.oferta VALUES (8, 'Back to School', 'Descuento especial por regreso a clases', '2024-09-01', '2024-09-30', 8);
INSERT INTO public.oferta VALUES (9, 'Aniversario ACAUCAB', 'Celebración del aniversario de la asociación', '2024-10-01', '2024-10-15', 35);
INSERT INTO public.oferta VALUES (10, 'Navidad 2024', 'Oferta navideña en productos premium', '2024-12-01', '2024-12-31', 22);

--
-- Data for Name: pre_alm; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pre_alm VALUES (1, 8.50, 150, 1, 1, 1);
INSERT INTO public.pre_alm VALUES (2, 12.00, 80, 1, 2, 8);
INSERT INTO public.pre_alm VALUES (3, 15.50, 60, 2, 3, 2);
INSERT INTO public.pre_alm VALUES (4, 22.00, 45, 3, 4, 6);
INSERT INTO public.pre_alm VALUES (5, 6.75, 200, 4, 5, 7);
INSERT INTO public.pre_alm VALUES (6, 10.25, 120, 5, 6, 8);
INSERT INTO public.pre_alm VALUES (7, 18.75, 35, 6, 7, 4);
INSERT INTO public.pre_alm VALUES (8, 25.50, 25, 7, 8, 5);
INSERT INTO public.pre_alm VALUES (9, 30.00, 20, 8, 9, 6);
INSERT INTO public.pre_alm VALUES (10, 14.80, 90, 9, 10, 7);
INSERT INTO public.pre_alm VALUES (11, 4.50, 100, 1, NULL, 11);
INSERT INTO public.pre_alm VALUES (12, 5.50, 80, 2, NULL, 12);
INSERT INTO public.pre_alm VALUES (13, 4.80, 120, 3, NULL, 13);
INSERT INTO public.pre_alm VALUES (14, 5.20, 90, 4, NULL, 14);
INSERT INTO public.pre_alm VALUES (15, 5.00, 110, 5, NULL, 15);
INSERT INTO public.pre_alm VALUES (16, 6.00, 70, 6, NULL, 16);
INSERT INTO public.pre_alm VALUES (17, 5.80, 150, 7, NULL, 17);
INSERT INTO public.pre_alm VALUES (18, 5.90, 85, 8, NULL, 18);
INSERT INTO public.pre_alm VALUES (19, 6.50, 95, 9, NULL, 19);
INSERT INTO public.pre_alm VALUES (20, 5.00, 130, 10, NULL, 20);
INSERT INTO public.pre_alm VALUES (21, 8.00, 60, 1, NULL, 21);
INSERT INTO public.pre_alm VALUES (22, 7.50, 50, 2, NULL, 22);
INSERT INTO public.pre_alm VALUES (23, 7.80, 55, 3, NULL, 23);
INSERT INTO public.pre_alm VALUES (24, 6.80, 75, 4, NULL, 24);
INSERT INTO public.pre_alm VALUES (25, 7.20, 65, 5, NULL, 25);
INSERT INTO public.pre_alm VALUES (26, 10.00, 30, 6, NULL, 26);
INSERT INTO public.pre_alm VALUES (27, 5.50, 140, 7, NULL, 27);
INSERT INTO public.pre_alm VALUES (28, 5.60, 100, 8, NULL, 28);
INSERT INTO public.pre_alm VALUES (29, 5.80, 90, 9, NULL, 29);
INSERT INTO public.pre_alm VALUES (30, 7.00, 80, 10, NULL, 30);
INSERT INTO public.pre_alm VALUES (31, 6.50, 45, 1, NULL, 31);
INSERT INTO public.pre_alm VALUES (32, 12.00, 25, 2, NULL, 32);
INSERT INTO public.pre_alm VALUES (33, 9.00, 40, 3, NULL, 33);
INSERT INTO public.pre_alm VALUES (34, 7.00, 110, 4, NULL, 34);
INSERT INTO public.pre_alm VALUES (35, 5.20, 120, 5, NULL, 35);
INSERT INTO public.pre_alm VALUES (36, 5.60, 100, 6, NULL, 36);
INSERT INTO public.pre_alm VALUES (37, 5.40, 90, 7, NULL, 37);
INSERT INTO public.pre_alm VALUES (38, 7.20, 70, 8, NULL, 38);
INSERT INTO public.pre_alm VALUES (39, 6.80, 80, 9, NULL, 39);
INSERT INTO public.pre_alm VALUES (40, 6.60, 85, 10, NULL, 40);
INSERT INTO public.pre_alm VALUES (41, 8.00, 50, 1, NULL, 41);
INSERT INTO public.pre_alm VALUES (42, 4.80, 100, 2, NULL, 42);
INSERT INTO public.pre_alm VALUES (43, 6.80, 60, 3, NULL, 43);
INSERT INTO public.pre_alm VALUES (44, 6.40, 70, 4, NULL, 44);
INSERT INTO public.pre_alm VALUES (45, 6.20, 75, 5, NULL, 45);
INSERT INTO public.pre_alm VALUES (46, 5.30, 110, 6, NULL, 46);
INSERT INTO public.pre_alm VALUES (47, 5.00, 130, 7, NULL, 47);
INSERT INTO public.pre_alm VALUES (48, 5.50, 100, 8, NULL, 48);



--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuario VALUES (1, 'pbkdf2_sha256$216000$admin001$hashplaceholder1', NULL, true, 'admin001', '', '', 'admin@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (2, 'pbkdf2_sha256$216000$maria456$hashplaceholder2', NULL, false, 'gerente_maria', '', '', 'maria.gonzalez@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (3, 'pbkdf2_sha256$216000$jose789$hashplaceholder3', NULL, false, 'almacen_jose', '', '', 'jose.rodriguez@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (4, 'pbkdf2_sha256$216000$ana012$hashplaceholder4', NULL, false, 'marketing_ana', '', '', 'ana.fernandez@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (5, 'pbkdf2_sha256$216000$luis345$hashplaceholder5', NULL, false, 'logistica_luis', '', '', 'luis.torres@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (6, 'pbkdf2_sha256$216000$carmen678$hashplaceholder6', NULL, false, 'ventas_carmen', '', '', 'carmen.herrera@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (7, 'pbkdf2_sha256$216000$ricardo901$hashplaceholder7', NULL, false, 'vendedor_ricardo', '', '', 'ricardo.mendoza@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (8, 'pbkdf2_sha256$216000$patricia234$hashplaceholder8', NULL, false, 'cerveza_patricia', '', '', 'patricia.suarez@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (9, 'pbkdf2_sha256$216000$fernando567$hashplaceholder9', NULL, false, 'admin_fernando', '', '', 'fernando.delgado@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (10, 'pbkdf2_sha256$216000$gabriela890$hashplaceholder10', NULL, false, 'caja_gabriela', '', '', 'gabriela.vega@acaucab.com', true, true, '2025-06-20 03:07:55.427589-04', NULL, NULL);
INSERT INTO public.usuario VALUES (11, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_carlos', 'Carlos', 'Rodríguez', 'carlos.rodriguez@email.com', false, true, '2025-06-20 03:07:55.427589-04', 1, NULL);
INSERT INTO public.usuario VALUES (12, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_maria', 'María', 'González', 'maria.gonzalez@email.com', false, true, '2025-06-20 03:07:55.427589-04', 2, NULL);
INSERT INTO public.usuario VALUES (13, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_jose', 'José', 'Fernández', 'jose.fernandez@email.com', false, true, '2025-06-20 03:07:55.427589-04', 3, NULL);
INSERT INTO public.usuario VALUES (14, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_ana', 'Ana', 'Sánchez', 'ana.sanchez@email.com', false, true, '2025-06-20 03:07:55.427589-04', 4, NULL);
INSERT INTO public.usuario VALUES (15, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_luis', 'Luis', 'Ramírez', 'luis.ramirez@email.com', false, true, '2025-06-20 03:07:55.427589-04', 5, NULL);
INSERT INTO public.usuario VALUES (16, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_carmen', 'Carmen', 'Herrera', 'carmen.herrera@email.com', false, true, '2025-06-20 03:07:55.427589-04', 6, NULL);
INSERT INTO public.usuario VALUES (17, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_pedro', 'Pedro', 'Castillo', 'pedro.castillo@email.com', false, true, '2025-06-20 03:07:55.427589-04', 7, NULL);
INSERT INTO public.usuario VALUES (18, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_rosa', 'Rosa', 'Mendoza', 'rosa.mendoza@email.com', false, true, '2025-06-20 03:07:55.427589-04', 8, NULL);
INSERT INTO public.usuario VALUES (19, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_miguel', 'Miguel', 'Torres', 'miguel.torres@email.com', false, true, '2025-06-20 03:07:55.427589-04', 9, NULL);
INSERT INTO public.usuario VALUES (20, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_luisa', 'Luisa', 'Moreno', 'luisa.moreno@email.com', false, true, '2025-06-20 03:07:55.427589-04', 10, NULL);
INSERT INTO public.usuario VALUES (21, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_roberto', 'Roberto', 'Gutiérrez', 'roberto.gutierrez@email.com', false, true, '2025-06-20 03:07:55.427589-04', 11, NULL);
INSERT INTO public.usuario VALUES (22, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_elena', 'Elena', 'Navarro', 'elena.navarro@email.com', false, true, '2025-06-20 03:07:55.427589-04', 12, NULL);
INSERT INTO public.usuario VALUES (23, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_jorge', 'Jorge', 'Ramos', 'jorge.ramos@email.com', false, true, '2025-06-20 03:07:55.427589-04', 13, NULL);
INSERT INTO public.usuario VALUES (24, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_patricia', 'Patricia', 'Vega', 'patricia.vega@email.com', false, true, '2025-06-20 03:07:55.427589-04', 14, NULL);
INSERT INTO public.usuario VALUES (25, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_fernando', 'Fernando', 'Delgado', 'fernando.delgado@email.com', false, true, '2025-06-20 03:07:55.427589-04', 15, NULL);
INSERT INTO public.usuario VALUES (26, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_gabriela', 'Gabriela', 'Campos', 'gabriela.campos@email.com', false, true, '2025-06-20 03:07:55.427589-04', 16, NULL);
INSERT INTO public.usuario VALUES (27, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_andres', 'Andrés', 'Suárez', 'andres.suarez@email.com', false, true, '2025-06-20 03:07:55.427589-04', 17, NULL);
INSERT INTO public.usuario VALUES (28, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_beatriz', 'Beatriz', 'Flores', 'beatriz.flores@email.com', false, true, '2025-06-20 03:07:55.427589-04', 18, NULL);
INSERT INTO public.usuario VALUES (29, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_ricardo', 'Ricardo', 'Medina', 'ricardo.medina@email.com', false, true, '2025-06-20 03:07:55.427589-04', 19, NULL);
INSERT INTO public.usuario VALUES (30, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'cliente_maritza', 'Maritza', 'Ponce', 'maritza.ponce@email.com', false, true, '2025-06-20 03:07:55.427589-04', 20, NULL);
INSERT INTO public.usuario VALUES (31, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'prov_maltas', 'Ventas', 'Maltas Andinas', 'ventas@maltasandinas.com', false, true, '2025-06-20 03:07:55.427589-04', NULL, 1);
INSERT INTO public.usuario VALUES (32, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'prov_lupulos', 'Comercial', 'Lúpulos Caribe', 'comercial@lupuloscaribe.com', false, true, '2025-06-20 03:07:55.427589-04', NULL, 2);
INSERT INTO public.usuario VALUES (33, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'prov_levaduras', 'Info', 'Levaduras Gourmet', 'info@levadurasgourmet.com', false, true, '2025-06-20 03:07:55.427589-04', NULL, 3);
INSERT INTO public.usuario VALUES (34, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'prov_envases', 'Pedidos', 'Envases Premium', 'pedidos@envasespremium.com', false, true, '2025-06-20 03:07:55.427589-04', NULL, 4);
INSERT INTO public.usuario VALUES (35, 'pbkdf2_sha256$216000$pass123$d4fc03e0071047d1dabb99e35aceafc9c35484ac22728700df8021e228af7c22', NULL, false, 'prov_tecnologia', 'Soporte', 'BeerTech', 'soporte@beertech.com', false, true, '2025-06-20 03:07:55.427589-04', NULL, 5);


--
-- Data for Name: solicitud_compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.solicitud_compra VALUES (1, '2024-12-01 09:00:00-04', 12750.00, 1, 1, 1);
INSERT INTO public.solicitud_compra VALUES (2, '2024-12-01 10:30:00-04', 18600.00, 2, 2, 2);
INSERT INTO public.solicitud_compra VALUES (3, '2024-12-01 12:00:00-04', 15500.00, 3, 3, 3);
INSERT INTO public.solicitud_compra VALUES (4, '2024-12-01 14:15:00-04', 22000.00, 4, 4, 4);
INSERT INTO public.solicitud_compra VALUES (5, '2024-12-01 16:00:00-04', 20625.00, 5, 5, 5);
INSERT INTO public.solicitud_compra VALUES (6, '2024-12-02 08:45:00-04', 28125.00, 6, 6, 6);
INSERT INTO public.solicitud_compra VALUES (7, '2024-12-02 10:30:00-04', 13500.00, 7, 7, 7);
INSERT INTO public.solicitud_compra VALUES (8, '2024-12-02 13:00:00-04', 17000.00, 8, 1, 8);
INSERT INTO public.solicitud_compra VALUES (9, '2024-12-02 15:30:00-04', 25500.00, 9, 2, 9);
INSERT INTO public.solicitud_compra VALUES (10, '2024-12-03 09:15:00-04', 29600.00, 10, 3, 10);
INSERT INTO public.solicitud_compra VALUES (11, '2024-12-03 11:00:00-04', 19250.00, 1, 4, 11);
INSERT INTO public.solicitud_compra VALUES (12, '2024-12-03 13:45:00-04', 24750.00, 2, 5, 12);
INSERT INTO public.solicitud_compra VALUES (13, '2024-12-03 15:30:00-04', 31875.00, 3, 6, 13);
INSERT INTO public.solicitud_compra VALUES (14, '2024-12-04 08:00:00-04', 16200.00, 4, 7, 14);
INSERT INTO public.solicitud_compra VALUES (15, '2024-12-04 10:45:00-04', 27300.00, 5, 1, 15);


--
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.detalle_compra VALUES (1936, 150, 8.50, 1, 1);
INSERT INTO public.detalle_compra VALUES (1937, 100, 12.00, 8, 1);
INSERT INTO public.detalle_compra VALUES (1938, 50, 15.50, 9, 1);
INSERT INTO public.detalle_compra VALUES (1939, 120, 12.00, 2, 2);
INSERT INTO public.detalle_compra VALUES (1940, 80, 18.00, 5, 2);
INSERT INTO public.detalle_compra VALUES (1941, 60, 22.00, 6, 2);
INSERT INTO public.detalle_compra VALUES (1942, 100, 15.50, 3, 3);
INSERT INTO public.detalle_compra VALUES (1943, 75, 20.00, 4, 3);
INSERT INTO public.detalle_compra VALUES (1944, 50, 25.00, 8, 3);
INSERT INTO public.detalle_compra VALUES (1945, 80, 22.00, 4, 4);
INSERT INTO public.detalle_compra VALUES (1946, 60, 28.00, 6, 4);
INSERT INTO public.detalle_compra VALUES (1947, 40, 35.00, 8, 4);
INSERT INTO public.detalle_compra VALUES (1948, 90, 25.50, 5, 5);
INSERT INTO public.detalle_compra VALUES (1949, 70, 30.00, 2, 5);
INSERT INTO public.detalle_compra VALUES (1950, 45, 33.00, 1, 5);
INSERT INTO public.detalle_compra VALUES (1951, 60, 28.00, 6, 6);
INSERT INTO public.detalle_compra VALUES (1952, 50, 22.50, 4, 6);
INSERT INTO public.detalle_compra VALUES (1953, 40, 20.00, 5, 6);
INSERT INTO public.detalle_compra VALUES (1954, 200, 6.75, 7, 7);
INSERT INTO public.detalle_compra VALUES (1955, 100, 22.00, 7, 7);
INSERT INTO public.detalle_compra VALUES (1956, 80, 26.00, 1, 7);
INSERT INTO public.detalle_compra VALUES (1957, 100, 17.00, 8, 8);
INSERT INTO public.detalle_compra VALUES (1958, 75, 18.00, 3, 8);
INSERT INTO public.detalle_compra VALUES (1959, 60, 33.00, 9, 8);
INSERT INTO public.detalle_compra VALUES (1960, 85, 30.00, 1, 9);
INSERT INTO public.detalle_compra VALUES (1961, 65, 27.00, 2, 9);
INSERT INTO public.detalle_compra VALUES (1962, 50, 35.00, 6, 9);
INSERT INTO public.detalle_compra VALUES (1963, 120, 24.67, 2, 10);
INSERT INTO public.detalle_compra VALUES (1964, 90, 28.00, 8, 10);
INSERT INTO public.detalle_compra VALUES (1965, 70, 32.00, 3, 10);
INSERT INTO public.detalle_compra VALUES (1966, 70, 27.50, 4, 11);
INSERT INTO public.detalle_compra VALUES (1967, 55, 22.00, 6, 11);
INSERT INTO public.detalle_compra VALUES (1968, 45, 35.00, 5, 11);
INSERT INTO public.detalle_compra VALUES (1969, 65, 38.08, 7, 12);
INSERT INTO public.detalle_compra VALUES (1970, 50, 25.50, 5, 12);
INSERT INTO public.detalle_compra VALUES (1971, 40, 37.50, 8, 12);
INSERT INTO public.detalle_compra VALUES (1972, 45, 70.83, 7, 13);
INSERT INTO public.detalle_compra VALUES (1973, 35, 28.00, 6, 13);
INSERT INTO public.detalle_compra VALUES (1974, 30, 53.33, 6, 13);
INSERT INTO public.detalle_compra VALUES (1975, 180, 9.00, 7, 14);
INSERT INTO public.detalle_compra VALUES (1976, 90, 24.00, 5, 14);
INSERT INTO public.detalle_compra VALUES (1977, 60, 27.00, 3, 14);
INSERT INTO public.detalle_compra VALUES (1978, 78, 35.00, 1, 15);
INSERT INTO public.detalle_compra VALUES (1979, 65, 42.00, 8, 15);
INSERT INTO public.detalle_compra VALUES (1980, 52, 52.50, 9, 15);


--
-- Data for Name: eve_pro; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.eve_pro VALUES (1, 1, 5);
INSERT INTO public.eve_pro VALUES (2, 2, 5);
INSERT INTO public.eve_pro VALUES (3, 6, 1);
INSERT INTO public.eve_pro VALUES (4, 6, 2);
INSERT INTO public.eve_pro VALUES (5, 6, 4);
INSERT INTO public.eve_pro VALUES (6, 11, 1);
INSERT INTO public.eve_pro VALUES (7, 11, 13);
INSERT INTO public.eve_pro VALUES (8, 16, 1);
INSERT INTO public.eve_pro VALUES (9, 16, 2);
INSERT INTO public.eve_pro VALUES (10, 16, 3);
INSERT INTO public.eve_pro VALUES (11, 16, 4);
INSERT INTO public.eve_pro VALUES (12, 21, 1);


--
-- Data for Name: existencia_evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.existencia_evento VALUES (1, 50, 1, 5);
INSERT INTO public.existencia_evento VALUES (2, 30, 2, 9);
INSERT INTO public.existencia_evento VALUES (3, 500, 6, 1);
INSERT INTO public.existencia_evento VALUES (4, 400, 6, 2);
INSERT INTO public.existencia_evento VALUES (5, 1000, 6, 3);
INSERT INTO public.existencia_evento VALUES (6, 300, 11, 1);
INSERT INTO public.existencia_evento VALUES (7, 2000, 12, 1);
INSERT INTO public.existencia_evento VALUES (8, 500, 11, 4);
INSERT INTO public.existencia_evento VALUES (9, 3000, 10, 3);
INSERT INTO public.existencia_evento VALUES (10, 60, 4, 1);
INSERT INTO public.existencia_evento VALUES (11, 60, 5, 2);
INSERT INTO public.existencia_evento VALUES (12, 60, 3, 4);
INSERT INTO public.existencia_evento VALUES (13, 200, 7, 6);
INSERT INTO public.existencia_evento VALUES (14, 200, 8, 8);
INSERT INTO public.existencia_evento VALUES (15, 100, 9, 7);
INSERT INTO public.existencia_evento VALUES (16, 250, 3, 4);
INSERT INTO public.existencia_evento VALUES (17, 1500, 7, 3);
INSERT INTO public.existencia_evento VALUES (18, 700, 5, 8);
INSERT INTO public.existencia_evento VALUES (19, 600, 9, 1);
INSERT INTO public.existencia_evento VALUES (20, 1000, 2, 2);
INSERT INTO public.existencia_evento VALUES (21, 50, 1, 7);
INSERT INTO public.existencia_evento VALUES (22, 40, 12, 9);


--
-- Data for Name: venta_evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.venta_evento VALUES (1, '2025-06-15 10:22:00-04', 40.00, 1, 1);
INSERT INTO public.venta_evento VALUES (2, '2025-06-20 11:05:00-04', 30.00, 2, 6);
INSERT INTO public.venta_evento VALUES (3, '2025-07-01 14:00:00-04', 50.00, 3, 16);
INSERT INTO public.venta_evento VALUES (4, '2025-07-10 09:15:00-04', 25.00, 4, 21);
INSERT INTO public.venta_evento VALUES (5, '2025-07-12 18:30:00-04', 80.00, 5, 26);
INSERT INTO public.venta_evento VALUES (6, '2025-08-01 20:00:00-04', 24.00, 1, 31);
INSERT INTO public.venta_evento VALUES (7, '2025-08-05 12:45:00-04', 120.00, 6, 41);
INSERT INTO public.venta_evento VALUES (8, '2025-08-15 16:10:00-04', 35.00, 7, 46);
INSERT INTO public.venta_evento VALUES (9, '2025-09-01 11:50:00-04', 50.00, 8, 56);
INSERT INTO public.venta_evento VALUES (10, '2025-09-10 13:00:00-04', 45.00, 2, 61);
INSERT INTO public.venta_evento VALUES (11, '2025-09-22 19:20:00-04', 100.00, 9, 66);
INSERT INTO public.venta_evento VALUES (12, '2025-10-03 10:00:00-04', 60.00, 10, 71);
INSERT INTO public.venta_evento VALUES (13, '2025-10-15 15:05:00-04', 2000.00, 29, 76);
INSERT INTO public.venta_evento VALUES (14, '2025-11-01 17:40:00-04', 70.00, 11, 81);
INSERT INTO public.venta_evento VALUES (15, '2025-11-10 14:25:00-04', 55.00, 12, 86);
INSERT INTO public.venta_evento VALUES (16, '2025-12-01 09:00:00-04', 35.00, 5, 91);
INSERT INTO public.venta_evento VALUES (17, '2025-12-15 18:00:00-04', 30.00, 13, 106);
INSERT INTO public.venta_evento VALUES (18, '2026-01-05 11:11:00-04', 90.00, 14, 116);
INSERT INTO public.venta_evento VALUES (19, '2026-02-10 16:55:00-04', 1250.00, 25, 121);
INSERT INTO public.venta_evento VALUES (20, '2026-03-01 21:30:00-04', 75.00, 20, 125);


--
-- Data for Name: detalle_venta_evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.detalle_venta_evento VALUES (1, 2, 20.00, 1, 1);
INSERT INTO public.detalle_venta_evento VALUES (2, 1, 30.00, 3, 2);
INSERT INTO public.detalle_venta_evento VALUES (3, 2, 25.00, 6, 3);
INSERT INTO public.detalle_venta_evento VALUES (4, 1, 25.00, 4, 4);
INSERT INTO public.detalle_venta_evento VALUES (5, 4, 20.00, 8, 5);
INSERT INTO public.detalle_venta_evento VALUES (6, 2, 12.00, 9, 6);
INSERT INTO public.detalle_venta_evento VALUES (7, 4, 30.00, 3, 7);
INSERT INTO public.detalle_venta_evento VALUES (8, 2, 17.50, 11, 8);
INSERT INTO public.detalle_venta_evento VALUES (9, 2, 25.00, 12, 9);
INSERT INTO public.detalle_venta_evento VALUES (10, 1, 45.00, 18, 10);
INSERT INTO public.detalle_venta_evento VALUES (11, 2, 50.00, 17, 11);
INSERT INTO public.detalle_venta_evento VALUES (12, 2, 30.00, 1, 12);
INSERT INTO public.detalle_venta_evento VALUES (13, 1, 20.00, 16, 13);
INSERT INTO public.detalle_venta_evento VALUES (14, 2, 17.50, 1, 14);
INSERT INTO public.detalle_venta_evento VALUES (15, 2, 17.50, 2, 14);
INSERT INTO public.detalle_venta_evento VALUES (16, 1, 55.00, 17, 15);
INSERT INTO public.detalle_venta_evento VALUES (17, 1, 35.00, 17, 16);
INSERT INTO public.detalle_venta_evento VALUES (18, 1, 30.00, 3, 17);
INSERT INTO public.detalle_venta_evento VALUES (19, 3, 30.00, 1, 18);
INSERT INTO public.detalle_venta_evento VALUES (20, 5, 25.00, 17, 19);
INSERT INTO public.detalle_venta_evento VALUES (21, 1, 75.00, 18, 20);


--
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.inventario VALUES (1, 50,8.50, 1, 1, 1);
INSERT INTO public.inventario VALUES (2, 30, 12.00, 2, 2, 2);
INSERT INTO public.inventario VALUES (3, 40, 15.50, 3, 3, 3);
INSERT INTO public.inventario VALUES (4, 25, 22.00, 4, 4, 4);
INSERT INTO public.inventario VALUES (5, 35, 25.50, 5, 5, 5);
INSERT INTO public.inventario VALUES (6, 15, 18.75, 6, 6, 6);
INSERT INTO public.inventario VALUES (7, 45, 6.75, 7, 7, 7);
INSERT INTO public.inventario VALUES (8, 20, 30.00, 8, 8, 8);
INSERT INTO public.inventario VALUES (9, 30, 14.80, 9, 9, 9);
INSERT INTO public.inventario VALUES (10, 25, 33.00, 10, 10, 10);
INSERT INTO public.inventario VALUES (11, 100, 8.50, 1, NULL, 11);
INSERT INTO public.inventario VALUES (12, 80, 12.00, 2, NULL, 12);
INSERT INTO public.inventario VALUES (13, 120, 15.50, 3, NULL, 13);
INSERT INTO public.inventario VALUES (14, 90, 22.00, 4, NULL, 14);
INSERT INTO public.inventario VALUES (15, 110, 25.50, 5, NULL, 15);
INSERT INTO public.inventario VALUES (16, 70, 18.75, 6, NULL, 16);
INSERT INTO public.inventario VALUES (17, 150, 6.75, 7, NULL, 17);
INSERT INTO public.inventario VALUES (18, 85, 30.00, 8, NULL, 18);
INSERT INTO public.inventario VALUES (19, 95, 14.80, 9, NULL, 19);
INSERT INTO public.inventario VALUES (20, 130, 33.00, 10, NULL, 20);
INSERT INTO public.inventario VALUES (21, 60, 8.50, 1, NULL, 21);
INSERT INTO public.inventario VALUES (22, 50, 12.00, 2, NULL, 22);
INSERT INTO public.inventario VALUES (23, 55, 15.50, 3, NULL, 23);
INSERT INTO public.inventario VALUES (24, 75, 22.00, 4, NULL, 24);
INSERT INTO public.inventario VALUES (25, 65, 25.50, 5, NULL, 25);
INSERT INTO public.inventario VALUES (26, 30, 18.75, 6, NULL, 26);
INSERT INTO public.inventario VALUES (27, 140, 6.75, 7, NULL, 27);
INSERT INTO public.inventario VALUES (28, 100, 30.00, 8, NULL, 28);
INSERT INTO public.inventario VALUES (29, 90, 14.80, 9, NULL, 29);
INSERT INTO public.inventario VALUES (30, 80, 33.00, 10, NULL, 30);
INSERT INTO public.inventario VALUES (31, 45, 8.50, 1, NULL, 31);
INSERT INTO public.inventario VALUES (32, 25, 12.00, 2, NULL, 32);
INSERT INTO public.inventario VALUES (33, 40, 15.50, 3, NULL, 33);
INSERT INTO public.inventario VALUES (34, 110, 22.00, 4, NULL, 34);
INSERT INTO public.inventario VALUES (35, 120, 25.50, 5, NULL, 35);
INSERT INTO public.inventario VALUES (36, 100, 18.75, 6, NULL, 36);
INSERT INTO public.inventario VALUES (37, 90, 6.75, 7, NULL, 37);
INSERT INTO public.inventario VALUES (38, 70, 30.00, 8, NULL, 38);
INSERT INTO public.inventario VALUES (39, 80, 14.80, 9, NULL, 39);
INSERT INTO public.inventario VALUES (40, 85, 33.00, 10, NULL, 40);
INSERT INTO public.inventario VALUES (41, 50, 8.50, 1, NULL, 41);
INSERT INTO public.inventario VALUES (42, 100, 12.00, 2, NULL, 42);
INSERT INTO public.inventario VALUES (43, 60, 15.50, 3, NULL, 43);
INSERT INTO public.inventario VALUES (44, 70, 22.00, 4, NULL, 44);
INSERT INTO public.inventario VALUES (45, 75, 25.50, 5, NULL, 45);
INSERT INTO public.inventario VALUES (46, 110, 18.75, 6, NULL, 46);
INSERT INTO public.inventario VALUES (47, 130, 6.75, 7, NULL, 47);
INSERT INTO public.inventario VALUES (48, 100, 30.00, 8, NULL, 48); 

--
-- Data for Name: venta_fisica; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.venta_fisica VALUES (1, '2024-01-15', 125000, 1, 1, 1);
INSERT INTO public.venta_fisica VALUES (2, '2024-01-18', 156000, 2, 1, 2);
INSERT INTO public.venta_fisica VALUES (3, '2024-01-22', 78500, 3, 2, 3);
INSERT INTO public.venta_fisica VALUES (4, '2024-02-01', 234000, 4, 1, 4);
INSERT INTO public.venta_fisica VALUES (5, '2024-02-05', 98700, 5, 2, 5);
INSERT INTO public.venta_fisica VALUES (6, '2024-02-10', 156800, 6, 1, 6);
INSERT INTO public.venta_fisica VALUES (7, '2024-02-15', 201500, 7, 2, 7);
INSERT INTO public.venta_fisica VALUES (8, '2024-02-18', 87600, 8, 3, 8);
INSERT INTO public.venta_fisica VALUES (9, '2024-02-22', 167500, 9, 4, 9);
INSERT INTO public.venta_fisica VALUES (10, '2024-02-25', 134800, 10, 5, 10);
INSERT INTO public.venta_fisica VALUES (11, '2024-03-01', 189200, 11, 3, 1);
INSERT INTO public.venta_fisica VALUES (12, '2024-03-05', 145600, 12, 4, 2);
INSERT INTO public.venta_fisica VALUES (13, '2024-03-08', 198700, 13, 1, 3);
INSERT INTO public.venta_fisica VALUES (14, '2024-03-12', 123400, 14, 5, 4);
INSERT INTO public.venta_fisica VALUES (15, '2024-03-15', 167800, 15, 2, 5);
INSERT INTO public.venta_fisica VALUES (16, '2024-03-18', 189600, 16, 3, 6);
INSERT INTO public.venta_fisica VALUES (17, '2024-03-22', 145300, 17, 4, 7);
INSERT INTO public.venta_fisica VALUES (18, '2024-03-25', 178900, 18, 1, 8);
INSERT INTO public.venta_fisica VALUES (19, '2024-03-28', 156900, 19, 5, 9);
INSERT INTO public.venta_fisica VALUES (20, '2024-04-01', 134500, 20, 2, 10);
INSERT INTO public.venta_fisica VALUES (21, '2024-04-05', 456000, 21, 1, 1);
INSERT INTO public.venta_fisica VALUES (22, '2024-04-08', 678000, 22, 2, 2);
INSERT INTO public.venta_fisica VALUES (23, '2024-04-12', 345000, 23, 3, 3);
INSERT INTO public.venta_fisica VALUES (24, '2024-04-15', 789000, 24, 1, 4);
INSERT INTO public.venta_fisica VALUES (25, '2024-04-18', 234000, 25, 4, 5);
INSERT INTO public.venta_fisica VALUES (26, '2024-04-22', 567000, 26, 2, 6);
INSERT INTO public.venta_fisica VALUES (27, '2024-04-25', 432000, 27, 5, 7);
INSERT INTO public.venta_fisica VALUES (28, '2024-04-28', 654000, 28, 3, 8);
INSERT INTO public.venta_fisica VALUES (29, '2024-05-01', 298000, 29, 1, 9);
INSERT INTO public.venta_fisica VALUES (30, '2024-05-05', 543000, 30, 4, 10);
INSERT INTO public.venta_fisica VALUES (31, '2024-05-08', 376000, 31, 2, 1);
INSERT INTO public.venta_fisica VALUES (32, '2024-05-12', 687000, 32, 5, 2);
INSERT INTO public.venta_fisica VALUES (33, '2024-05-15', 234000, 33, 3, 3);
INSERT INTO public.venta_fisica VALUES (34, '2024-05-18', 456000, 34, 1, 4);
INSERT INTO public.venta_fisica VALUES (35, '2024-05-22', 567000, 35, 4, 5);
INSERT INTO public.venta_fisica VALUES (36, '2024-05-25', 345000, 36, 2, 6);
INSERT INTO public.venta_fisica VALUES (37, '2024-05-28', 432000, 37, 5, 7);
INSERT INTO public.venta_fisica VALUES (38, '2024-06-01', 654000, 38, 3, 8);
INSERT INTO public.venta_fisica VALUES (39, '2024-06-05', 376000, 39, 1, 9);
INSERT INTO public.venta_fisica VALUES (40, '2024-06-08', 543000, 40, 4, 10);


--
-- Data for Name: detalle_venta_fisica; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.detalle_venta_fisica VALUES (1, 2, 8.50, 1, 1);
INSERT INTO public.detalle_venta_fisica VALUES (2, 3, 12.00, 2, 1);
INSERT INTO public.detalle_venta_fisica VALUES (3, 1, 15.50, 3, 1);
INSERT INTO public.detalle_venta_fisica VALUES (4, 2, 22.00, 4, 1);
INSERT INTO public.detalle_venta_fisica VALUES (5, 1, 25.50, 5, 1);
INSERT INTO public.detalle_venta_fisica VALUES (6, 2, 18.75, 6, 1);
INSERT INTO public.detalle_venta_fisica VALUES (7, 3, 6.75, 7, 1);
INSERT INTO public.detalle_venta_fisica VALUES (8, 1, 30.00, 8, 1);
INSERT INTO public.detalle_venta_fisica VALUES (9, 2, 14.80, 9, 1);
INSERT INTO public.detalle_venta_fisica VALUES (10, 1, 33.00, 10, 1);
INSERT INTO public.detalle_venta_fisica VALUES (11, 1, 8.50, 1, 2);
INSERT INTO public.detalle_venta_fisica VALUES (12, 2, 12.00, 2, 2);
INSERT INTO public.detalle_venta_fisica VALUES (13, 2, 15.50, 3, 2);
INSERT INTO public.detalle_venta_fisica VALUES (14, 1, 22.00, 4, 2);
INSERT INTO public.detalle_venta_fisica VALUES (15, 3, 6.75, 7, 2);
INSERT INTO public.detalle_venta_fisica VALUES (16, 1, 18.75, 6, 2);
INSERT INTO public.detalle_venta_fisica VALUES (17, 2, 25.50, 5, 2);
INSERT INTO public.detalle_venta_fisica VALUES (18, 1, 14.80, 9, 2);
INSERT INTO public.detalle_venta_fisica VALUES (19, 2, 30.00, 8, 2);
INSERT INTO public.detalle_venta_fisica VALUES (20, 1, 26.00, 1, 2);

-- Inserts faltantes para DETALLE_VENTA_FISICA
-- Generados a partir de BD/Inserts.sql para completar la tabla
-- Se agregan los registros del 21 al 400 que faltan en BD/insert.sql

-- Registros del 21 al 30 (para las ventas físicas 3 a 10 - completando 10 productos por venta)
INSERT INTO public.detalle_venta_fisica VALUES (21, 3, 8.50, 1, 3);
INSERT INTO public.detalle_venta_fisica VALUES (22, 2, 12.00, 2, 3);
INSERT INTO public.detalle_venta_fisica VALUES (23, 2, 15.50, 3, 3);
INSERT INTO public.detalle_venta_fisica VALUES (24, 2, 22.00, 4, 3);
INSERT INTO public.detalle_venta_fisica VALUES (25, 1, 25.50, 5, 3);
INSERT INTO public.detalle_venta_fisica VALUES (26, 1, 18.75, 6, 3);
INSERT INTO public.detalle_venta_fisica VALUES (27, 4, 6.75, 7, 3);
INSERT INTO public.detalle_venta_fisica VALUES (28, 1, 30.00, 8, 3);
INSERT INTO public.detalle_venta_fisica VALUES (29, 2, 14.80, 9, 3);
INSERT INTO public.detalle_venta_fisica VALUES (30, 2, 33.00, 10, 3);

INSERT INTO public.detalle_venta_fisica VALUES (31, 2, 8.50, 1, 4);
INSERT INTO public.detalle_venta_fisica VALUES (32, 3, 12.00, 2, 4);
INSERT INTO public.detalle_venta_fisica VALUES (33, 1, 15.50, 3, 4);
INSERT INTO public.detalle_venta_fisica VALUES (34, 3, 22.00, 4, 4);
INSERT INTO public.detalle_venta_fisica VALUES (35, 2, 25.50, 5, 4);
INSERT INTO public.detalle_venta_fisica VALUES (36, 2, 18.75, 6, 4);
INSERT INTO public.detalle_venta_fisica VALUES (37, 2, 6.75, 7, 4);
INSERT INTO public.detalle_venta_fisica VALUES (38, 2, 30.00, 8, 4);
INSERT INTO public.detalle_venta_fisica VALUES (39, 1, 14.80, 9, 4);
INSERT INTO public.detalle_venta_fisica VALUES (40, 2, 33.00, 10, 4);

INSERT INTO public.detalle_venta_fisica VALUES (41, 2, 8.50, 1, 5);
INSERT INTO public.detalle_venta_fisica VALUES (42, 1, 12.00, 2, 5);
INSERT INTO public.detalle_venta_fisica VALUES (43, 3, 15.50, 3, 5);
INSERT INTO public.detalle_venta_fisica VALUES (44, 1, 22.00, 4, 5);
INSERT INTO public.detalle_venta_fisica VALUES (45, 1, 25.50, 5, 5);
INSERT INTO public.detalle_venta_fisica VALUES (46, 2, 18.75, 6, 5);
INSERT INTO public.detalle_venta_fisica VALUES (47, 3, 6.75, 7, 5);
INSERT INTO public.detalle_venta_fisica VALUES (48, 1, 30.00, 8, 5);
INSERT INTO public.detalle_venta_fisica VALUES (49, 2, 14.80, 9, 5);
INSERT INTO public.detalle_venta_fisica VALUES (50, 1, 26.00, 1, 5);

INSERT INTO public.detalle_venta_fisica VALUES (51, 3, 8.50, 1, 6);
INSERT INTO public.detalle_venta_fisica VALUES (52, 2, 12.00, 2, 6);
INSERT INTO public.detalle_venta_fisica VALUES (53, 2, 15.50, 3, 6);
INSERT INTO public.detalle_venta_fisica VALUES (54, 2, 22.00, 4, 6);
INSERT INTO public.detalle_venta_fisica VALUES (55, 2, 25.50, 5, 6);
INSERT INTO public.detalle_venta_fisica VALUES (56, 1, 18.75, 6, 6);
INSERT INTO public.detalle_venta_fisica VALUES (57, 2, 6.75, 7, 6);
INSERT INTO public.detalle_venta_fisica VALUES (58, 2, 30.00, 8, 6);
INSERT INTO public.detalle_venta_fisica VALUES (59, 2, 14.80, 9, 6);
INSERT INTO public.detalle_venta_fisica VALUES (60, 2, 33.00, 10, 6);

INSERT INTO public.detalle_venta_fisica VALUES (61, 4, 8.50, 1, 7);
INSERT INTO public.detalle_venta_fisica VALUES (62, 3, 12.00, 2, 7);
INSERT INTO public.detalle_venta_fisica VALUES (63, 2, 15.50, 3, 7);
INSERT INTO public.detalle_venta_fisica VALUES (64, 3, 22.00, 4, 7);
INSERT INTO public.detalle_venta_fisica VALUES (65, 2, 25.50, 5, 7);
INSERT INTO public.detalle_venta_fisica VALUES (66, 2, 18.75, 6, 7);
INSERT INTO public.detalle_venta_fisica VALUES (67, 3, 6.75, 7, 7);
INSERT INTO public.detalle_venta_fisica VALUES (68, 2, 30.00, 8, 7);
INSERT INTO public.detalle_venta_fisica VALUES (69, 2, 14.80, 9, 7);
INSERT INTO public.detalle_venta_fisica VALUES (70, 3, 33.00, 10, 7);

INSERT INTO public.detalle_venta_fisica VALUES (71, 2, 8.50, 1, 8);
INSERT INTO public.detalle_venta_fisica VALUES (72, 2, 12.00, 2, 8);
INSERT INTO public.detalle_venta_fisica VALUES (73, 3, 15.50, 3, 8);
INSERT INTO public.detalle_venta_fisica VALUES (74, 2, 22.00, 4, 8);
INSERT INTO public.detalle_venta_fisica VALUES (75, 1, 25.50, 5, 8);
INSERT INTO public.detalle_venta_fisica VALUES (76, 2, 18.75, 6, 8);
INSERT INTO public.detalle_venta_fisica VALUES (77, 2, 6.75, 7, 8);
INSERT INTO public.detalle_venta_fisica VALUES (78, 1, 30.00, 8, 8);
INSERT INTO public.detalle_venta_fisica VALUES (79, 3, 14.80, 9, 8);
INSERT INTO public.detalle_venta_fisica VALUES (80, 2, 26.00, 1, 8);

INSERT INTO public.detalle_venta_fisica VALUES (81, 1, 8.50, 1, 9);
INSERT INTO public.detalle_venta_fisica VALUES (82, 3, 12.00, 2, 9);
INSERT INTO public.detalle_venta_fisica VALUES (83, 2, 15.50, 3, 9);
INSERT INTO public.detalle_venta_fisica VALUES (84, 1, 22.00, 4, 9);
INSERT INTO public.detalle_venta_fisica VALUES (85, 2, 25.50, 5, 9);
INSERT INTO public.detalle_venta_fisica VALUES (86, 2, 18.75, 6, 9);
INSERT INTO public.detalle_venta_fisica VALUES (87, 2, 6.75, 7, 9);
INSERT INTO public.detalle_venta_fisica VALUES (88, 1, 30.00, 8, 9);
INSERT INTO public.detalle_venta_fisica VALUES (89, 2, 14.80, 9, 9);
INSERT INTO public.detalle_venta_fisica VALUES (90, 1, 33.00, 10, 9);

INSERT INTO public.detalle_venta_fisica VALUES (91, 3, 8.50, 1, 10);
INSERT INTO public.detalle_venta_fisica VALUES (92, 2, 12.00, 2, 10);
INSERT INTO public.detalle_venta_fisica VALUES (93, 3, 15.50, 3, 10);
INSERT INTO public.detalle_venta_fisica VALUES (94, 2, 22.00, 4, 10);
INSERT INTO public.detalle_venta_fisica VALUES (95, 2, 25.50, 5, 10);
INSERT INTO public.detalle_venta_fisica VALUES (96, 1, 18.75, 6, 10);
INSERT INTO public.detalle_venta_fisica VALUES (97, 3, 6.75, 7, 10);
INSERT INTO public.detalle_venta_fisica VALUES (98, 2, 30.00, 8, 10);
INSERT INTO public.detalle_venta_fisica VALUES (99, 2, 14.80, 9, 10);
INSERT INTO public.detalle_venta_fisica VALUES (100, 2, 33.00, 10, 10);

-- Ventas 11-20 (Clientes 11-20)
INSERT INTO public.detalle_venta_fisica VALUES (101, 2, 8.50, 1, 11);
INSERT INTO public.detalle_venta_fisica VALUES (102, 1, 12.00, 2, 11);
INSERT INTO public.detalle_venta_fisica VALUES (103, 2, 15.50, 3, 11);
INSERT INTO public.detalle_venta_fisica VALUES (104, 3, 22.00, 4, 11);
INSERT INTO public.detalle_venta_fisica VALUES (105, 1, 25.50, 5, 11);
INSERT INTO public.detalle_venta_fisica VALUES (106, 2, 18.75, 6, 11);
INSERT INTO public.detalle_venta_fisica VALUES (107, 2, 6.75, 7, 11);
INSERT INTO public.detalle_venta_fisica VALUES (108, 1, 30.00, 8, 11);
INSERT INTO public.detalle_venta_fisica VALUES (109, 3, 14.80, 9, 11);
INSERT INTO public.detalle_venta_fisica VALUES (110, 1, 33.00, 10, 11);

INSERT INTO public.detalle_venta_fisica VALUES (111, 1, 8.50, 1, 12);
INSERT INTO public.detalle_venta_fisica VALUES (112, 2, 12.00, 2, 12);
INSERT INTO public.detalle_venta_fisica VALUES (113, 1, 15.50, 3, 12);
INSERT INTO public.detalle_venta_fisica VALUES (114, 2, 22.00, 4, 12);
INSERT INTO public.detalle_venta_fisica VALUES (115, 3, 25.50, 5, 12);
INSERT INTO public.detalle_venta_fisica VALUES (116, 1, 18.75, 6, 12);
INSERT INTO public.detalle_venta_fisica VALUES (117, 2, 6.75, 7, 12);
INSERT INTO public.detalle_venta_fisica VALUES (118, 2, 30.00, 8, 12);
INSERT INTO public.detalle_venta_fisica VALUES (119, 1, 14.80, 9, 12);
INSERT INTO public.detalle_venta_fisica VALUES (120, 2, 33.00, 10, 12);

INSERT INTO public.detalle_venta_fisica VALUES (121, 3, 8.50, 1, 13);
INSERT INTO public.detalle_venta_fisica VALUES (122, 2, 12.00, 2, 13);
INSERT INTO public.detalle_venta_fisica VALUES (123, 1, 15.50, 3, 13);
INSERT INTO public.detalle_venta_fisica VALUES (124, 2, 22.00, 4, 13);
INSERT INTO public.detalle_venta_fisica VALUES (125, 1, 6.75, 5, 13);
INSERT INTO public.detalle_venta_fisica VALUES (126, 3, 10.25, 6, 13);
INSERT INTO public.detalle_venta_fisica VALUES (127, 2, 18.75, 7, 13);
INSERT INTO public.detalle_venta_fisica VALUES (128, 1, 25.50, 8, 13);
INSERT INTO public.detalle_venta_fisica VALUES (129, 2, 30.00, 9, 13);
INSERT INTO public.detalle_venta_fisica VALUES (130, 1, 14.80, 10, 13);

INSERT INTO public.detalle_venta_fisica VALUES (131, 1, 8.50, 1, 14);
INSERT INTO public.detalle_venta_fisica VALUES (132, 3, 12.00, 2, 14);
INSERT INTO public.detalle_venta_fisica VALUES (133, 2, 15.50, 3, 14);
INSERT INTO public.detalle_venta_fisica VALUES (134, 1, 22.00, 4, 14);
INSERT INTO public.detalle_venta_fisica VALUES (135, 2, 6.75, 5, 14);
INSERT INTO public.detalle_venta_fisica VALUES (136, 1, 10.25, 6, 14);
INSERT INTO public.detalle_venta_fisica VALUES (137, 2, 18.75, 7, 14);
INSERT INTO public.detalle_venta_fisica VALUES (138, 3, 25.50, 8, 14);
INSERT INTO public.detalle_venta_fisica VALUES (139, 1, 30.00, 9, 14);
INSERT INTO public.detalle_venta_fisica VALUES (140, 2, 14.80, 10, 14);

INSERT INTO public.detalle_venta_fisica VALUES (141, 2, 8.50, 1, 15);
INSERT INTO public.detalle_venta_fisica VALUES (142, 1, 12.00, 2, 15);
INSERT INTO public.detalle_venta_fisica VALUES (143, 3, 15.50, 3, 15);
INSERT INTO public.detalle_venta_fisica VALUES (144, 2, 22.00, 4, 15);
INSERT INTO public.detalle_venta_fisica VALUES (145, 1, 6.75, 5, 15);
INSERT INTO public.detalle_venta_fisica VALUES (146, 2, 10.25, 6, 15);
INSERT INTO public.detalle_venta_fisica VALUES (147, 1, 18.75, 7, 15);
INSERT INTO public.detalle_venta_fisica VALUES (148, 1, 25.50, 8, 15);
INSERT INTO public.detalle_venta_fisica VALUES (149, 3, 30.00, 9, 15);
INSERT INTO public.detalle_venta_fisica VALUES (150, 2, 14.80, 10, 15);

INSERT INTO public.detalle_venta_fisica VALUES (151, 3, 8.50, 1, 16);
INSERT INTO public.detalle_venta_fisica VALUES (152, 2, 12.00, 2, 16);
INSERT INTO public.detalle_venta_fisica VALUES (153, 1, 15.50, 3, 16);
INSERT INTO public.detalle_venta_fisica VALUES (154, 3, 22.00, 4, 16);
INSERT INTO public.detalle_venta_fisica VALUES (155, 2, 6.75, 5, 16);
INSERT INTO public.detalle_venta_fisica VALUES (156, 1, 10.25, 6, 16);
INSERT INTO public.detalle_venta_fisica VALUES (157, 2, 18.75, 7, 16);
INSERT INTO public.detalle_venta_fisica VALUES (158, 2, 25.50, 8, 16);
INSERT INTO public.detalle_venta_fisica VALUES (159, 1, 30.00, 9, 16);
INSERT INTO public.detalle_venta_fisica VALUES (160, 2, 14.80, 10, 16);

INSERT INTO public.detalle_venta_fisica VALUES (161, 1, 8.50, 1, 17);
INSERT INTO public.detalle_venta_fisica VALUES (162, 2, 12.00, 2, 17);
INSERT INTO public.detalle_venta_fisica VALUES (163, 2, 15.50, 3, 17);
INSERT INTO public.detalle_venta_fisica VALUES (164, 1, 22.00, 4, 17);
INSERT INTO public.detalle_venta_fisica VALUES (165, 3, 6.75, 5, 17);
INSERT INTO public.detalle_venta_fisica VALUES (166, 1, 10.25, 6, 17);
INSERT INTO public.detalle_venta_fisica VALUES (167, 3, 18.75, 7, 17);
INSERT INTO public.detalle_venta_fisica VALUES (168, 1, 25.50, 8, 17);
INSERT INTO public.detalle_venta_fisica VALUES (169, 2, 30.00, 9, 17);
INSERT INTO public.detalle_venta_fisica VALUES (170, 2, 14.80, 10, 17);

INSERT INTO public.detalle_venta_fisica VALUES (171, 2, 8.50, 1, 18);
INSERT INTO public.detalle_venta_fisica VALUES (172, 3, 12.00, 2, 18);
INSERT INTO public.detalle_venta_fisica VALUES (173, 1, 15.50, 3, 18);
INSERT INTO public.detalle_venta_fisica VALUES (174, 2, 22.00, 4, 18);
INSERT INTO public.detalle_venta_fisica VALUES (175, 1, 6.75, 5, 18);
INSERT INTO public.detalle_venta_fisica VALUES (176, 2, 10.25, 6, 18);
INSERT INTO public.detalle_venta_fisica VALUES (177, 1, 18.75, 7, 18);
INSERT INTO public.detalle_venta_fisica VALUES (178, 3, 25.50, 8, 18);
INSERT INTO public.detalle_venta_fisica VALUES (179, 2, 30.00, 9, 18);
INSERT INTO public.detalle_venta_fisica VALUES (180, 1, 14.80, 10, 18);

INSERT INTO public.detalle_venta_fisica VALUES (181, 3, 8.50, 1, 19);
INSERT INTO public.detalle_venta_fisica VALUES (182, 1, 12.00, 2, 19);
INSERT INTO public.detalle_venta_fisica VALUES (183, 2, 15.50, 3, 19);
INSERT INTO public.detalle_venta_fisica VALUES (184, 3, 22.00, 4, 19);
INSERT INTO public.detalle_venta_fisica VALUES (185, 2, 6.75, 5, 19);
INSERT INTO public.detalle_venta_fisica VALUES (186, 1, 10.25, 6, 19);
INSERT INTO public.detalle_venta_fisica VALUES (187, 2, 18.75, 7, 19);
INSERT INTO public.detalle_venta_fisica VALUES (188, 1, 25.50, 8, 19);
INSERT INTO public.detalle_venta_fisica VALUES (189, 1, 30.00, 9, 19);
INSERT INTO public.detalle_venta_fisica VALUES (190, 3, 14.80, 10, 19);

INSERT INTO public.detalle_venta_fisica VALUES (191, 1, 8.50, 1, 20);
INSERT INTO public.detalle_venta_fisica VALUES (192, 2, 12.00, 2, 20);
INSERT INTO public.detalle_venta_fisica VALUES (193, 3, 15.50, 3, 20);
INSERT INTO public.detalle_venta_fisica VALUES (194, 1, 22.00, 4, 20);
INSERT INTO public.detalle_venta_fisica VALUES (195, 2, 6.75, 5, 20);
INSERT INTO public.detalle_venta_fisica VALUES (196, 3, 10.25, 6, 20);
INSERT INTO public.detalle_venta_fisica VALUES (197, 1, 18.75, 7, 20);
INSERT INTO public.detalle_venta_fisica VALUES (198, 2, 25.50, 8, 20);
INSERT INTO public.detalle_venta_fisica VALUES (199, 2, 30.00, 9, 20);
INSERT INTO public.detalle_venta_fisica VALUES (200, 1, 14.80, 10, 20);

-- Ventas 21-30 (Clientes Jurídicos 21-30)
INSERT INTO public.detalle_venta_fisica VALUES (201, 5, 8.50, 1, 21);
INSERT INTO public.detalle_venta_fisica VALUES (202, 4, 12.00, 2, 21);
INSERT INTO public.detalle_venta_fisica VALUES (203, 3, 15.50, 3, 21);
INSERT INTO public.detalle_venta_fisica VALUES (204, 5, 22.00, 4, 21);
INSERT INTO public.detalle_venta_fisica VALUES (205, 3, 25.50, 5, 21);
INSERT INTO public.detalle_venta_fisica VALUES (206, 4, 18.75, 6, 21);
INSERT INTO public.detalle_venta_fisica VALUES (207, 5, 6.75, 7, 21);
INSERT INTO public.detalle_venta_fisica VALUES (208, 3, 30.00, 8, 21);
INSERT INTO public.detalle_venta_fisica VALUES (209, 4, 14.80, 9, 21);
INSERT INTO public.detalle_venta_fisica VALUES (210, 5, 33.00, 10, 21);

INSERT INTO public.detalle_venta_fisica VALUES (211, 6, 8.50, 1, 22);
INSERT INTO public.detalle_venta_fisica VALUES (212, 5, 12.00, 2, 22);
INSERT INTO public.detalle_venta_fisica VALUES (213, 4, 15.50, 3, 22);
INSERT INTO public.detalle_venta_fisica VALUES (214, 6, 22.00, 4, 22);
INSERT INTO public.detalle_venta_fisica VALUES (215, 4, 25.50, 5, 22);
INSERT INTO public.detalle_venta_fisica VALUES (216, 5, 18.75, 6, 22);
INSERT INTO public.detalle_venta_fisica VALUES (217, 6, 6.75, 7, 22);
INSERT INTO public.detalle_venta_fisica VALUES (218, 4, 30.00, 8, 22);
INSERT INTO public.detalle_venta_fisica VALUES (219, 5, 14.80, 9, 22);
INSERT INTO public.detalle_venta_fisica VALUES (220, 6, 33.00, 10, 22);

INSERT INTO public.detalle_venta_fisica VALUES (221, 3, 8.50, 1, 23);
INSERT INTO public.detalle_venta_fisica VALUES (222, 4, 12.00, 2, 23);
INSERT INTO public.detalle_venta_fisica VALUES (223, 5, 15.50, 3, 23);
INSERT INTO public.detalle_venta_fisica VALUES (224, 3, 22.00, 4, 23);
INSERT INTO public.detalle_venta_fisica VALUES (225, 4, 25.50, 5, 23);
INSERT INTO public.detalle_venta_fisica VALUES (226, 3, 18.75, 6, 23);
INSERT INTO public.detalle_venta_fisica VALUES (227, 5, 6.75, 7, 23);
INSERT INTO public.detalle_venta_fisica VALUES (228, 4, 30.00, 8, 23);
INSERT INTO public.detalle_venta_fisica VALUES (229, 3, 14.80, 9, 23);
INSERT INTO public.detalle_venta_fisica VALUES (230, 4, 33.00, 10, 23);

INSERT INTO public.detalle_venta_fisica VALUES (231, 7, 8.50, 1, 24);
INSERT INTO public.detalle_venta_fisica VALUES (232, 6, 12.00, 2, 24);
INSERT INTO public.detalle_venta_fisica VALUES (233, 5, 15.50, 3, 24);
INSERT INTO public.detalle_venta_fisica VALUES (234, 7, 22.00, 4, 24);
INSERT INTO public.detalle_venta_fisica VALUES (235, 5, 25.50, 5, 24);
INSERT INTO public.detalle_venta_fisica VALUES (236, 6, 18.75, 6, 24);
INSERT INTO public.detalle_venta_fisica VALUES (237, 7, 6.75, 7, 24);
INSERT INTO public.detalle_venta_fisica VALUES (238, 5, 30.00, 8, 24);
INSERT INTO public.detalle_venta_fisica VALUES (239, 6, 14.80, 9, 24);
INSERT INTO public.detalle_venta_fisica VALUES (240, 7, 33.00, 10, 24);

INSERT INTO public.detalle_venta_fisica VALUES (241, 4, 8.50, 1, 25);
INSERT INTO public.detalle_venta_fisica VALUES (242, 3, 12.00, 2, 25);
INSERT INTO public.detalle_venta_fisica VALUES (243, 4, 15.50, 3, 25);
INSERT INTO public.detalle_venta_fisica VALUES (244, 3, 22.00, 4, 25);
INSERT INTO public.detalle_venta_fisica VALUES (245, 4, 25.50, 5, 25);
INSERT INTO public.detalle_venta_fisica VALUES (246, 3, 18.75, 6, 25);
INSERT INTO public.detalle_venta_fisica VALUES (247, 4, 6.75, 7, 25);
INSERT INTO public.detalle_venta_fisica VALUES (248, 3, 30.00, 8, 25);
INSERT INTO public.detalle_venta_fisica VALUES (249, 4, 14.80, 9, 25);
INSERT INTO public.detalle_venta_fisica VALUES (250, 3, 33.00, 10, 25);

INSERT INTO public.detalle_venta_fisica VALUES (251, 5, 8.50, 1, 26);
INSERT INTO public.detalle_venta_fisica VALUES (252, 6, 12.00, 2, 26);
INSERT INTO public.detalle_venta_fisica VALUES (253, 4, 15.50, 3, 26);
INSERT INTO public.detalle_venta_fisica VALUES (254, 5, 22.00, 4, 26);
INSERT INTO public.detalle_venta_fisica VALUES (255, 6, 25.50, 5, 26);
INSERT INTO public.detalle_venta_fisica VALUES (256, 4, 18.75, 6, 26);
INSERT INTO public.detalle_venta_fisica VALUES (257, 5, 6.75, 7, 26);
INSERT INTO public.detalle_venta_fisica VALUES (258, 6, 30.00, 8, 26);
INSERT INTO public.detalle_venta_fisica VALUES (259, 4, 14.80, 9, 26);
INSERT INTO public.detalle_venta_fisica VALUES (260, 5, 33.00, 10, 26);

INSERT INTO public.detalle_venta_fisica VALUES (261, 4, 8.50, 1, 27);
INSERT INTO public.detalle_venta_fisica VALUES (262, 5, 12.00, 2, 27);
INSERT INTO public.detalle_venta_fisica VALUES (263, 3, 15.50, 3, 27);
INSERT INTO public.detalle_venta_fisica VALUES (264, 4, 22.00, 4, 27);
INSERT INTO public.detalle_venta_fisica VALUES (265, 5, 25.50, 5, 27);
INSERT INTO public.detalle_venta_fisica VALUES (266, 3, 18.75, 6, 27);
INSERT INTO public.detalle_venta_fisica VALUES (267, 4, 6.75, 7, 27);
INSERT INTO public.detalle_venta_fisica VALUES (268, 5, 30.00, 8, 27);
INSERT INTO public.detalle_venta_fisica VALUES (269, 3, 14.80, 9, 27);
INSERT INTO public.detalle_venta_fisica VALUES (270, 4, 33.00, 10, 27);

INSERT INTO public.detalle_venta_fisica VALUES (271, 6, 8.50, 1, 28);
INSERT INTO public.detalle_venta_fisica VALUES (272, 5, 12.00, 2, 28);
INSERT INTO public.detalle_venta_fisica VALUES (273, 6, 15.50, 3, 28);
INSERT INTO public.detalle_venta_fisica VALUES (274, 5, 22.00, 4, 28);
INSERT INTO public.detalle_venta_fisica VALUES (275, 6, 25.50, 5, 28);
INSERT INTO public.detalle_venta_fisica VALUES (276, 5, 18.75, 6, 28);
INSERT INTO public.detalle_venta_fisica VALUES (277, 6, 6.75, 7, 28);
INSERT INTO public.detalle_venta_fisica VALUES (278, 5, 30.00, 8, 28);
INSERT INTO public.detalle_venta_fisica VALUES (279, 6, 14.80, 9, 28);
INSERT INTO public.detalle_venta_fisica VALUES (280, 5, 33.00, 10, 28);

INSERT INTO public.detalle_venta_fisica VALUES (281, 3, 8.50, 1, 29);
INSERT INTO public.detalle_venta_fisica VALUES (282, 4, 12.00, 2, 29);
INSERT INTO public.detalle_venta_fisica VALUES (283, 3, 15.50, 3, 29);
INSERT INTO public.detalle_venta_fisica VALUES (284, 4, 22.00, 4, 29);
INSERT INTO public.detalle_venta_fisica VALUES (285, 3, 25.50, 5, 29);
INSERT INTO public.detalle_venta_fisica VALUES (286, 4, 18.75, 6, 29);
INSERT INTO public.detalle_venta_fisica VALUES (287, 3, 6.75, 7, 29);
INSERT INTO public.detalle_venta_fisica VALUES (288, 4, 30.00, 8, 29);
INSERT INTO public.detalle_venta_fisica VALUES (289, 3, 14.80, 9, 29);
INSERT INTO public.detalle_venta_fisica VALUES (290, 4, 33.00, 10, 29);

INSERT INTO public.detalle_venta_fisica VALUES (291, 5, 8.50, 1, 30);
INSERT INTO public.detalle_venta_fisica VALUES (292, 4, 12.00, 2, 30);
INSERT INTO public.detalle_venta_fisica VALUES (293, 5, 15.50, 3, 30);
INSERT INTO public.detalle_venta_fisica VALUES (294, 4, 22.00, 4, 30);
INSERT INTO public.detalle_venta_fisica VALUES (295, 5, 25.50, 5, 30);
INSERT INTO public.detalle_venta_fisica VALUES (296, 4, 18.75, 6, 30);
INSERT INTO public.detalle_venta_fisica VALUES (297, 5, 6.75, 7, 30);
INSERT INTO public.detalle_venta_fisica VALUES (298, 4, 30.00, 8, 30);
INSERT INTO public.detalle_venta_fisica VALUES (299, 5, 14.80, 9, 30);
INSERT INTO public.detalle_venta_fisica VALUES (300, 4, 33.00, 10, 30);

-- Ventas 31-40 (Clientes Jurídicos 31-40)
INSERT INTO public.detalle_venta_fisica VALUES (301, 4, 8.50, 1, 31);
INSERT INTO public.detalle_venta_fisica VALUES (302, 5, 12.00, 2, 31);
INSERT INTO public.detalle_venta_fisica VALUES (303, 4, 15.50, 3, 31);
INSERT INTO public.detalle_venta_fisica VALUES (304, 5, 22.00, 4, 31);
INSERT INTO public.detalle_venta_fisica VALUES (305, 4, 25.50, 5, 31);
INSERT INTO public.detalle_venta_fisica VALUES (306, 5, 18.75, 6, 31);
INSERT INTO public.detalle_venta_fisica VALUES (307, 4, 6.75, 7, 31);
INSERT INTO public.detalle_venta_fisica VALUES (308, 5, 30.00, 8, 31);
INSERT INTO public.detalle_venta_fisica VALUES (309, 4, 14.80, 9, 31);
INSERT INTO public.detalle_venta_fisica VALUES (310, 5, 33.00, 10, 31);

INSERT INTO public.detalle_venta_fisica VALUES (311, 6, 8.50, 1, 32);
INSERT INTO public.detalle_venta_fisica VALUES (312, 7, 12.00, 2, 32);
INSERT INTO public.detalle_venta_fisica VALUES (313, 5, 15.50, 3, 32);
INSERT INTO public.detalle_venta_fisica VALUES (314, 6, 22.00, 4, 32);
INSERT INTO public.detalle_venta_fisica VALUES (315, 7, 25.50, 5, 32);
INSERT INTO public.detalle_venta_fisica VALUES (316, 5, 18.75, 6, 32);
INSERT INTO public.detalle_venta_fisica VALUES (317, 6, 6.75, 7, 32);
INSERT INTO public.detalle_venta_fisica VALUES (318, 7, 30.00, 8, 32);
INSERT INTO public.detalle_venta_fisica VALUES (319, 5, 14.80, 9, 32);
INSERT INTO public.detalle_venta_fisica VALUES (320, 6, 33.00, 10, 32);

INSERT INTO public.detalle_venta_fisica VALUES (321, 3, 8.50, 1, 33);
INSERT INTO public.detalle_venta_fisica VALUES (322, 4, 12.00, 2, 33);
INSERT INTO public.detalle_venta_fisica VALUES (323, 3, 15.50, 3, 33);
INSERT INTO public.detalle_venta_fisica VALUES (324, 4, 22.00, 4, 33);
INSERT INTO public.detalle_venta_fisica VALUES (325, 3, 25.50, 5, 33);
INSERT INTO public.detalle_venta_fisica VALUES (326, 4, 18.75, 6, 33);
INSERT INTO public.detalle_venta_fisica VALUES (327, 3, 6.75, 7, 33);
INSERT INTO public.detalle_venta_fisica VALUES (328, 4, 30.00, 8, 33);
INSERT INTO public.detalle_venta_fisica VALUES (329, 3, 14.80, 9, 33);
INSERT INTO public.detalle_venta_fisica VALUES (330, 4, 33.00, 10, 33);

INSERT INTO public.detalle_venta_fisica VALUES (331, 5, 8.50, 1, 34);
INSERT INTO public.detalle_venta_fisica VALUES (332, 4, 12.00, 2, 34);
INSERT INTO public.detalle_venta_fisica VALUES (333, 5, 15.50, 3, 34);
INSERT INTO public.detalle_venta_fisica VALUES (334, 4, 22.00, 4, 34);
INSERT INTO public.detalle_venta_fisica VALUES (335, 5, 25.50, 5, 34);
INSERT INTO public.detalle_venta_fisica VALUES (336, 4, 18.75, 6, 34);
INSERT INTO public.detalle_venta_fisica VALUES (337, 5, 6.75, 7, 34);
INSERT INTO public.detalle_venta_fisica VALUES (338, 4, 30.00, 8, 34);
INSERT INTO public.detalle_venta_fisica VALUES (339, 5, 14.80, 9, 34);
INSERT INTO public.detalle_venta_fisica VALUES (340, 4, 33.00, 10, 34);

INSERT INTO public.detalle_venta_fisica VALUES (341, 6, 8.50, 1, 35);
INSERT INTO public.detalle_venta_fisica VALUES (342, 5, 12.00, 2, 35);
INSERT INTO public.detalle_venta_fisica VALUES (343, 6, 15.50, 3, 35);
INSERT INTO public.detalle_venta_fisica VALUES (344, 5, 22.00, 4, 35);
INSERT INTO public.detalle_venta_fisica VALUES (345, 6, 25.50, 5, 35);
INSERT INTO public.detalle_venta_fisica VALUES (346, 5, 18.75, 6, 35);
INSERT INTO public.detalle_venta_fisica VALUES (347, 6, 6.75, 7, 35);
INSERT INTO public.detalle_venta_fisica VALUES (348, 5, 30.00, 8, 35);
INSERT INTO public.detalle_venta_fisica VALUES (349, 6, 14.80, 9, 35);
INSERT INTO public.detalle_venta_fisica VALUES (350, 5, 33.00, 10, 35);

INSERT INTO public.detalle_venta_fisica VALUES (351, 4, 8.50, 1, 36);
INSERT INTO public.detalle_venta_fisica VALUES (352, 3, 12.00, 2, 36);
INSERT INTO public.detalle_venta_fisica VALUES (353, 4, 15.50, 3, 36);
INSERT INTO public.detalle_venta_fisica VALUES (354, 3, 22.00, 4, 36);
INSERT INTO public.detalle_venta_fisica VALUES (355, 4, 25.50, 5, 36);
INSERT INTO public.detalle_venta_fisica VALUES (356, 3, 18.75, 6, 36);
INSERT INTO public.detalle_venta_fisica VALUES (357, 4, 6.75, 7, 36);
INSERT INTO public.detalle_venta_fisica VALUES (358, 3, 30.00, 8, 36);
INSERT INTO public.detalle_venta_fisica VALUES (359, 4, 14.80, 9, 36);
INSERT INTO public.detalle_venta_fisica VALUES (360, 3, 33.00, 10, 36);

INSERT INTO public.detalle_venta_fisica VALUES (361, 5, 8.50, 1, 37);
INSERT INTO public.detalle_venta_fisica VALUES (362, 4, 12.00, 2, 37);
INSERT INTO public.detalle_venta_fisica VALUES (363, 3, 15.50, 3, 37);
INSERT INTO public.detalle_venta_fisica VALUES (364, 5, 22.00, 4, 37);
INSERT INTO public.detalle_venta_fisica VALUES (365, 4, 25.50, 5, 37);
INSERT INTO public.detalle_venta_fisica VALUES (366, 3, 18.75, 6, 37);
INSERT INTO public.detalle_venta_fisica VALUES (367, 5, 6.75, 7, 37);
INSERT INTO public.detalle_venta_fisica VALUES (368, 4, 30.00, 8, 37);
INSERT INTO public.detalle_venta_fisica VALUES (369, 3, 14.80, 9, 37);
INSERT INTO public.detalle_venta_fisica VALUES (370, 5, 33.00, 10, 37);

INSERT INTO public.detalle_venta_fisica VALUES (371, 6, 8.50, 1, 38);
INSERT INTO public.detalle_venta_fisica VALUES (372, 5, 12.00, 2, 38);
INSERT INTO public.detalle_venta_fisica VALUES (373, 6, 15.50, 3, 38);
INSERT INTO public.detalle_venta_fisica VALUES (374, 5, 22.00, 4, 38);
INSERT INTO public.detalle_venta_fisica VALUES (375, 6, 25.50, 5, 38);
INSERT INTO public.detalle_venta_fisica VALUES (376, 5, 18.75, 6, 38);
INSERT INTO public.detalle_venta_fisica VALUES (377, 6, 6.75, 7, 38);
INSERT INTO public.detalle_venta_fisica VALUES (378, 5, 30.00, 8, 38);
INSERT INTO public.detalle_venta_fisica VALUES (379, 6, 14.80, 9, 38);
INSERT INTO public.detalle_venta_fisica VALUES (380, 5, 33.00, 10, 38);

INSERT INTO public.detalle_venta_fisica VALUES (381, 4, 8.50, 1, 39);
INSERT INTO public.detalle_venta_fisica VALUES (382, 3, 12.00, 2, 39);
INSERT INTO public.detalle_venta_fisica VALUES (383, 4, 15.50, 3, 39);
INSERT INTO public.detalle_venta_fisica VALUES (384, 3, 22.00, 4, 39);
INSERT INTO public.detalle_venta_fisica VALUES (385, 4, 25.50, 5, 39);
INSERT INTO public.detalle_venta_fisica VALUES (386, 3, 18.75, 6, 39);
INSERT INTO public.detalle_venta_fisica VALUES (387, 4, 6.75, 7, 39);
INSERT INTO public.detalle_venta_fisica VALUES (388, 3, 30.00, 8, 39);
INSERT INTO public.detalle_venta_fisica VALUES (389, 4, 14.80, 9, 39);
INSERT INTO public.detalle_venta_fisica VALUES (390, 3, 33.00, 10, 39);

INSERT INTO public.detalle_venta_fisica VALUES (391, 5, 8.50, 1, 40);
INSERT INTO public.detalle_venta_fisica VALUES (392, 6, 12.00, 2, 40);
INSERT INTO public.detalle_venta_fisica VALUES (393, 4, 15.50, 3, 40);
INSERT INTO public.detalle_venta_fisica VALUES (394, 5, 22.00, 4, 40);
INSERT INTO public.detalle_venta_fisica VALUES (395, 6, 25.50, 5, 40);
INSERT INTO public.detalle_venta_fisica VALUES (396, 4, 18.75, 6, 40);
INSERT INTO public.detalle_venta_fisica VALUES (397, 5, 6.75, 7, 40);
INSERT INTO public.detalle_venta_fisica VALUES (398, 6, 30.00, 8, 40);
INSERT INTO public.detalle_venta_fisica VALUES (399, 4, 14.80, 9, 40);
INSERT INTO public.detalle_venta_fisica VALUES (400, 5, 33.00, 10, 40);

-- FIN DE LOS INSERTS FALTANTES PARA DETALLE_VENTA_FISICA
-- Total: 380 inserts adicionales (del 21 al 400)
-- Patrón: 10 productos por venta física (40 ventas × 10 productos = 400 registros totales)
-- Ya existían: 20 registros (del 1 al 20)
-- Se agregan: 380 registros (del 21 al 400) 


--
-- Data for Name: venta_online; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.venta_online VALUES (1, '2024-01-20', 145600, 4, 1, 1);
INSERT INTO public.venta_online VALUES (2, '2024-01-23', 167800, 4, 2, 2);
INSERT INTO public.venta_online VALUES (3, '2024-01-26', 198700, 4, 3, 3);
INSERT INTO public.venta_online VALUES (4, '2024-01-29', 189200, 4, 4, 4);
INSERT INTO public.venta_online VALUES (5, '2024-02-02', 167500, 4, 5, 5);
INSERT INTO public.venta_online VALUES (6, '2024-02-05', 156800, 4, 6, 6);
INSERT INTO public.venta_online VALUES (7, '2024-02-08', 201500, 4, 7, 2);
INSERT INTO public.venta_online VALUES (8, '2024-02-11', 187600, 4, 8, 3);
INSERT INTO public.venta_online VALUES (9, '2024-02-14', 177500, 4, 9, 4);
INSERT INTO public.venta_online VALUES (10, '2024-02-17', 164800, 4, 10, 5);
INSERT INTO public.venta_online VALUES (11, '2024-02-20', 189200, 4, 1, 1);
INSERT INTO public.venta_online VALUES (12, '2024-02-23', 145600, 4, 2, 2);
INSERT INTO public.venta_online VALUES (13, '2024-02-26', 198700, 4, 3, 3);
INSERT INTO public.venta_online VALUES (14, '2024-03-01', 123400, 4, 4, 4);
INSERT INTO public.venta_online VALUES (15, '2024-03-04', 167800, 4, 5, 5);
INSERT INTO public.venta_online VALUES (16, '2024-03-07', 189600, 4, 6, 6);
INSERT INTO public.venta_online VALUES (17, '2024-03-10', 145300, 4, 7, 7);
INSERT INTO public.venta_online VALUES (18, '2024-03-13', 178900, 4, 8, 8);
INSERT INTO public.venta_online VALUES (19, '2024-03-16', 156900, 4, 9, 9);
INSERT INTO public.venta_online VALUES (20, '2024-03-19', 134500, 4, 10, 10);
INSERT INTO public.venta_online VALUES (21, '2024-03-22', 556000, 4, 1, 1);
INSERT INTO public.venta_online VALUES (22, '2024-03-25', 778000, 4, 2, 2);
INSERT INTO public.venta_online VALUES (23, '2024-03-28', 445000, 4, 3, 3);
INSERT INTO public.venta_online VALUES (24, '2024-03-31', 889000, 4, 4, 4);
INSERT INTO public.venta_online VALUES (25, '2024-04-03', 334000, 4, 5, 5);
INSERT INTO public.venta_online VALUES (26, '2024-04-06', 667000, 4, 6, 6);
INSERT INTO public.venta_online VALUES (27, '2024-04-09', 532000, 4, 7, 7);
INSERT INTO public.venta_online VALUES (28, '2024-04-12', 754000, 4, 8, 8);
INSERT INTO public.venta_online VALUES (29, '2024-04-15', 398000, 4, 9, 9);
INSERT INTO public.venta_online VALUES (30, '2024-04-18', 643000, 4, 10, 10);
INSERT INTO public.venta_online VALUES (31, '2024-04-21', 476000, 4, 1, 1);
INSERT INTO public.venta_online VALUES (32, '2024-04-24', 787000, 4, 2, 2);
INSERT INTO public.venta_online VALUES (33, '2024-04-27', 334000, 4, 3, 3);
INSERT INTO public.venta_online VALUES (34, '2024-04-30', 556000, 4, 4, 4);
INSERT INTO public.venta_online VALUES (35, '2024-05-03', 667000, 4, 5, 5);
INSERT INTO public.venta_online VALUES (36, '2024-05-06', 445000, 4, 6, 6);
INSERT INTO public.venta_online VALUES (37, '2024-05-09', 532000, 4, 7, 7);
INSERT INTO public.venta_online VALUES (38, '2024-05-12', 754000, 4, 8, 8);
INSERT INTO public.venta_online VALUES (39, '2024-05-15', 476000, 4, 9, 9);
INSERT INTO public.venta_online VALUES (40, '2024-05-18', 643000, 4, 10, 10);


--
-- Data for Name: detalle_venta_online; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.detalle_venta_online VALUES (17601, 2, 8.50, 1, 1);
INSERT INTO public.detalle_venta_online VALUES (17602, 3, 12.00, 2, 1);
INSERT INTO public.detalle_venta_online VALUES (17603, 1, 15.50, 3, 1);
INSERT INTO public.detalle_venta_online VALUES (17604, 2, 22.00, 4, 1);
INSERT INTO public.detalle_venta_online VALUES (17605, 1, 6.75, 5, 1);
INSERT INTO public.detalle_venta_online VALUES (17606, 2, 10.25, 6, 1);
INSERT INTO public.detalle_venta_online VALUES (17607, 1, 18.75, 7, 1);
INSERT INTO public.detalle_venta_online VALUES (17608, 2, 25.50, 8, 1);
INSERT INTO public.detalle_venta_online VALUES (17609, 1, 30.00, 9, 1);
INSERT INTO public.detalle_venta_online VALUES (17610, 2, 14.80, 10, 1);
INSERT INTO public.detalle_venta_online VALUES (17611, 3, 8.50, 1, 2);
INSERT INTO public.detalle_venta_online VALUES (17612, 2, 12.00, 2, 2);
INSERT INTO public.detalle_venta_online VALUES (17613, 2, 15.50, 3, 2);
INSERT INTO public.detalle_venta_online VALUES (17614, 1, 22.00, 4, 2);
INSERT INTO public.detalle_venta_online VALUES (17615, 3, 6.75, 5, 2);
INSERT INTO public.detalle_venta_online VALUES (17616, 1, 10.25, 6, 2);
INSERT INTO public.detalle_venta_online VALUES (17617, 2, 18.75, 7, 2);
INSERT INTO public.detalle_venta_online VALUES (17618, 1, 25.50, 8, 2);
INSERT INTO public.detalle_venta_online VALUES (17619, 2, 30.00, 9, 2);
INSERT INTO public.detalle_venta_online VALUES (17620, 1, 14.80, 10, 2);
INSERT INTO public.detalle_venta_online VALUES (17621, 2, 8.50, 1, 3);
INSERT INTO public.detalle_venta_online VALUES (17622, 2, 12.00, 2, 3);
INSERT INTO public.detalle_venta_online VALUES (17623, 3, 15.50, 3, 3);
INSERT INTO public.detalle_venta_online VALUES (17624, 2, 22.00, 4, 3);
INSERT INTO public.detalle_venta_online VALUES (17625, 1, 6.75, 5, 3);
INSERT INTO public.detalle_venta_online VALUES (17626, 2, 10.25, 6, 3);
INSERT INTO public.detalle_venta_online VALUES (17627, 1, 18.75, 7, 3);
INSERT INTO public.detalle_venta_online VALUES (17628, 2, 25.50, 8, 3);
INSERT INTO public.detalle_venta_online VALUES (17629, 1, 30.00, 9, 3);
INSERT INTO public.detalle_venta_online VALUES (17630, 3, 14.80, 10, 3);
INSERT INTO public.detalle_venta_online VALUES (17631, 1, 8.50, 1, 4);
INSERT INTO public.detalle_venta_online VALUES (17632, 3, 12.00, 2, 4);
INSERT INTO public.detalle_venta_online VALUES (17633, 2, 15.50, 3, 4);
INSERT INTO public.detalle_venta_online VALUES (17634, 2, 22.00, 4, 4);
INSERT INTO public.detalle_venta_online VALUES (17635, 2, 6.75, 5, 4);
INSERT INTO public.detalle_venta_online VALUES (17636, 1, 10.25, 6, 4);
INSERT INTO public.detalle_venta_online VALUES (17637, 2, 18.75, 7, 4);
INSERT INTO public.detalle_venta_online VALUES (17638, 1, 25.50, 8, 4);
INSERT INTO public.detalle_venta_online VALUES (17639, 2, 30.00, 9, 4);
INSERT INTO public.detalle_venta_online VALUES (17640, 2, 14.80, 10, 4);
INSERT INTO public.detalle_venta_online VALUES (17641, 3, 8.50, 1, 5);
INSERT INTO public.detalle_venta_online VALUES (17642, 2, 12.00, 2, 5);
INSERT INTO public.detalle_venta_online VALUES (17643, 2, 15.50, 3, 5);
INSERT INTO public.detalle_venta_online VALUES (17644, 3, 22.00, 4, 5);
INSERT INTO public.detalle_venta_online VALUES (17645, 1, 6.75, 5, 5);
INSERT INTO public.detalle_venta_online VALUES (17646, 2, 10.25, 6, 5);
INSERT INTO public.detalle_venta_online VALUES (17647, 2, 18.75, 7, 5);
INSERT INTO public.detalle_venta_online VALUES (17648, 2, 25.50, 8, 5);
INSERT INTO public.detalle_venta_online VALUES (17649, 1, 30.00, 9, 5);
INSERT INTO public.detalle_venta_online VALUES (17650, 2, 14.80, 10, 5);
INSERT INTO public.detalle_venta_online VALUES (17651, 2, 8.50, 1, 6);
INSERT INTO public.detalle_venta_online VALUES (17652, 2, 12.00, 2, 6);
INSERT INTO public.detalle_venta_online VALUES (17653, 3, 15.50, 3, 6);
INSERT INTO public.detalle_venta_online VALUES (17654, 1, 22.00, 4, 6);
INSERT INTO public.detalle_venta_online VALUES (17655, 2, 6.75, 5, 6);
INSERT INTO public.detalle_venta_online VALUES (17656, 2, 10.25, 6, 6);
INSERT INTO public.detalle_venta_online VALUES (17657, 1, 18.75, 7, 6);
INSERT INTO public.detalle_venta_online VALUES (17658, 3, 25.50, 8, 6);
INSERT INTO public.detalle_venta_online VALUES (17659, 2, 30.00, 9, 6);
INSERT INTO public.detalle_venta_online VALUES (17660, 1, 14.80, 10, 6);
INSERT INTO public.detalle_venta_online VALUES (17661, 2, 8.50, 1, 7);
INSERT INTO public.detalle_venta_online VALUES (17662, 3, 12.00, 2, 7);
INSERT INTO public.detalle_venta_online VALUES (17663, 1, 15.50, 3, 7);
INSERT INTO public.detalle_venta_online VALUES (17664, 2, 22.00, 4, 7);
INSERT INTO public.detalle_venta_online VALUES (17665, 2, 6.75, 5, 7);
INSERT INTO public.detalle_venta_online VALUES (17666, 1, 10.25, 6, 7);
INSERT INTO public.detalle_venta_online VALUES (17667, 2, 18.75, 7, 7);
INSERT INTO public.detalle_venta_online VALUES (17668, 2, 25.50, 8, 7);
INSERT INTO public.detalle_venta_online VALUES (17669, 2, 30.00, 9, 7);
INSERT INTO public.detalle_venta_online VALUES (17670, 3, 14.80, 10, 7);
INSERT INTO public.detalle_venta_online VALUES (17671, 1, 8.50, 1, 8);
INSERT INTO public.detalle_venta_online VALUES (17672, 2, 12.00, 2, 8);
INSERT INTO public.detalle_venta_online VALUES (17673, 2, 15.50, 3, 8);
INSERT INTO public.detalle_venta_online VALUES (17674, 3, 22.00, 4, 8);
INSERT INTO public.detalle_venta_online VALUES (17675, 1, 6.75, 5, 8);
INSERT INTO public.detalle_venta_online VALUES (17676, 3, 10.25, 6, 8);
INSERT INTO public.detalle_venta_online VALUES (17677, 2, 18.75, 7, 8);
INSERT INTO public.detalle_venta_online VALUES (17678, 1, 25.50, 8, 8);
INSERT INTO public.detalle_venta_online VALUES (17679, 2, 30.00, 9, 8);
INSERT INTO public.detalle_venta_online VALUES (17680, 2, 14.80, 10, 8);
INSERT INTO public.detalle_venta_online VALUES (17681, 3, 8.50, 1, 9);
INSERT INTO public.detalle_venta_online VALUES (17682, 1, 12.00, 2, 9);
INSERT INTO public.detalle_venta_online VALUES (17683, 2, 15.50, 3, 9);
INSERT INTO public.detalle_venta_online VALUES (17684, 2, 22.00, 4, 9);
INSERT INTO public.detalle_venta_online VALUES (17685, 3, 6.75, 5, 9);
INSERT INTO public.detalle_venta_online VALUES (17686, 2, 10.25, 6, 9);
INSERT INTO public.detalle_venta_online VALUES (17687, 1, 18.75, 7, 9);
INSERT INTO public.detalle_venta_online VALUES (17688, 2, 25.50, 8, 9);
INSERT INTO public.detalle_venta_online VALUES (17689, 1, 30.00, 9, 9);
INSERT INTO public.detalle_venta_online VALUES (17690, 2, 14.80, 10, 9);
INSERT INTO public.detalle_venta_online VALUES (17691, 2, 8.50, 1, 10);
INSERT INTO public.detalle_venta_online VALUES (17692, 2, 12.00, 2, 10);
INSERT INTO public.detalle_venta_online VALUES (17693, 3, 15.50, 3, 10);
INSERT INTO public.detalle_venta_online VALUES (17694, 2, 22.00, 4, 10);
INSERT INTO public.detalle_venta_online VALUES (17695, 2, 6.75, 5, 10);
INSERT INTO public.detalle_venta_online VALUES (17696, 2, 10.25, 6, 10);
INSERT INTO public.detalle_venta_online VALUES (17697, 2, 18.75, 7, 10);
INSERT INTO public.detalle_venta_online VALUES (17698, 2, 25.50, 8, 10);
INSERT INTO public.detalle_venta_online VALUES (17699, 3, 30.00, 9, 10);
INSERT INTO public.detalle_venta_online VALUES (17700, 1, 14.80, 10, 10);
INSERT INTO public.detalle_venta_online VALUES (17701, 1, 8.50, 1, 11);
INSERT INTO public.detalle_venta_online VALUES (17702, 2, 12.00, 2, 11);
INSERT INTO public.detalle_venta_online VALUES (17703, 1, 15.50, 3, 11);
INSERT INTO public.detalle_venta_online VALUES (17704, 3, 22.00, 4, 11);
INSERT INTO public.detalle_venta_online VALUES (17705, 2, 6.75, 5, 11);
INSERT INTO public.detalle_venta_online VALUES (17706, 1, 10.25, 6, 11);
INSERT INTO public.detalle_venta_online VALUES (17707, 3, 18.75, 7, 11);
INSERT INTO public.detalle_venta_online VALUES (17708, 1, 25.50, 8, 11);
INSERT INTO public.detalle_venta_online VALUES (17709, 2, 30.00, 9, 11);
INSERT INTO public.detalle_venta_online VALUES (17710, 2, 14.80, 10, 11);
INSERT INTO public.detalle_venta_online VALUES (17711, 2, 8.50, 1, 12);
INSERT INTO public.detalle_venta_online VALUES (17712, 1, 12.00, 2, 12);
INSERT INTO public.detalle_venta_online VALUES (17713, 2, 15.50, 3, 12);
INSERT INTO public.detalle_venta_online VALUES (17714, 1, 22.00, 4, 12);
INSERT INTO public.detalle_venta_online VALUES (17715, 3, 6.75, 5, 12);
INSERT INTO public.detalle_venta_online VALUES (17716, 2, 10.25, 6, 12);
INSERT INTO public.detalle_venta_online VALUES (17717, 1, 18.75, 7, 12);
INSERT INTO public.detalle_venta_online VALUES (17718, 2, 25.50, 8, 12);
INSERT INTO public.detalle_venta_online VALUES (17719, 1, 30.00, 9, 12);
INSERT INTO public.detalle_venta_online VALUES (17720, 3, 14.80, 10, 12);
INSERT INTO public.detalle_venta_online VALUES (17721, 3, 8.50, 1, 13);
INSERT INTO public.detalle_venta_online VALUES (17722, 2, 12.00, 2, 13);
INSERT INTO public.detalle_venta_online VALUES (17723, 1, 15.50, 3, 13);
INSERT INTO public.detalle_venta_online VALUES (17724, 2, 22.00, 4, 13);
INSERT INTO public.detalle_venta_online VALUES (17725, 1, 6.75, 5, 13);
INSERT INTO public.detalle_venta_online VALUES (17726, 3, 10.25, 6, 13);
INSERT INTO public.detalle_venta_online VALUES (17727, 2, 18.75, 7, 13);
INSERT INTO public.detalle_venta_online VALUES (17728, 1, 25.50, 8, 13);
INSERT INTO public.detalle_venta_online VALUES (17729, 2, 30.00, 9, 13);
INSERT INTO public.detalle_venta_online VALUES (17730, 1, 14.80, 10, 13);
INSERT INTO public.detalle_venta_online VALUES (17731, 1, 8.50, 1, 14);
INSERT INTO public.detalle_venta_online VALUES (17732, 3, 12.00, 2, 14);
INSERT INTO public.detalle_venta_online VALUES (17733, 2, 15.50, 3, 14);
INSERT INTO public.detalle_venta_online VALUES (17734, 1, 22.00, 4, 14);
INSERT INTO public.detalle_venta_online VALUES (17735, 2, 6.75, 5, 14);
INSERT INTO public.detalle_venta_online VALUES (17736, 1, 10.25, 6, 14);
INSERT INTO public.detalle_venta_online VALUES (17737, 2, 18.75, 7, 14);
INSERT INTO public.detalle_venta_online VALUES (17738, 3, 25.50, 8, 14);
INSERT INTO public.detalle_venta_online VALUES (17739, 1, 30.00, 9, 14);
INSERT INTO public.detalle_venta_online VALUES (17740, 2, 14.80, 10, 14);
INSERT INTO public.detalle_venta_online VALUES (17741, 2, 8.50, 1, 15);
INSERT INTO public.detalle_venta_online VALUES (17742, 1, 12.00, 2, 15);
INSERT INTO public.detalle_venta_online VALUES (17743, 3, 15.50, 3, 15);
INSERT INTO public.detalle_venta_online VALUES (17744, 2, 22.00, 4, 15);
INSERT INTO public.detalle_venta_online VALUES (17745, 1, 6.75, 5, 15);
INSERT INTO public.detalle_venta_online VALUES (17746, 2, 10.25, 6, 15);
INSERT INTO public.detalle_venta_online VALUES (17747, 1, 18.75, 7, 15);
INSERT INTO public.detalle_venta_online VALUES (17748, 1, 25.50, 8, 15);
INSERT INTO public.detalle_venta_online VALUES (17749, 3, 30.00, 9, 15);
INSERT INTO public.detalle_venta_online VALUES (17750, 2, 14.80, 10, 15);
INSERT INTO public.detalle_venta_online VALUES (17751, 3, 8.50, 1, 16);
INSERT INTO public.detalle_venta_online VALUES (17752, 2, 12.00, 2, 16);
INSERT INTO public.detalle_venta_online VALUES (17753, 1, 15.50, 3, 16);
INSERT INTO public.detalle_venta_online VALUES (17754, 3, 22.00, 4, 16);
INSERT INTO public.detalle_venta_online VALUES (17755, 2, 6.75, 5, 16);
INSERT INTO public.detalle_venta_online VALUES (17756, 1, 10.25, 6, 16);
INSERT INTO public.detalle_venta_online VALUES (17757, 2, 18.75, 7, 16);
INSERT INTO public.detalle_venta_online VALUES (17758, 2, 25.50, 8, 16);
INSERT INTO public.detalle_venta_online VALUES (17759, 1, 30.00, 9, 16);
INSERT INTO public.detalle_venta_online VALUES (17760, 2, 14.80, 10, 16);
INSERT INTO public.detalle_venta_online VALUES (17761, 1, 8.50, 1, 17);
INSERT INTO public.detalle_venta_online VALUES (17762, 2, 12.00, 2, 17);
INSERT INTO public.detalle_venta_online VALUES (17763, 2, 15.50, 3, 17);
INSERT INTO public.detalle_venta_online VALUES (17764, 1, 22.00, 4, 17);
INSERT INTO public.detalle_venta_online VALUES (17765, 3, 6.75, 5, 17);
INSERT INTO public.detalle_venta_online VALUES (17766, 1, 10.25, 6, 17);
INSERT INTO public.detalle_venta_online VALUES (17767, 3, 18.75, 7, 17);
INSERT INTO public.detalle_venta_online VALUES (17768, 1, 25.50, 8, 17);
INSERT INTO public.detalle_venta_online VALUES (17769, 2, 30.00, 9, 17);
INSERT INTO public.detalle_venta_online VALUES (17770, 2, 14.80, 10, 17);
INSERT INTO public.detalle_venta_online VALUES (17771, 2, 8.50, 1, 18);
INSERT INTO public.detalle_venta_online VALUES (17772, 3, 12.00, 2, 18);
INSERT INTO public.detalle_venta_online VALUES (17773, 1, 15.50, 3, 18);
INSERT INTO public.detalle_venta_online VALUES (17774, 2, 22.00, 4, 18);
INSERT INTO public.detalle_venta_online VALUES (17775, 1, 6.75, 5, 18);
INSERT INTO public.detalle_venta_online VALUES (17776, 2, 10.25, 6, 18);
INSERT INTO public.detalle_venta_online VALUES (17777, 1, 18.75, 7, 18);
INSERT INTO public.detalle_venta_online VALUES (17778, 3, 25.50, 8, 18);
INSERT INTO public.detalle_venta_online VALUES (17779, 2, 30.00, 9, 18);
INSERT INTO public.detalle_venta_online VALUES (17780, 1, 14.80, 10, 18);
INSERT INTO public.detalle_venta_online VALUES (17781, 3, 8.50, 1, 19);
INSERT INTO public.detalle_venta_online VALUES (17782, 1, 12.00, 2, 19);
INSERT INTO public.detalle_venta_online VALUES (17783, 2, 15.50, 3, 19);
INSERT INTO public.detalle_venta_online VALUES (17784, 3, 22.00, 4, 19);
INSERT INTO public.detalle_venta_online VALUES (17785, 2, 6.75, 5, 19);
INSERT INTO public.detalle_venta_online VALUES (17786, 1, 10.25, 6, 19);
INSERT INTO public.detalle_venta_online VALUES (17787, 2, 18.75, 7, 19);
INSERT INTO public.detalle_venta_online VALUES (17788, 1, 25.50, 8, 19);
INSERT INTO public.detalle_venta_online VALUES (17789, 1, 30.00, 9, 19);
INSERT INTO public.detalle_venta_online VALUES (17790, 3, 14.80, 10, 19);
INSERT INTO public.detalle_venta_online VALUES (17791, 1, 8.50, 1, 20);
INSERT INTO public.detalle_venta_online VALUES (17792, 2, 12.00, 2, 20);
INSERT INTO public.detalle_venta_online VALUES (17793, 3, 15.50, 3, 20);
INSERT INTO public.detalle_venta_online VALUES (17794, 1, 22.00, 4, 20);
INSERT INTO public.detalle_venta_online VALUES (17795, 2, 6.75, 5, 20);
INSERT INTO public.detalle_venta_online VALUES (17796, 3, 10.25, 6, 20);
INSERT INTO public.detalle_venta_online VALUES (17797, 1, 18.75, 7, 20);
INSERT INTO public.detalle_venta_online VALUES (17798, 2, 25.50, 8, 20);
INSERT INTO public.detalle_venta_online VALUES (17799, 2, 30.00, 9, 20);
INSERT INTO public.detalle_venta_online VALUES (17800, 1, 14.80, 10, 20);
INSERT INTO public.detalle_venta_online VALUES (17801, 5, 8.50, 1, 21);
INSERT INTO public.detalle_venta_online VALUES (17802, 6, 12.00, 2, 21);
INSERT INTO public.detalle_venta_online VALUES (17803, 4, 15.50, 3, 21);
INSERT INTO public.detalle_venta_online VALUES (17804, 5, 22.00, 4, 21);
INSERT INTO public.detalle_venta_online VALUES (17805, 6, 6.75, 5, 21);
INSERT INTO public.detalle_venta_online VALUES (17806, 4, 10.25, 6, 21);
INSERT INTO public.detalle_venta_online VALUES (17807, 5, 18.75, 7, 21);
INSERT INTO public.detalle_venta_online VALUES (17808, 6, 25.50, 8, 21);
INSERT INTO public.detalle_venta_online VALUES (17809, 4, 30.00, 9, 21);
INSERT INTO public.detalle_venta_online VALUES (17810, 5, 14.80, 10, 21);
INSERT INTO public.detalle_venta_online VALUES (17811, 7, 8.50, 1, 22);
INSERT INTO public.detalle_venta_online VALUES (17812, 6, 12.00, 2, 22);
INSERT INTO public.detalle_venta_online VALUES (17813, 5, 15.50, 3, 22);
INSERT INTO public.detalle_venta_online VALUES (17814, 7, 22.00, 4, 22);
INSERT INTO public.detalle_venta_online VALUES (17815, 6, 6.75, 5, 22);
INSERT INTO public.detalle_venta_online VALUES (17816, 5, 10.25, 6, 22);
INSERT INTO public.detalle_venta_online VALUES (17817, 7, 18.75, 7, 22);
INSERT INTO public.detalle_venta_online VALUES (17818, 6, 25.50, 8, 22);
INSERT INTO public.detalle_venta_online VALUES (17819, 5, 30.00, 9, 22);
INSERT INTO public.detalle_venta_online VALUES (17820, 7, 14.80, 10, 22);
INSERT INTO public.detalle_venta_online VALUES (17821, 4, 8.50, 1, 23);
INSERT INTO public.detalle_venta_online VALUES (17822, 5, 12.00, 2, 23);
INSERT INTO public.detalle_venta_online VALUES (17823, 4, 15.50, 3, 23);
INSERT INTO public.detalle_venta_online VALUES (17824, 5, 22.00, 4, 23);
INSERT INTO public.detalle_venta_online VALUES (17825, 4, 6.75, 5, 23);
INSERT INTO public.detalle_venta_online VALUES (17826, 5, 10.25, 6, 23);
INSERT INTO public.detalle_venta_online VALUES (17827, 4, 18.75, 7, 23);
INSERT INTO public.detalle_venta_online VALUES (17828, 5, 25.50, 8, 23);
INSERT INTO public.detalle_venta_online VALUES (17829, 4, 30.00, 9, 23);
INSERT INTO public.detalle_venta_online VALUES (17830, 5, 14.80, 10, 23);
INSERT INTO public.detalle_venta_online VALUES (17831, 8, 8.50, 1, 24);
INSERT INTO public.detalle_venta_online VALUES (17832, 7, 12.00, 2, 24);
INSERT INTO public.detalle_venta_online VALUES (17833, 6, 15.50, 3, 24);
INSERT INTO public.detalle_venta_online VALUES (17834, 8, 22.00, 4, 24);
INSERT INTO public.detalle_venta_online VALUES (17835, 7, 6.75, 5, 24);
INSERT INTO public.detalle_venta_online VALUES (17836, 6, 10.25, 6, 24);
INSERT INTO public.detalle_venta_online VALUES (17837, 8, 18.75, 7, 24);
INSERT INTO public.detalle_venta_online VALUES (17838, 7, 25.50, 8, 24);
INSERT INTO public.detalle_venta_online VALUES (17839, 6, 30.00, 9, 24);
INSERT INTO public.detalle_venta_online VALUES (17840, 8, 14.80, 10, 24);
INSERT INTO public.detalle_venta_online VALUES (17841, 5, 8.50, 1, 25);
INSERT INTO public.detalle_venta_online VALUES (17842, 4, 12.00, 2, 25);
INSERT INTO public.detalle_venta_online VALUES (17843, 5, 15.50, 3, 25);
INSERT INTO public.detalle_venta_online VALUES (17844, 4, 22.00, 4, 25);
INSERT INTO public.detalle_venta_online VALUES (17845, 5, 6.75, 5, 25);
INSERT INTO public.detalle_venta_online VALUES (17846, 4, 10.25, 6, 25);
INSERT INTO public.detalle_venta_online VALUES (17847, 5, 18.75, 7, 25);
INSERT INTO public.detalle_venta_online VALUES (17848, 4, 25.50, 8, 25);
INSERT INTO public.detalle_venta_online VALUES (17849, 5, 30.00, 9, 25);
INSERT INTO public.detalle_venta_online VALUES (17850, 4, 14.80, 10, 25);
INSERT INTO public.detalle_venta_online VALUES (17851, 6, 8.50, 1, 26);
INSERT INTO public.detalle_venta_online VALUES (17852, 7, 12.00, 2, 26);
INSERT INTO public.detalle_venta_online VALUES (17853, 5, 15.50, 3, 26);
INSERT INTO public.detalle_venta_online VALUES (17854, 6, 22.00, 4, 26);
INSERT INTO public.detalle_venta_online VALUES (17855, 7, 6.75, 5, 26);
INSERT INTO public.detalle_venta_online VALUES (17856, 5, 10.25, 6, 26);
INSERT INTO public.detalle_venta_online VALUES (17857, 6, 18.75, 7, 26);
INSERT INTO public.detalle_venta_online VALUES (17858, 7, 25.50, 8, 26);
INSERT INTO public.detalle_venta_online VALUES (17859, 5, 30.00, 9, 26);
INSERT INTO public.detalle_venta_online VALUES (17860, 6, 14.80, 10, 26);
INSERT INTO public.detalle_venta_online VALUES (17861, 5, 8.50, 1, 27);
INSERT INTO public.detalle_venta_online VALUES (17862, 6, 12.00, 2, 27);
INSERT INTO public.detalle_venta_online VALUES (17863, 4, 15.50, 3, 27);
INSERT INTO public.detalle_venta_online VALUES (17864, 5, 22.00, 4, 27);
INSERT INTO public.detalle_venta_online VALUES (17865, 6, 6.75, 5, 27);
INSERT INTO public.detalle_venta_online VALUES (17866, 4, 10.25, 6, 27);
INSERT INTO public.detalle_venta_online VALUES (17867, 5, 18.75, 7, 27);
INSERT INTO public.detalle_venta_online VALUES (17868, 6, 25.50, 8, 27);
INSERT INTO public.detalle_venta_online VALUES (17869, 4, 30.00, 9, 27);
INSERT INTO public.detalle_venta_online VALUES (17870, 5, 14.80, 10, 27);
INSERT INTO public.detalle_venta_online VALUES (17871, 7, 8.50, 1, 28);
INSERT INTO public.detalle_venta_online VALUES (17872, 6, 12.00, 2, 28);
INSERT INTO public.detalle_venta_online VALUES (17873, 7, 15.50, 3, 28);
INSERT INTO public.detalle_venta_online VALUES (17874, 6, 22.00, 4, 28);
INSERT INTO public.detalle_venta_online VALUES (17875, 7, 6.75, 5, 28);
INSERT INTO public.detalle_venta_online VALUES (17876, 6, 10.25, 6, 28);
INSERT INTO public.detalle_venta_online VALUES (17877, 7, 18.75, 7, 28);
INSERT INTO public.detalle_venta_online VALUES (17878, 6, 25.50, 8, 28);
INSERT INTO public.detalle_venta_online VALUES (17879, 7, 30.00, 9, 28);
INSERT INTO public.detalle_venta_online VALUES (17880, 6, 14.80, 10, 28);
INSERT INTO public.detalle_venta_online VALUES (17881, 4, 8.50, 1, 29);
INSERT INTO public.detalle_venta_online VALUES (17882, 5, 12.00, 2, 29);
INSERT INTO public.detalle_venta_online VALUES (17883, 4, 15.50, 3, 29);
INSERT INTO public.detalle_venta_online VALUES (17884, 5, 22.00, 4, 29);
INSERT INTO public.detalle_venta_online VALUES (17885, 4, 6.75, 5, 29);
INSERT INTO public.detalle_venta_online VALUES (17886, 5, 10.25, 6, 29);
INSERT INTO public.detalle_venta_online VALUES (17887, 4, 18.75, 7, 29);
INSERT INTO public.detalle_venta_online VALUES (17888, 5, 25.50, 8, 29);
INSERT INTO public.detalle_venta_online VALUES (17889, 4, 30.00, 9, 29);
INSERT INTO public.detalle_venta_online VALUES (17890, 5, 14.80, 10, 29);
INSERT INTO public.detalle_venta_online VALUES (17891, 6, 8.50, 1, 30);
INSERT INTO public.detalle_venta_online VALUES (17892, 5, 12.00, 2, 30);
INSERT INTO public.detalle_venta_online VALUES (17893, 6, 15.50, 3, 30);
INSERT INTO public.detalle_venta_online VALUES (17894, 5, 22.00, 4, 30);
INSERT INTO public.detalle_venta_online VALUES (17895, 6, 6.75, 5, 30);
INSERT INTO public.detalle_venta_online VALUES (17896, 5, 10.25, 6, 30);
INSERT INTO public.detalle_venta_online VALUES (17897, 6, 18.75, 7, 30);
INSERT INTO public.detalle_venta_online VALUES (17898, 5, 25.50, 8, 30);
INSERT INTO public.detalle_venta_online VALUES (17899, 6, 30.00, 9, 30);
INSERT INTO public.detalle_venta_online VALUES (17900, 5, 14.80, 10, 30);
INSERT INTO public.detalle_venta_online VALUES (17901, 5, 8.50, 1, 31);
INSERT INTO public.detalle_venta_online VALUES (17902, 6, 12.00, 2, 31);
INSERT INTO public.detalle_venta_online VALUES (17903, 5, 15.50, 3, 31);
INSERT INTO public.detalle_venta_online VALUES (17904, 6, 22.00, 4, 31);
INSERT INTO public.detalle_venta_online VALUES (17905, 5, 6.75, 5, 31);
INSERT INTO public.detalle_venta_online VALUES (17906, 6, 10.25, 6, 31);
INSERT INTO public.detalle_venta_online VALUES (17907, 5, 18.75, 7, 31);
INSERT INTO public.detalle_venta_online VALUES (17908, 6, 25.50, 8, 31);
INSERT INTO public.detalle_venta_online VALUES (17909, 5, 30.00, 9, 31);
INSERT INTO public.detalle_venta_online VALUES (17910, 6, 14.80, 10, 31);
INSERT INTO public.detalle_venta_online VALUES (17911, 7, 8.50, 1, 32);
INSERT INTO public.detalle_venta_online VALUES (17912, 8, 12.00, 2, 32);
INSERT INTO public.detalle_venta_online VALUES (17913, 6, 15.50, 3, 32);
INSERT INTO public.detalle_venta_online VALUES (17914, 7, 22.00, 4, 32);
INSERT INTO public.detalle_venta_online VALUES (17915, 8, 6.75, 5, 32);
INSERT INTO public.detalle_venta_online VALUES (17916, 6, 10.25, 6, 32);
INSERT INTO public.detalle_venta_online VALUES (17917, 7, 18.75, 7, 32);
INSERT INTO public.detalle_venta_online VALUES (17918, 8, 25.50, 8, 32);
INSERT INTO public.detalle_venta_online VALUES (17919, 6, 30.00, 9, 32);
INSERT INTO public.detalle_venta_online VALUES (17920, 7, 14.80, 10, 32);
INSERT INTO public.detalle_venta_online VALUES (17921, 4, 8.50, 1, 33);
INSERT INTO public.detalle_venta_online VALUES (17922, 5, 12.00, 2, 33);
INSERT INTO public.detalle_venta_online VALUES (17923, 4, 15.50, 3, 33);
INSERT INTO public.detalle_venta_online VALUES (17924, 5, 22.00, 4, 33);
INSERT INTO public.detalle_venta_online VALUES (17925, 4, 6.75, 5, 33);
INSERT INTO public.detalle_venta_online VALUES (17926, 5, 10.25, 6, 33);
INSERT INTO public.detalle_venta_online VALUES (17927, 4, 18.75, 7, 33);
INSERT INTO public.detalle_venta_online VALUES (17928, 5, 25.50, 8, 33);
INSERT INTO public.detalle_venta_online VALUES (17929, 4, 30.00, 9, 33);
INSERT INTO public.detalle_venta_online VALUES (17930, 5, 14.80, 10, 33);
INSERT INTO public.detalle_venta_online VALUES (17931, 6, 8.50, 1, 34);
INSERT INTO public.detalle_venta_online VALUES (17932, 5, 12.00, 2, 34);
INSERT INTO public.detalle_venta_online VALUES (17933, 6, 15.50, 3, 34);
INSERT INTO public.detalle_venta_online VALUES (17934, 5, 22.00, 4, 34);
INSERT INTO public.detalle_venta_online VALUES (17935, 6, 6.75, 5, 34);
INSERT INTO public.detalle_venta_online VALUES (17936, 5, 10.25, 6, 34);
INSERT INTO public.detalle_venta_online VALUES (17937, 6, 18.75, 7, 34);
INSERT INTO public.detalle_venta_online VALUES (17938, 5, 25.50, 8, 34);
INSERT INTO public.detalle_venta_online VALUES (17939, 6, 30.00, 9, 34);
INSERT INTO public.detalle_venta_online VALUES (17940, 5, 14.80, 10, 34);
INSERT INTO public.detalle_venta_online VALUES (17941, 7, 8.50, 1, 35);
INSERT INTO public.detalle_venta_online VALUES (17942, 6, 12.00, 2, 35);
INSERT INTO public.detalle_venta_online VALUES (17943, 7, 15.50, 3, 35);
INSERT INTO public.detalle_venta_online VALUES (17944, 6, 22.00, 4, 35);
INSERT INTO public.detalle_venta_online VALUES (17945, 7, 6.75, 5, 35);
INSERT INTO public.detalle_venta_online VALUES (17946, 6, 10.25, 6, 35);
INSERT INTO public.detalle_venta_online VALUES (17947, 7, 18.75, 7, 35);
INSERT INTO public.detalle_venta_online VALUES (17948, 6, 25.50, 8, 35);
INSERT INTO public.detalle_venta_online VALUES (17949, 7, 30.00, 9, 35);
INSERT INTO public.detalle_venta_online VALUES (17950, 6, 14.80, 10, 35);
INSERT INTO public.detalle_venta_online VALUES (17951, 5, 8.50, 1, 36);
INSERT INTO public.detalle_venta_online VALUES (17952, 4, 12.00, 2, 36);
INSERT INTO public.detalle_venta_online VALUES (17953, 5, 15.50, 3, 36);
INSERT INTO public.detalle_venta_online VALUES (17954, 4, 22.00, 4, 36);
INSERT INTO public.detalle_venta_online VALUES (17955, 5, 6.75, 5, 36);
INSERT INTO public.detalle_venta_online VALUES (17956, 4, 10.25, 6, 36);
INSERT INTO public.detalle_venta_online VALUES (17957, 5, 18.75, 7, 36);
INSERT INTO public.detalle_venta_online VALUES (17958, 4, 25.50, 8, 36);
INSERT INTO public.detalle_venta_online VALUES (17959, 5, 30.00, 9, 36);
INSERT INTO public.detalle_venta_online VALUES (17960, 4, 14.80, 10, 36);
INSERT INTO public.detalle_venta_online VALUES (17961, 6, 8.50, 1, 37);
INSERT INTO public.detalle_venta_online VALUES (17962, 5, 12.00, 2, 37);
INSERT INTO public.detalle_venta_online VALUES (17963, 4, 15.50, 3, 37);
INSERT INTO public.detalle_venta_online VALUES (17964, 6, 22.00, 4, 37);
INSERT INTO public.detalle_venta_online VALUES (17965, 5, 6.75, 5, 37);
INSERT INTO public.detalle_venta_online VALUES (17966, 4, 10.25, 6, 37);
INSERT INTO public.detalle_venta_online VALUES (17967, 6, 18.75, 7, 37);
INSERT INTO public.detalle_venta_online VALUES (17968, 5, 25.50, 8, 37);
INSERT INTO public.detalle_venta_online VALUES (17969, 4, 30.00, 9, 37);
INSERT INTO public.detalle_venta_online VALUES (17970, 6, 14.80, 10, 37);
INSERT INTO public.detalle_venta_online VALUES (17971, 7, 8.50, 1, 38);
INSERT INTO public.detalle_venta_online VALUES (17972, 6, 12.00, 2, 38);
INSERT INTO public.detalle_venta_online VALUES (17973, 7, 15.50, 3, 38);
INSERT INTO public.detalle_venta_online VALUES (17974, 6, 22.00, 4, 38);
INSERT INTO public.detalle_venta_online VALUES (17975, 7, 6.75, 5, 38);
INSERT INTO public.detalle_venta_online VALUES (17976, 6, 10.25, 6, 38);
INSERT INTO public.detalle_venta_online VALUES (17977, 7, 18.75, 7, 38);
INSERT INTO public.detalle_venta_online VALUES (17978, 6, 25.50, 8, 38);
INSERT INTO public.detalle_venta_online VALUES (17979, 7, 30.00, 9, 38);
INSERT INTO public.detalle_venta_online VALUES (17980, 6, 14.80, 10, 38);
INSERT INTO public.detalle_venta_online VALUES (17981, 5, 8.50, 1, 39);
INSERT INTO public.detalle_venta_online VALUES (17982, 4, 12.00, 2, 39);
INSERT INTO public.detalle_venta_online VALUES (17983, 5, 15.50, 3, 39);
INSERT INTO public.detalle_venta_online VALUES (17984, 4, 22.00, 4, 39);
INSERT INTO public.detalle_venta_online VALUES (17985, 5, 6.75, 5, 39);
INSERT INTO public.detalle_venta_online VALUES (17986, 4, 10.25, 6, 39);
INSERT INTO public.detalle_venta_online VALUES (17987, 5, 18.75, 7, 39);
INSERT INTO public.detalle_venta_online VALUES (17988, 4, 25.50, 8, 39);
INSERT INTO public.detalle_venta_online VALUES (17989, 5, 30.00, 9, 39);
INSERT INTO public.detalle_venta_online VALUES (17990, 4, 14.80, 10, 39);
INSERT INTO public.detalle_venta_online VALUES (17991, 6, 8.50, 1, 40);
INSERT INTO public.detalle_venta_online VALUES (17992, 7, 12.00, 2, 40);
INSERT INTO public.detalle_venta_online VALUES (17993, 5, 15.50, 3, 40);
INSERT INTO public.detalle_venta_online VALUES (17994, 6, 22.00, 4, 40);
INSERT INTO public.detalle_venta_online VALUES (17995, 7, 6.75, 5, 40);
INSERT INTO public.detalle_venta_online VALUES (17996, 5, 10.25, 6, 40);
INSERT INTO public.detalle_venta_online VALUES (17997, 6, 18.75, 7, 40);
INSERT INTO public.detalle_venta_online VALUES (17998, 7, 25.50, 8, 40);
INSERT INTO public.detalle_venta_online VALUES (17999, 5, 30.00, 9, 40);
INSERT INTO public.detalle_venta_online VALUES (18000, 6, 14.80, 10, 40);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_migrations VALUES (1, 'contenttypes', '0001_initial', '2025-06-20 00:02:49.805529-04');
INSERT INTO public.django_migrations VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2025-06-20 00:02:49.809582-04');
INSERT INTO public.django_migrations VALUES (3, 'auth', '0001_initial', '2025-06-20 00:02:49.835096-04');
INSERT INTO public.django_migrations VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2025-06-20 00:02:49.837839-04');
INSERT INTO public.django_migrations VALUES (5, 'auth', '0003_alter_user_email_max_length', '2025-06-20 00:02:49.840151-04');
INSERT INTO public.django_migrations VALUES (6, 'auth', '0004_alter_user_username_opts', '2025-06-20 00:02:49.84203-04');
INSERT INTO public.django_migrations VALUES (7, 'auth', '0005_alter_user_last_login_null', '2025-06-20 00:02:49.843771-04');
INSERT INTO public.django_migrations VALUES (8, 'auth', '0006_require_contenttypes_0002', '2025-06-20 00:02:49.844274-04');
INSERT INTO public.django_migrations VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2025-06-20 00:02:49.845692-04');
INSERT INTO public.django_migrations VALUES (10, 'auth', '0008_alter_user_username_max_length', '2025-06-20 00:02:49.847006-04');
INSERT INTO public.django_migrations VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2025-06-20 00:02:49.848403-04');
INSERT INTO public.django_migrations VALUES (12, 'auth', '0010_alter_group_name_max_length', '2025-06-20 00:02:49.852233-04');
INSERT INTO public.django_migrations VALUES (13, 'auth', '0011_update_proxy_permissions', '2025-06-20 00:02:49.854-04');
INSERT INTO public.django_migrations VALUES (14, 'auth', '0012_alter_user_first_name_max_length', '2025-06-20 00:02:49.856018-04');
INSERT INTO public.django_migrations VALUES (15, 'store', '0001_initial', '2025-06-20 00:02:50.503542-04');
INSERT INTO public.django_migrations VALUES (16, 'admin', '0001_initial', '2025-06-20 00:02:50.548495-04');
INSERT INTO public.django_migrations VALUES (17, 'admin', '0002_logentry_remove_auto_add', '2025-06-20 00:02:50.550763-04');
INSERT INTO public.django_migrations VALUES (18, 'admin', '0003_logentry_add_action_flag_choices', '2025-06-20 00:02:50.552841-04');
INSERT INTO public.django_migrations VALUES (19, 'admin_interface', '0001_initial', '2025-06-20 00:02:50.556552-04');
INSERT INTO public.django_migrations VALUES (20, 'sessions', '0001_initial', '2025-06-20 00:02:50.559768-04');
INSERT INTO public.django_migrations VALUES (21, 'store', '0002_cliente_fk_usuario_emp_car_fk_usuario_and_more', '2025-06-20 00:29:42.316409-04');
INSERT INTO public.django_migrations VALUES (22, 'store', '0003_remove_cliente_fk_usuario_remove_emp_car_fk_usuario_and_more', '2025-06-20 01:00:23.652003-04');
INSERT INTO public.django_migrations VALUES (23, 'store', '0004_solicitud_compra_fk_usuario_and_more', '2025-06-20 01:22:04.775955-04');


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.django_session VALUES ('r9k4jha7sxcfrgtlu0stpru5b398bobj', '.eJxVjDsOgzAQBe_iOrLWn8UOZXrOgNa7diCJQOJTIe4ekCiS9s282VRL69K165ynthdVK-PQqdvvnIjfeTiZvGh4jprHYZn6pE9FX3TWzSj587jcv0BHc3e87wxIKZNnyS4IiZhoSwxI1jIUjxYEXRSOxYNBQucBvKlixQgB0hFlmhZVb_v-BasuO20:1uSeA6:sV1ZksC7zYFeNPX2dHE8NDIPBMdopTURwQgqoSdQsw8', '2025-07-04 12:00:18.287661-04');


--
-- Data for Name: emp_car; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.emp_car VALUES (521, 1, 1, '2023-01-15', NULL, 1, 1);
INSERT INTO public.emp_car VALUES (522, 2, 2, '2023-02-01', NULL, 2, 2);
INSERT INTO public.emp_car VALUES (523, 3, 3, '2023-01-20', NULL, 5, 3);
INSERT INTO public.emp_car VALUES (524, 4, 4, '2023-03-01', NULL, 10, 4);
INSERT INTO public.emp_car VALUES (525, 5, 5, '2023-01-10', NULL, 8, 5);
INSERT INTO public.emp_car VALUES (526, 6, 6, '2023-02-15', NULL, 3, 6);
INSERT INTO public.emp_car VALUES (527, 7, 7, '2023-01-25', NULL, 4, 7);
INSERT INTO public.emp_car VALUES (528, 8, 8, '2023-02-20', NULL, 7, 8);
INSERT INTO public.emp_car VALUES (529, 9, 9, '2023-03-10', NULL, 9, 9);
INSERT INTO public.emp_car VALUES (530, 10, 10, '2023-01-30', NULL, 6, 10);


--
-- Data for Name: horario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.horario VALUES (1, 'Lunes', '08:00:00', '17:00:00');
INSERT INTO public.horario VALUES (2, 'Martes', '08:00:00', '17:00:00');
INSERT INTO public.horario VALUES (3, 'Miércoles', '08:00:00', '17:00:00');
INSERT INTO public.horario VALUES (4, 'Jueves', '08:00:00', '17:00:00');
INSERT INTO public.horario VALUES (5, 'Viernes', '08:00:00', '17:00:00');
INSERT INTO public.horario VALUES (6, 'Sábado', '09:00:00', '18:00:00');
INSERT INTO public.horario VALUES (7, 'Domingo', '10:00:00', '16:00:00');
INSERT INTO public.horario VALUES (8, 'Lunes', '14:00:00', '22:00:00');
INSERT INTO public.horario VALUES (9, 'Sábado', '08:00:00', '14:00:00');
INSERT INTO public.horario VALUES (10, 'Domingo', '12:00:00', '20:00:00');


--
-- Data for Name: emp_car_hor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.emp_car_hor VALUES (521, 1, 1, 1, 1, 1);
INSERT INTO public.emp_car_hor VALUES (522, 2, 2, 2, 2, 2);
INSERT INTO public.emp_car_hor VALUES (523, 5, 3, 3, 3, 3);
INSERT INTO public.emp_car_hor VALUES (524, 10, 4, 4, 4, 4);
INSERT INTO public.emp_car_hor VALUES (525, 8, 5, 5, 5, 5);
INSERT INTO public.emp_car_hor VALUES (526, 3, 6, 6, 6, 6);
INSERT INTO public.emp_car_hor VALUES (527, 4, 7, 7, 7, 7);
INSERT INTO public.emp_car_hor VALUES (528, 7, 8, 8, 8, 8);
INSERT INTO public.emp_car_hor VALUES (529, 9, 9, 9, 9, 9);
INSERT INTO public.emp_car_hor VALUES (530, 6, 10, 10, 10, 10);


--
-- Data for Name: tipo_beneficio; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_beneficio VALUES (1, 'Bono de Productividad', 'Incentivo económico por cumplimiento de metas de ventas y productividad');
INSERT INTO public.tipo_beneficio VALUES (2, 'Seguro Médico', 'Cobertura médica integral para el empleado y grupo familiar');
INSERT INTO public.tipo_beneficio VALUES (3, 'Bono Vacacional', 'Compensación adicional durante el período de vacaciones anuales');
INSERT INTO public.tipo_beneficio VALUES (4, 'Comisiones por Ventas', 'Porcentaje adicional por ventas realizadas que superen la meta establecida');
INSERT INTO public.tipo_beneficio VALUES (5, 'Capacitación Especializada', 'Cursos y entrenamientos en productos cerveceros y atención al cliente');
INSERT INTO public.tipo_beneficio VALUES (6, 'Transporte', 'Subsidio o reembolso para gastos de transporte al lugar de trabajo');
INSERT INTO public.tipo_beneficio VALUES (7, 'Alimentación', 'Ticket o subsidio para comidas durante la jornada laboral');
INSERT INTO public.tipo_beneficio VALUES (8, 'Bono de Antigüedad', 'Compensación por años de servicio y permanencia en la empresa');
INSERT INTO public.tipo_beneficio VALUES (9, 'Seguro de Vida', 'Póliza de seguro de vida para protección del empleado y beneficiarios');
INSERT INTO public.tipo_beneficio VALUES (10, 'Prima por Responsabilidad', 'Compensación adicional por cargos de supervisión y responsabilidades especiales');


--
-- Data for Name: emp_tip_ben; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.emp_tip_ben VALUES (521, 300000, 1, 1);
INSERT INTO public.emp_tip_ben VALUES (522, 250000, 2, 2);
INSERT INTO public.emp_tip_ben VALUES (523, 150000, 3, 3);
INSERT INTO public.emp_tip_ben VALUES (524, 200000, 4, 4);
INSERT INTO public.emp_tip_ben VALUES (525, 180000, 5, 5);
INSERT INTO public.emp_tip_ben VALUES (526, 120000, 6, 6);
INSERT INTO public.emp_tip_ben VALUES (527, 100000, 7, 7);
INSERT INTO public.emp_tip_ben VALUES (528, 220000, 8, 8);
INSERT INTO public.emp_tip_ben VALUES (529, 160000, 9, 9);
INSERT INTO public.emp_tip_ben VALUES (530, 280000, 10, 10);


--
-- Data for Name: moneda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.moneda VALUES (1, 'BOLIVAR');
INSERT INTO public.moneda VALUES (2, 'DOLAR');
INSERT INTO public.moneda VALUES (3, 'EURO');
INSERT INTO public.moneda VALUES (4, 'YEN');
INSERT INTO public.moneda VALUES (5, 'LIBRA');
INSERT INTO public.moneda VALUES (6, 'FRANCO SUIZO');
INSERT INTO public.moneda VALUES (7, 'PESO MEXICANO');
INSERT INTO public.moneda VALUES (8, 'REAL BRASILEÑO');
INSERT INTO public.moneda VALUES (9, 'PESO ARGENTINO');
INSERT INTO public.moneda VALUES (10, 'RUPIA INDIA');



--
-- Data for Name: historico_moneda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.historico_moneda VALUES (1, '2023-12-31 20:00:00-04', 1.00, 1);
INSERT INTO public.historico_moneda VALUES (2, '2024-05-31 20:00:00-04', 1.00, 1);
INSERT INTO public.historico_moneda VALUES (3, '2024-11-30 20:00:00-04', 1.00, 1);
INSERT INTO public.historico_moneda VALUES (4, '2023-12-31 20:00:00-04', 36.50, 2);
INSERT INTO public.historico_moneda VALUES (5, '2024-05-31 20:00:00-04', 38.20, 2);
INSERT INTO public.historico_moneda VALUES (6, '2024-11-30 20:00:00-04', 40.15, 2);
INSERT INTO public.historico_moneda VALUES (7, '2023-12-31 20:00:00-04', 39.80, 3);
INSERT INTO public.historico_moneda VALUES (8, '2024-05-31 20:00:00-04', 41.50, 3);
INSERT INTO public.historico_moneda VALUES (9, '2024-11-30 20:00:00-04', 43.25, 3);
INSERT INTO public.historico_moneda VALUES (10, '2023-12-31 20:00:00-04', 0.25, 4);
INSERT INTO public.historico_moneda VALUES (11, '2024-05-31 20:00:00-04', 0.26, 4);
INSERT INTO public.historico_moneda VALUES (12, '2024-11-30 20:00:00-04', 0.27, 4);
INSERT INTO public.historico_moneda VALUES (13, '2023-12-31 20:00:00-04', 46.20, 5);
INSERT INTO public.historico_moneda VALUES (14, '2024-05-31 20:00:00-04', 48.10, 5);
INSERT INTO public.historico_moneda VALUES (15, '2024-11-30 20:00:00-04', 50.25, 5);



INSERT INTO public.historico_moneda VALUES (16, '2023-12-31 20:00:00-04', 38.50, 6);
INSERT INTO public.historico_moneda VALUES (17, '2024-05-31 20:00:00-04', 40.20, 6);
INSERT INTO public.historico_moneda VALUES (18, '2024-11-30 20:00:00-04', 42.10, 6);

INSERT INTO public.historico_moneda VALUES (19, '2023-12-31 20:00:00-04', 2.20, 7);
INSERT INTO public.historico_moneda VALUES (20, '2024-05-31 20:00:00-04', 2.45, 7);
INSERT INTO public.historico_moneda VALUES (21, '2024-11-30 20:00:00-04', 2.70, 7);


INSERT INTO public.historico_moneda VALUES (22, '2023-12-31 20:00:00-04', 7.50, 8);
INSERT INTO public.historico_moneda VALUES (23, '2024-05-31 20:00:00-04', 8.00, 8);
INSERT INTO public.historico_moneda VALUES (24, '2024-11-30 20:00:00-04', 8.50, 8);

INSERT INTO public.historico_moneda VALUES (25, '2023-12-31 20:00:00-04', 0.0040, 9); 
INSERT INTO public.historico_moneda VALUES (26, '2024-05-31 20:00:00-04', 0.0045, 9); 
INSERT INTO public.historico_moneda VALUES (27, '2024-11-30 20:00:00-04', 0.0050, 9); 


INSERT INTO public.historico_moneda VALUES (28, '2023-12-31 20:00:00-04', 0.40, 10);
INSERT INTO public.historico_moneda VALUES (29, '2024-05-31 20:00:00-04', 0.42, 10);
INSERT INTO public.historico_moneda VALUES (30, '2024-11-30 20:00:00-04', 0.44, 10);

--
-- Data for Name: historico_precio_punto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.historico_precio_punto VALUES (1, '2023-12-31 20:00:00-04', 1000);
INSERT INTO public.historico_precio_punto VALUES (2, '2024-01-31 20:00:00-04', 1050);
INSERT INTO public.historico_precio_punto VALUES (3, '2024-02-29 20:00:00-04', 1100);
INSERT INTO public.historico_precio_punto VALUES (4, '2024-03-31 20:00:00-04', 1150);
INSERT INTO public.historico_precio_punto VALUES (5, '2024-04-30 20:00:00-04', 1200);
INSERT INTO public.historico_precio_punto VALUES (6, '2024-05-31 20:00:00-04', 1250);
INSERT INTO public.historico_precio_punto VALUES (7, '2024-06-30 20:00:00-04', 1300);
INSERT INTO public.historico_precio_punto VALUES (8, '2024-07-31 20:00:00-04', 1350);


--
-- Data for Name: ingrediente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingrediente VALUES (1, 'Malta Best Malz Pale Ale', 'Malta base para cervezas tipo Ale.');
INSERT INTO public.ingrediente VALUES (2, 'Malta Best Malz Aromatic', 'Malta que aporta un intenso aroma y sabor a malta.');
INSERT INTO public.ingrediente VALUES (3, 'Malta Best Malz Caramel Light', 'Malta caramelo que aporta color y dulzor.');
INSERT INTO public.ingrediente VALUES (4, 'Lúpulo Columbus', 'Lúpulo americano con alto contenido de alfa ácidos, ideal para amargor.');
INSERT INTO public.ingrediente VALUES (5, 'Lúpulo Cascade', 'Lúpulo americano con aroma floral y cítrico.');
INSERT INTO public.ingrediente VALUES (6, 'Levadura Danstar Bry-97', 'Levadura Ale americana que produce perfiles limpios y resalta el lúpulo.');


--
-- Data for Name: instruccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instruccion VALUES (1, 'Macerar toda la malta durante 1 hora a 66 grados Celsius.');
INSERT INTO public.instruccion VALUES (2, 'Realizar el sparging a 76 grados Celsius.');
INSERT INTO public.instruccion VALUES (3, 'Hervir el mosto durante una hora.');
INSERT INTO public.instruccion VALUES (4, 'A los 60 minutos restantes de hervor, añadir 7g de lúpulo Columbus.');
INSERT INTO public.instruccion VALUES (5, 'A los 20 minutos restantes de hervor, añadir 7g de lúpulo Cascade.');
INSERT INTO public.instruccion VALUES (6, 'Al apagar el fuego , añadir 10g de lúpulo Columbus y 30g de lúpulo Cascade.');
INSERT INTO public.instruccion VALUES (7, 'Enfriar el mosto y fermentar a una temperatura entre 18 y 20 grados Celsius.');
INSERT INTO public.instruccion VALUES (8, 'Madurar en botella o en barril durante 4 semanas.');


--
-- Data for Name: metodo_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.metodo_pago VALUES (1, 100, NULL, NULL, NULL, NULL, NULL, NULL, 'EFECTIVO', NULL);
INSERT INTO public.metodo_pago VALUES (2, 50, NULL, NULL, NULL, NULL, NULL, NULL, 'EFECTIVO', NULL);
INSERT INTO public.metodo_pago VALUES (3, 20, NULL, NULL, NULL, NULL, NULL, NULL, 'EFECTIVO', NULL);
INSERT INTO public.metodo_pago VALUES (4, NULL, 1001234567, NULL, NULL, NULL, NULL, NULL, 'CHEQUE', NULL);
INSERT INTO public.metodo_pago VALUES (5, NULL, 1001234568, NULL, NULL, NULL, NULL, NULL, 'CHEQUE', NULL);
INSERT INTO public.metodo_pago VALUES (6, NULL, 1001234569, NULL, NULL, NULL, NULL, NULL, 'CHEQUE', NULL);
INSERT INTO public.metodo_pago VALUES (7, NULL, NULL, 1234567890123456, '2026-12-31', 'Banco de Venezuela', NULL, NULL, 'TARJETA_DEBITO', NULL);
INSERT INTO public.metodo_pago VALUES (8, NULL, NULL, 1234567890123457, '2027-06-30', 'Banesco', NULL, NULL, 'TARJETA_DEBITO', NULL);
INSERT INTO public.metodo_pago VALUES (9, NULL, NULL, 1234567890123458, '2026-09-30', 'Mercantil', NULL, NULL, 'TARJETA_DEBITO', NULL);
INSERT INTO public.metodo_pago VALUES (10, NULL, NULL, NULL, NULL, NULL, 4567890123456789, '2026-12-31', 'TARJETA_CREDITO', NULL);
INSERT INTO public.metodo_pago VALUES (11, NULL, NULL, NULL, NULL, NULL, 4567890123456790, '2027-03-31', 'TARJETA_CREDITO', NULL);
INSERT INTO public.metodo_pago VALUES (12, NULL, NULL, NULL, NULL, NULL, 4567890123456791, '2024-08-31', 'TARJETA_CREDITO', NULL);
INSERT INTO public.metodo_pago VALUES (13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PUNTO', 1);
INSERT INTO public.metodo_pago VALUES (14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PUNTO', 6);
INSERT INTO public.metodo_pago VALUES (15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PUNTO', 3);


--
-- Data for Name: pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pago VALUES (861, 125000.00, '2024-01-15 06:30:00-04', NULL, 1, 1, NULL, 1, NULL);
INSERT INTO public.pago VALUES (862, 156000.00, '2024-01-18 07:45:00-04', NULL, 7, 1, NULL, 2, NULL);
INSERT INTO public.pago VALUES (863, 78500.00, '2024-01-22 10:20:00-04', NULL, 10, 1, NULL, 3, NULL);
INSERT INTO public.pago VALUES (864, 234000.00, '2024-02-01 05:15:00-04', NULL, 4, 1, NULL, 4, NULL);
INSERT INTO public.pago VALUES (865, 98700.00, '2024-02-05 12:30:00-04', NULL, 2, 1, NULL, 5, NULL);
INSERT INTO public.pago VALUES (866, 156800.00, '2024-02-10 08:00:00-04', NULL, 8, 1, NULL, 6, NULL);
INSERT INTO public.pago VALUES (867, 201500.00, '2024-02-15 09:45:00-04', NULL, 11, 1, NULL, 7, NULL);
INSERT INTO public.pago VALUES (868, 87600.00, '2024-02-18 11:20:00-04', NULL, 5, 1, NULL, 8, NULL);
INSERT INTO public.pago VALUES (869, 167500.00, '2024-02-22 06:10:00-04', NULL, 13, 1, NULL, 9, NULL);
INSERT INTO public.pago VALUES (870, 134800.00, '2024-02-25 13:00:00-04', NULL, 9, 1, NULL, 10, NULL);
INSERT INTO public.pago VALUES (871, 145600.00, '2024-01-20 10:30:00-04', NULL, 10, 1, NULL, NULL, 1);
INSERT INTO public.pago VALUES (872, 167800.00, '2024-01-23 12:45:00-04', NULL, 11, 1, NULL, NULL, 2);
INSERT INTO public.pago VALUES (873, 198700.00, '2024-01-26 07:20:00-04', NULL, 7, 1, NULL, NULL, 3);
INSERT INTO public.pago VALUES (874, 189200.00, '2024-01-29 09:15:00-04', NULL, 12, 1, NULL, NULL, 4);
INSERT INTO public.pago VALUES (875, 167500.00, '2024-02-02 11:30:00-04', NULL, 14, 1, NULL, NULL, 5);
INSERT INTO public.pago VALUES (876, 500000.00, '2024-01-10 05:00:00-04', 1, 4, 1, NULL, NULL, NULL);
INSERT INTO public.pago VALUES (877, 750000.00, '2024-01-15 06:30:00-04', 2, 5, 1, NULL, NULL, NULL);
INSERT INTO public.pago VALUES (878, 600000.00, '2024-01-20 10:00:00-04', 3, 6, 1, NULL, NULL, NULL);
INSERT INTO public.pago VALUES (879, 850000.00, '2024-01-25 07:15:00-04', 4, 10, 1, NULL, NULL, NULL);
INSERT INTO public.pago VALUES (880, 450000.00, '2024-01-30 12:45:00-04', 5, 11, 1, NULL, NULL, NULL);


--
-- Data for Name: pago_efectivo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pago_efectivo VALUES (646, 12750.00, '2024-12-01 10:00:00-04', 1, 1);
INSERT INTO public.pago_efectivo VALUES (647, 18600.00, '2024-12-01 11:30:00-04', 2, 2);
INSERT INTO public.pago_efectivo VALUES (648, 15500.00, '2024-12-01 13:00:00-04', 3, 3);
INSERT INTO public.pago_efectivo VALUES (649, 22000.00, '2024-12-01 15:15:00-04', 4, 1);
INSERT INTO public.pago_efectivo VALUES (650, 20625.00, '2024-12-01 17:00:00-04', 5, 2);
INSERT INTO public.pago_efectivo VALUES (651, 28125.00, '2024-12-02 09:45:00-04', 6, 3);
INSERT INTO public.pago_efectivo VALUES (652, 13500.00, '2024-12-02 11:30:00-04', 7, 1);
INSERT INTO public.pago_efectivo VALUES (653, 17000.00, '2024-12-02 14:00:00-04', 8, 2);
INSERT INTO public.pago_efectivo VALUES (654, 25500.00, '2024-12-02 16:30:00-04', 9, 3);
INSERT INTO public.pago_efectivo VALUES (655, 29600.00, '2024-12-03 10:15:00-04', 10, 1);
INSERT INTO public.pago_efectivo VALUES (656, 19250.00, '2024-12-03 12:00:00-04', 11, 2);
INSERT INTO public.pago_efectivo VALUES (657, 24750.00, '2024-12-03 14:45:00-04', 12, 3);
INSERT INTO public.pago_efectivo VALUES (658, 31875.00, '2024-12-03 16:30:00-04', 13, 1);
INSERT INTO public.pago_efectivo VALUES (659, 16200.00, '2024-12-04 09:00:00-04', 14, 2);
INSERT INTO public.pago_efectivo VALUES (660, 27300.00, '2024-12-04 11:45:00-04', 15, 3);


--
-- Data for Name: receta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receta VALUES (1, 'Receta American Amber Ale', 'Receta para elaborar una cerveza estilo American Amber Ale, tipo Todo Grano, basada en la descripción del texto.');
INSERT INTO public.receta VALUES (2, 'Receta Belgian Dubbel', 'Receta para elaborar una cerveza estilo Belgian Dubbel, con maltas oscuras y carácter afrutado típico de las cervezas belgas.');
INSERT INTO public.receta VALUES (3, 'Receta India Pale Ale (IPA)', 'Receta para una IPA clásica, con alto contenido de lúpulo y amargor pronunciado, ideal para los amantes de cervezas intensas.');
INSERT INTO public.receta VALUES (4, 'Receta Munich Helles', 'Receta tradicional alemana para producir una lager clara, suave, con un sutil dulzor de malta.');
INSERT INTO public.receta VALUES (5, 'Receta Stout', 'Receta base para una cerveza Stout con sabor tostado, café y chocolate, de cuerpo medio-alto.');
INSERT INTO public.receta VALUES (6, 'Receta Belgian Saison', 'Receta para una Saison refrescante, seca y especiada, ideal para épocas cálidas y fermentaciones rústicas.');
INSERT INTO public.receta VALUES (7, 'Receta Witbier Belga', 'Receta para una cerveza de trigo belga con cáscara de naranja y cilantro, de aspecto turbio y refrescante.');
INSERT INTO public.receta VALUES (8, 'Receta Porter', 'Receta de Porter clásica, con notas a malta tostada, caramelo y chocolate, menos amarga que una Stout.');


--
-- Data for Name: rec_ing; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rec_ing VALUES (365, 5000.000, 1, 1);
INSERT INTO public.rec_ing VALUES (366, 500.000, 2, 1);
INSERT INTO public.rec_ing VALUES (367, 400.000, 3, 1);
INSERT INTO public.rec_ing VALUES (368, 7.000, 4, 1);
INSERT INTO public.rec_ing VALUES (369, 7.000, 5, 1);
INSERT INTO public.rec_ing VALUES (370, 10.000, 4, 1);
INSERT INTO public.rec_ing VALUES (371, 30.000, 5, 1);


--
-- Data for Name: rec_ins; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rec_ins VALUES (417, 1, 1);
INSERT INTO public.rec_ins VALUES (418, 2, 1);
INSERT INTO public.rec_ins VALUES (419, 3, 1);
INSERT INTO public.rec_ins VALUES (420, 4, 1);
INSERT INTO public.rec_ins VALUES (421, 5, 1);
INSERT INTO public.rec_ins VALUES (422, 6, 1);
INSERT INTO public.rec_ins VALUES (423, 7, 1);
INSERT INTO public.rec_ins VALUES (424, 8, 1);


--
-- Data for Name: sol_com_est; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sol_com_est VALUES (1, '2024-12-01', '2024-12-01', 1, 1);
INSERT INTO public.sol_com_est VALUES (2, '2024-12-01', NULL, 5, 1);
INSERT INTO public.sol_com_est VALUES (3, '2024-12-01', '2024-12-01', 1, 2);
INSERT INTO public.sol_com_est VALUES (4, '2024-12-01', NULL, 5, 2);
INSERT INTO public.sol_com_est VALUES (5, '2024-12-01', '2024-12-01', 1, 3);
INSERT INTO public.sol_com_est VALUES (6, '2024-12-01', NULL, 5, 3);
INSERT INTO public.sol_com_est VALUES (7, '2024-12-01', '2024-12-01', 1, 4);
INSERT INTO public.sol_com_est VALUES (8, '2024-12-01', NULL, 5, 4);
INSERT INTO public.sol_com_est VALUES (9, '2024-12-01', '2024-12-01', 1, 5);
INSERT INTO public.sol_com_est VALUES (10, '2024-12-01', NULL, 5, 5);
INSERT INTO public.sol_com_est VALUES (11, '2024-12-02', '2024-12-02', 1, 6);
INSERT INTO public.sol_com_est VALUES (12, '2024-12-02', NULL, 5, 6);
INSERT INTO public.sol_com_est VALUES (13, '2024-12-02', '2024-12-02', 1, 7);
INSERT INTO public.sol_com_est VALUES (14, '2024-12-02', NULL, 5, 7);
INSERT INTO public.sol_com_est VALUES (15, '2024-12-02', '2024-12-02', 1, 8);
INSERT INTO public.sol_com_est VALUES (16, '2024-12-02', NULL, 5, 8);
INSERT INTO public.sol_com_est VALUES (17, '2024-12-02', '2024-12-02', 1, 9);
INSERT INTO public.sol_com_est VALUES (18, '2024-12-02', NULL, 5, 9);
INSERT INTO public.sol_com_est VALUES (19, '2024-12-03', '2024-12-03', 1, 10);
INSERT INTO public.sol_com_est VALUES (20, '2024-12-03', NULL, 5, 10);
INSERT INTO public.sol_com_est VALUES (21, '2024-12-03', '2024-12-03', 1, 11);
INSERT INTO public.sol_com_est VALUES (22, '2024-12-03', NULL, 4, 11);
INSERT INTO public.sol_com_est VALUES (23, '2024-12-03', '2024-12-03', 1, 12);
INSERT INTO public.sol_com_est VALUES (24, '2024-12-03', NULL, 4, 12);
INSERT INTO public.sol_com_est VALUES (25, '2024-12-03', '2024-12-03', 1, 13);
INSERT INTO public.sol_com_est VALUES (26, '2024-12-03', NULL, 2, 13);
INSERT INTO public.sol_com_est VALUES (27, '2024-12-04', '2024-12-04', 1, 14);
INSERT INTO public.sol_com_est VALUES (28, '2024-12-04', NULL, 2, 14);
INSERT INTO public.sol_com_est VALUES (29, '2024-12-04', '2024-12-04', 1, 15);
INSERT INTO public.sol_com_est VALUES (30, '2024-12-04', NULL, 1, 15);


--
-- Data for Name: solicitud_reposicion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.solicitud_reposicion VALUES (1, '2024-12-01 08:30:00-04', 'Solicitud de reposición urgente para cerveza Destilo 330ml debido a alta demanda', 1, 1, 1);
INSERT INTO public.solicitud_reposicion VALUES (2, '2024-12-01 09:15:00-04', 'Reposición necesaria para Dos Leones 330ml por stock bajo en anaquel', 2, 2, 2);
INSERT INTO public.solicitud_reposicion VALUES (3, '2024-12-01 10:00:00-04', 'Solicitud de restock para Benitz 355ml - inventario crítico', 3, 3, 3);
INSERT INTO public.solicitud_reposicion VALUES (4, '2024-12-01 11:30:00-04', 'Reposición requerida para Mito 330ml por incremento en ventas', 4, 4, 4);
INSERT INTO public.solicitud_reposicion VALUES (5, '2024-12-01 14:00:00-04', 'Solicitud urgente de reposición para Lago 330ml - stock agotado', 5, 5, 5);
INSERT INTO public.solicitud_reposicion VALUES (6, '2024-12-01 15:45:00-04', 'Reposición necesaria para Barricas 750ml por demanda especial', 6, 6, 6);
INSERT INTO public.solicitud_reposicion VALUES (7, '2024-12-01 16:30:00-04', 'Solicitud de restock para Aldarra lata - inventario bajo', 7, 7, 7);
INSERT INTO public.solicitud_reposicion VALUES (8, '2024-12-02 08:00:00-04', 'Reposición requerida para Destilo 500ml por promoción activa', 8, 8, 8);
INSERT INTO public.solicitud_reposicion VALUES (9, '2024-12-02 09:30:00-04', 'Solicitud de reposición para Destilo 1L - alta rotación', 9, 9, 9);
INSERT INTO public.solicitud_reposicion VALUES (10, '2024-12-02 11:00:00-04', 'Restock necesario para Destilo lata por temporada alta', 10, 10, 10);
INSERT INTO public.solicitud_reposicion VALUES (11, '2024-12-02 13:15:00-04', 'Solicitud de reposición para productos premium en anaquel 1', 1, 1, 11);
INSERT INTO public.solicitud_reposicion VALUES (12, '2024-12-02 14:45:00-04', 'Reposición urgente para cerveza artesanal por evento especial', 2, 2, 12);
INSERT INTO public.solicitud_reposicion VALUES (13, '2024-12-02 16:00:00-04', 'Solicitud de restock para presentaciones de 355ml', 3, 3, 13);
INSERT INTO public.solicitud_reposicion VALUES (14, '2024-12-03 08:30:00-04', 'Reposición necesaria para cervezas de temporada', 4, 4, 14);
INSERT INTO public.solicitud_reposicion VALUES (15, '2024-12-03 10:15:00-04', 'Solicitud de reposición para inventario de fin de año', 5, 5, 15);


--
-- Data for Name: sol_rep_est; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sol_rep_est VALUES (1291, '2024-12-01', '2024-12-01', 1, 1);
INSERT INTO public.sol_rep_est VALUES (1292, '2024-12-01', NULL, 2, 1);
INSERT INTO public.sol_rep_est VALUES (1293, '2024-12-01', '2024-12-01', 1, 2);
INSERT INTO public.sol_rep_est VALUES (1294, '2024-12-01', NULL, 4, 2);
INSERT INTO public.sol_rep_est VALUES (1295, '2024-12-01', '2024-12-01', 1, 3);
INSERT INTO public.sol_rep_est VALUES (1296, '2024-12-01', NULL, 2, 3);
INSERT INTO public.sol_rep_est VALUES (1297, '2024-12-01', '2024-12-01', 1, 4);
INSERT INTO public.sol_rep_est VALUES (1298, '2024-12-01', NULL, 5, 4);
INSERT INTO public.sol_rep_est VALUES (1299, '2024-12-01', '2024-12-01', 1, 5);
INSERT INTO public.sol_rep_est VALUES (1300, '2024-12-01', NULL, 4, 5);
INSERT INTO public.sol_rep_est VALUES (1301, '2024-12-01', '2024-12-01', 1, 6);
INSERT INTO public.sol_rep_est VALUES (1302, '2024-12-01', NULL, 2, 6);
INSERT INTO public.sol_rep_est VALUES (1303, '2024-12-01', '2024-12-01', 1, 7);
INSERT INTO public.sol_rep_est VALUES (1304, '2024-12-01', NULL, 4, 7);
INSERT INTO public.sol_rep_est VALUES (1305, '2024-12-02', '2024-12-02', 1, 8);
INSERT INTO public.sol_rep_est VALUES (1306, '2024-12-02', NULL, 5, 8);
INSERT INTO public.sol_rep_est VALUES (1307, '2024-12-02', '2024-12-02', 1, 9);
INSERT INTO public.sol_rep_est VALUES (1308, '2024-12-02', NULL, 2, 9);
INSERT INTO public.sol_rep_est VALUES (1309, '2024-12-02', '2024-12-02', 1, 10);
INSERT INTO public.sol_rep_est VALUES (1310, '2024-12-02', NULL, 4, 10);
INSERT INTO public.sol_rep_est VALUES (1311, '2024-12-02', '2024-12-02', 1, 11);
INSERT INTO public.sol_rep_est VALUES (1312, '2024-12-02', NULL, 5, 11);
INSERT INTO public.sol_rep_est VALUES (1313, '2024-12-02', '2024-12-02', 1, 12);
INSERT INTO public.sol_rep_est VALUES (1314, '2024-12-02', NULL, 2, 12);
INSERT INTO public.sol_rep_est VALUES (1315, '2024-12-02', '2024-12-02', 1, 13);
INSERT INTO public.sol_rep_est VALUES (1316, '2024-12-02', NULL, 4, 13);
INSERT INTO public.sol_rep_est VALUES (1317, '2024-12-03', '2024-12-03', 1, 14);
INSERT INTO public.sol_rep_est VALUES (1318, '2024-12-03', NULL, 2, 14);
INSERT INTO public.sol_rep_est VALUES (1319, '2024-12-03', '2024-12-03', 1, 15);
INSERT INTO public.sol_rep_est VALUES (1320, '2024-12-03', NULL, 4, 15);


--
-- Data for Name: telefono; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.telefono VALUES (941, '+58', 2124567890, NULL, NULL, NULL, 1, NULL);
INSERT INTO public.telefono VALUES (942, '+58', 2434567891, NULL, NULL, NULL, 2, NULL);
INSERT INTO public.telefono VALUES (943, '+58', 2614567892, NULL, NULL, NULL, 3, NULL);
INSERT INTO public.telefono VALUES (944, '+58', 2124567893, NULL, NULL, NULL, 4, NULL);
INSERT INTO public.telefono VALUES (945, '+58', 2514567894, NULL, NULL, NULL, 5, NULL);
INSERT INTO public.telefono VALUES (946, '+58', 2814567895, NULL, NULL, NULL, 6, NULL);
INSERT INTO public.telefono VALUES (947, '+58', 2744567896, NULL, NULL, NULL, 7, NULL);
INSERT INTO public.telefono VALUES (948, '+58', 2124567897, NULL, NULL, NULL, 8, NULL);
INSERT INTO public.telefono VALUES (949, '+58', 2124567898, NULL, NULL, NULL, 9, NULL);
INSERT INTO public.telefono VALUES (950, '+58', 2864567899, NULL, NULL, NULL, 10, NULL);
INSERT INTO public.telefono VALUES (951, '+58', 4141234567, 1, NULL, NULL, NULL, NULL);
INSERT INTO public.telefono VALUES (952, '+58', 4242345678, 2, NULL, NULL, NULL, NULL);
INSERT INTO public.telefono VALUES (953, '+58', 4143456789, 3, NULL, NULL, NULL, NULL);
INSERT INTO public.telefono VALUES (954, '+58', 4244567890, 4, NULL, NULL, NULL, NULL);
INSERT INTO public.telefono VALUES (955, '+58', 4145678901, 5, NULL, NULL, NULL, NULL);
INSERT INTO public.telefono VALUES (956, '+58', 2126789012, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.telefono VALUES (957, '+58', 2617890123, NULL, NULL, NULL, NULL, 2);
INSERT INTO public.telefono VALUES (958, '+58', 2438901234, NULL, NULL, NULL, NULL, 3);
INSERT INTO public.telefono VALUES (959, '+58', 2149012345, NULL, NULL, NULL, NULL, 4);
INSERT INTO public.telefono VALUES (960, '+58', 2120123456, NULL, NULL, NULL, NULL, 5);


--
-- Data for Name: usuario_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: usuario_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: vacacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vacacion VALUES (521, '2024-07-01', '2024-07-15', 1);
INSERT INTO public.vacacion VALUES (522, '2024-08-01', '2024-08-14', 2);
INSERT INTO public.vacacion VALUES (523, '2024-06-15', '2024-06-29', 3);
INSERT INTO public.vacacion VALUES (524, '2024-09-01', '2024-09-10', 4);
INSERT INTO public.vacacion VALUES (525, '2024-07-15', '2024-07-29', 5);
INSERT INTO public.vacacion VALUES (526, '2024-08-15', '2024-08-28', 6);
INSERT INTO public.vacacion VALUES (527, '2024-06-01', '2024-06-14', 7);
INSERT INTO public.vacacion VALUES (528, '2024-09-15', '2024-09-29', 8);
INSERT INTO public.vacacion VALUES (529, '2024-07-01', '2024-07-10', 9);
INSERT INTO public.vacacion VALUES (530, '2024-08-01', '2024-08-15', 10);


--
-- Data for Name: ven_onl_est; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ven_onl_est VALUES (1721, '2024-01-20', '2024-01-21', 5, 1);
INSERT INTO public.ven_onl_est VALUES (1722, '2024-01-23', '2024-01-24', 5, 2);
INSERT INTO public.ven_onl_est VALUES (1723, '2024-01-26', '2024-01-27', 5, 3);
INSERT INTO public.ven_onl_est VALUES (1724, '2024-01-29', '2024-01-30', 5, 4);
INSERT INTO public.ven_onl_est VALUES (1725, '2024-02-02', '2024-02-03', 5, 5);
INSERT INTO public.ven_onl_est VALUES (1726, '2024-02-05', '2024-02-06', 5, 6);
INSERT INTO public.ven_onl_est VALUES (1727, '2024-02-08', '2024-02-09', 5, 7);
INSERT INTO public.ven_onl_est VALUES (1728, '2024-02-11', '2024-02-12', 5, 8);
INSERT INTO public.ven_onl_est VALUES (1729, '2024-02-14', '2024-02-15', 5, 9);
INSERT INTO public.ven_onl_est VALUES (1730, '2024-02-17', '2024-02-18', 5, 10);
INSERT INTO public.ven_onl_est VALUES (1731, '2024-02-20', '2024-02-21', 5, 11);
INSERT INTO public.ven_onl_est VALUES (1732, '2024-02-23', '2024-02-24', 5, 12);
INSERT INTO public.ven_onl_est VALUES (1733, '2024-02-26', '2024-02-27', 5, 13);
INSERT INTO public.ven_onl_est VALUES (1734, '2024-03-01', '2024-03-02', 5, 14);
INSERT INTO public.ven_onl_est VALUES (1735, '2024-03-04', '2024-03-05', 5, 15);
INSERT INTO public.ven_onl_est VALUES (1736, '2024-03-07', '2024-03-08', 5, 16);
INSERT INTO public.ven_onl_est VALUES (1737, '2024-03-10', '2024-03-11', 5, 17);
INSERT INTO public.ven_onl_est VALUES (1738, '2024-03-13', '2024-03-14', 5, 18);
INSERT INTO public.ven_onl_est VALUES (1739, '2024-03-16', '2024-03-17', 5, 19);
INSERT INTO public.ven_onl_est VALUES (1740, '2024-03-19', '2024-03-20', 5, 20);
INSERT INTO public.ven_onl_est VALUES (1741, '2024-03-22', '2024-03-23', 5, 21);
INSERT INTO public.ven_onl_est VALUES (1742, '2024-03-25', '2024-03-26', 5, 22);
INSERT INTO public.ven_onl_est VALUES (1743, '2024-03-28', '2024-03-29', 5, 23);
INSERT INTO public.ven_onl_est VALUES (1744, '2024-03-31', '2024-04-01', 5, 24);
INSERT INTO public.ven_onl_est VALUES (1745, '2024-04-03', '2024-04-04', 5, 25);
INSERT INTO public.ven_onl_est VALUES (1746, '2024-04-06', '2024-04-07', 5, 26);
INSERT INTO public.ven_onl_est VALUES (1747, '2024-04-09', '2024-04-10', 5, 27);
INSERT INTO public.ven_onl_est VALUES (1748, '2024-04-12', '2024-04-13', 5, 28);
INSERT INTO public.ven_onl_est VALUES (1749, '2024-04-15', '2024-04-16', 5, 29);
INSERT INTO public.ven_onl_est VALUES (1750, '2024-04-18', '2024-04-19', 5, 30);
INSERT INTO public.ven_onl_est VALUES (1751, '2024-04-21', '2024-04-22', 5, 31);
INSERT INTO public.ven_onl_est VALUES (1752, '2024-04-24', '2024-04-25', 5, 32);
INSERT INTO public.ven_onl_est VALUES (1753, '2024-04-27', '2024-04-28', 5, 33);
INSERT INTO public.ven_onl_est VALUES (1754, '2024-04-30', '2024-05-01', 5, 34);
INSERT INTO public.ven_onl_est VALUES (1755, '2024-05-03', '2024-05-04', 5, 35);
INSERT INTO public.ven_onl_est VALUES (1756, '2024-05-06', '2024-05-07', 5, 36);
INSERT INTO public.ven_onl_est VALUES (1757, '2024-05-09', '2024-05-10', 5, 37);
INSERT INTO public.ven_onl_est VALUES (1758, '2024-05-12', '2024-05-13', 5, 38);
INSERT INTO public.ven_onl_est VALUES (1759, '2024-05-15', '2024-05-16', 5, 39);
INSERT INTO public.ven_onl_est VALUES (1760, '2024-05-18', '2024-05-19', 5, 40);


--
-- Name: admin_interface_theme_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_interface_theme_id_seq', 1, true);


--
-- Name: afi_est_afi_est_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.afi_est_afi_est_id_seq', 660, true);


--
-- Name: afiliacion_afi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.afiliacion_afi_id_seq', 330, true);


--
-- Name: almacen_alm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.almacen_alm_id_seq', 250, true);


--
-- Name: anaquel_ana_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.anaquel_ana_id_seq', 880, true);


--
-- Name: asistencia_asi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asistencia_asi_id_seq', 530, true);


--
-- Name: asistencia_evento_asi_eve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asistencia_evento_asi_eve_id_seq', 860, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 292, true);


--
-- Name: car_tip_cer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.car_tip_cer_id_seq', 530, true);


--
-- Name: caracteristica_car_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caracteristica_car_id_seq', 300, true);


--
-- Name: cargo_car_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cargo_car_id_seq', 190, true);


--
-- Name: cerv_car_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cerv_car_id_seq', 583, true);


--
-- Name: cerveza_cer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cerveza_cer_id_seq', 210, true);


--
-- Name: cliente_cli_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_cli_id_seq', 641, true);


--
-- Name: contacto_cliente_con_cli_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contacto_cliente_con_cli_id_seq', 320, true);


--
-- Name: contacto_proveedor_con_pro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contacto_proveedor_con_pro_id_seq', 330, true);


--
-- Name: correo_electronico_cor_ele_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.correo_electronico_cor_ele_id_seq', 780, true);


--
-- Name: cuenta_punto_cue_pun_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuenta_punto_cue_pun_id_seq', 570, true);


--
-- Name: dep_tie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dep_tie_id_seq', 530, true);


--
-- Name: departamento_dep_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departamento_dep_id_seq', 180, true);


--
-- Name: detalle_compra_det_com_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_compra_det_com_id_seq', 1980, true);


--
-- Name: detalle_venta_evento_det_ven_eve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_venta_evento_det_ven_eve_id_seq', 903, true);


--
-- Name: detalle_venta_fisica_det_ven_fis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_venta_fisica_det_ven_fis_id_seq', 13600, true);


--
-- Name: detalle_venta_online_det_ven_onl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_venta_online_det_ven_onl_id_seq', 18004, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 73, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 23, true);


--
-- Name: emp_car_hor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emp_car_hor_id_seq', 530, true);


--
-- Name: emp_car_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emp_car_id_seq', 530, true);


--
-- Name: emp_tip_ben_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emp_tip_ben_id_seq', 530, true);


--
-- Name: empleado_emp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleado_emp_id_seq', 200, true);


--
-- Name: estatus_est_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estatus_est_id_seq', 287, true);


--
-- Name: estilo_cerveza_est_cer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estilo_cerveza_est_cer_id_seq', 575, true);


--
-- Name: eve_pro_eve_pro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eve_pro_eve_pro_id_seq', 516, true);


--
-- Name: evento_eve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evento_eve_id_seq', 5375, true);


--
-- Name: existencia_evento_exi_eve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.existencia_evento_exi_eve_id_seq', 946, true);


--
-- Name: historico_moneda_his_mon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historico_moneda_his_mon_id_seq', 570, true);


--
-- Name: historico_precio_punto_his_pre_pun_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historico_precio_punto_his_pre_pun_id_seq', 456, true);


--
-- Name: horario_hor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.horario_hor_id_seq', 210, true);


--
-- Name: ingrediente_ing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingrediente_ing_id_seq', 156, true);


--
-- Name: instruccion_ins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instruccion_ins_id_seq', 224, true);


--
-- Name: inventario_inv_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_inv_id_seq', 320, true);


--
-- Name: lugar_lug_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lugar_lug_id_seq', 72128, true);


--
-- Name: lugar_tienda_lug_tie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lugar_tienda_lug_tie_id_seq', 374, true);


--
-- Name: metodo_pago_met_pag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metodo_pago_met_pag_id_seq', 600, true);


--
-- Name: moneda_mon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moneda_mon_id_seq', 190, true);


--
-- Name: oferta_ofe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oferta_ofe_id_seq', 250, true);


--
-- Name: pago_efectivo_pag_efe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_efectivo_pag_efe_id_seq', 660, true);


--
-- Name: pago_pag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_pag_id_seq', 880, true);


--
-- Name: pre_alm_pre_alm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pre_alm_pre_alm_id_seq', 380, true);


--
-- Name: presentacion_prese_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.presentacion_prese_id_seq', 227, true);


--
-- Name: proveedor_pro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedor_pro_id_seq', 340, true);


--
-- Name: rec_ing_rec_ing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rec_ing_rec_ing_id_seq', 371, true);


--
-- Name: rec_ins_rec_ins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rec_ins_rec_ins_id_seq', 424, true);


--
-- Name: receta_rec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receta_rec_id_seq', 27, true);


--
-- Name: sol_com_est_sol_com_est_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sol_com_est_sol_com_est_id_seq', 1290, true);


--
-- Name: sol_rep_est_sol_rep_est_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sol_rep_est_sol_rep_est_id_seq', 1320, true);


--
-- Name: solicitud_compra_sol_com_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitud_compra_sol_com_id_seq', 540, true);


--
-- Name: solicitud_reposicion_sol_rep_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitud_reposicion_sol_rep_id_seq', 630, true);


--
-- Name: telefono_tel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.telefono_tel_id_seq', 960, true);


--
-- Name: tienda_tie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tienda_tie_id_seq', 150, true);


--
-- Name: tipo_beneficio_tip_ben_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_beneficio_tip_ben_id_seq', 220, true);


--
-- Name: tipo_cerveza_tip_cer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_cerveza_tip_cer_id_seq', 72, true);


--
-- Name: tipo_estilo_cerveza_tip_est_cer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_estilo_cerveza_tip_est_cer_id_seq', 725, true);


--
-- Name: tipo_evento_tip_eve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_evento_tip_eve_id_seq', 602, true);


--
-- Name: usuario_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_groups_id_seq', 1, false);


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 1353, true);


--
-- Name: usuario_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_user_permissions_id_seq', 1, false);


--
-- Name: vacacion_vac_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vacacion_vac_id_seq', 530, true);


--
-- Name: ven_onl_est_ven_onl_est_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ven_onl_est_ven_onl_est_id_seq', 1760, true);


--
-- Name: venta_boleto_evento_ven_bol_eve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_boleto_evento_ven_bol_eve_id_seq', 860, true);


--
-- Name: venta_evento_ven_eve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_evento_ven_eve_id_seq', 860, true);


--
-- Name: venta_fisica_ven_fis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_fisica_ven_fis_id_seq', 1320, true);


--
-- Name: venta_online_ven_onl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_online_ven_onl_id_seq', 1361, true);


--
-- PostgreSQL database dump complete
--

