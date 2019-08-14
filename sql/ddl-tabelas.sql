
CREATE TABLE BD_POWER_BI.UNIDADES
   (
    sigla VARCHAR(50), 
    raiz VARCHAR(200)
    );



CREATE TABLE BD_POWER_BI.TB_SEI_ESTATISTICAS
   (
    unidade VARCHAR(50), 
    atividade VARCHAR(50),
	data DATETIME, 	
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.TEMPO_MEDIO_TIPO_PROCESSO
   ( 
    unidade VARCHAR(50), 
    tipo_processo VARCHAR(200), 
    nivel_acesso VARCHAR(10), 
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.ESTATISTICA_TIPO_PROCESSO
   ( 
    tipo_processo VARCHAR(200), 
    nivel_acesso VARCHAR(10),  
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.DATA_ATUALIZACAO
   ( 
    data datetime
    );


CREATE TABLE BD_POWER_BI.USUARIOS_ATIVOS
   ( 
    unidade VARCHAR(50), 
    usuario VARCHAR(50),
    data datetime,  
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.ACESSO_EXTERNO_PROCESSO
   ( 
    unidade VARCHAR(50), 
    data datetime,  
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.ASSINATURAS_EXTERNAS
   ( 
    unidade VARCHAR(50), 
    data datetime,  
    total BIGINT
    );
	

CREATE TABLE BD_POWER_BI.PROCESSOS_ENVIADOS_BARRAMENTO
   ( 
    data datetime,  
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.PROCESSOS_RECEBIDOS_BARRAMENTO
   ( 
    data datetime,  
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.TEMPO_MEDIO
   (
    unidade VARCHAR(50),  
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.PROCESSOS_CRIADOS
   (
    unidade VARCHAR(50),  
	data DATETIME, 
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.PROCESSOS_RECEBIDOS
   (
    unidade VARCHAR(50),  
	data DATETIME, 
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.PROCESSOS_ENVIADOS
   (
    unidade VARCHAR(50),  
	data DATETIME, 
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.DOCUMENTOS_CRIADOS
   (
    unidade VARCHAR(50),  
	data DATETIME, 
    total BIGINT
    );


CREATE TABLE BD_POWER_BI.DOCUMENTOS_ASSINADOS
   (
    unidade VARCHAR(50),  
	data DATETIME, 
    total BIGINT
    );

CREATE TABLE BD_POWER_BI.MEDIA_TRAMITE_TIPO_PROCESSO
   (  
    tipo_processo VARCHAR(200), 
    total BIGINT
    );