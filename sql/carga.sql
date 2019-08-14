delete from BD_POWER_BI.TB_SEI_ESTATISTICAS;
delete from BD_POWER_BI.PROCESSOS_CRIADOS;
delete from BD_POWER_BI.PROCESSOS_ENVIADOS;
delete from BD_POWER_BI.PROCESSOS_RECEBIDOS;
delete from BD_POWER_BI.DOCUMENTOS_CRIADOS;
delete from BD_POWER_BI.DOCUMENTOS_ASSINADOS;
delete from BD_POWER_BI.TEMPO_MEDIO;
delete from BD_POWER_BI.PROCESSOS_RECEBIDOS_BARRAMENTO;
delete from BD_POWER_BI.PROCESSOS_ENVIADOS_BARRAMENTO;
delete from BD_POWER_BI.ASSINATURAS_EXTERNAS;
delete from BD_POWER_BI.ACESSO_EXTERNO_PROCESSO;
delete from BD_POWER_BI.USUARIOS_ATIVOS;
delete from BD_POWER_BI.ESTATISTICA_TIPO_PROCESSO;
delete from BD_POWER_BI.UNIDADES;
delete from BD_POWER_BI.DATA_ATUALIZACAO;

insert into BD_POWER_BI.TB_SEI_ESTATISTICAS(unidade, atividade, data, total)
select u.sigla unidade, 
case t.nome
when 'Processo recebido na unidade' then 'PROCESSOS RECEBIDOS'
when 'Assinado Documento @DOCUMENTO@ por @USUARIO@' then 'DOCUMENTOS ASSINADOS'
when 'Processo remetido pela unidade @UNIDADE@' then 'PROCESSOS ENVIADOS'
when 'Gerado documento @NIVEL_ACESSO@@GRAU_SIGILO@ @DOCUMENTO@@HIPOTESE_LEGAL@' then 'DOCUMENTOS CRIADOS'
when 'Processo @NIVEL_ACESSO@@GRAU_SIGILO@ gerado@DATA_AUTUACAO@@HIPOTESE_LEGAL@' then 'PROCESSOS CRIADOS'
END ATIVIDADE,
date(a.DTH_ABERTURA) data, count(DISTINCT a.ID_PROTOCOLO) total
from sei.atividade a 
join sei.unidade u on u.id_unidade = a.ID_UNIDADE_ORIGEM
join sei.tarefa t on t.id_tarefa = a.id_tarefa
where a.id_tarefa in (32,48,1,5,2) 
group by u.sigla, date(a.DTH_ABERTURA), t.NOME
order by u.sigla, date(a.DTH_ABERTURA) asc;


insert into BD_POWER_BI.PROCESSOS_CRIADOS(unidade, data, total)
select unidade, data, total from BD_POWER_BI.TB_SEI_ESTATISTICAS
where atividade = 'PROCESSOS CRIADOS';

insert into BD_POWER_BI.PROCESSOS_ENVIADOS(unidade, data, total)
select unidade, data, total from BD_POWER_BI.TB_SEI_ESTATISTICAS
where atividade = 'PROCESSOS ENVIADOS';

insert into BD_POWER_BI.PROCESSOS_RECEBIDOS(unidade, data, total)
select unidade, data, total from BD_POWER_BI.TB_SEI_ESTATISTICAS
where atividade = 'PROCESSOS RECEBIDOS';

insert into BD_POWER_BI.DOCUMENTOS_CRIADOS(unidade, data, total)
select unidade, data, total from BD_POWER_BI.TB_SEI_ESTATISTICAS
where atividade = 'DOCUMENTOS CRIADOS';

insert into BD_POWER_BI.DOCUMENTOS_ASSINADOS(unidade, data, total)
select unidade, data, total from BD_POWER_BI.TB_SEI_ESTATISTICAS
where atividade = 'DOCUMENTOS ASSINADOS';

insert into BD_POWER_BI.TEMPO_MEDIO(unidade, total)
select sigla, avg(tempo) tempo
from
(
    select sigla, processo, sum(tempo) tempo
    from
    (
        select u.sigla, p.protocolo_formatado processo,     
        TIMESTAMPDIFF(DAY,a.DTH_abertura,ifnull(a.DTH_CONCLUSAO, sysdate())) tempo
        from sei.atividade a
        join sei.unidade u on u.id_unidade = a.id_unidade
        join sei.protocolo p on p.id_protocolo = a.id_protocolo
    ) aux group by sigla, processo
) aux2 group by sigla;

insert into BD_POWER_BI.PROCESSOS_RECEBIDOS_BARRAMENTO(data, total)
select date(a.DTH_ABERTURA) data, count(distinct a.id_protocolo) total
from sei.atividade a 
where a.id_tarefa = '1012'
group by date(a.DTH_ABERTURA);

insert into BD_POWER_BI.PROCESSOS_ENVIADOS_BARRAMENTO(data, total)
select date(a.DTH_ABERTURA) data, count(distinct a.id_protocolo) total
from sei.atividade a 
where a.id_tarefa = '1015'
group by date(a.DTH_ABERTURA);

insert into BD_POWER_BI.ASSINATURAS_EXTERNAS(unidade, data, total)
select u.sigla unidade, date(a.DTH_ABERTURA) data, count(distinct a.id_protocolo) total
from sei.atividade a 
join sei.unidade u on u.id_unidade = a.id_unidade
where a.id_tarefa = '86'
group by u.sigla, date(a.DTH_ABERTURA);

insert into BD_POWER_BI.ACESSO_EXTERNO_PROCESSO(unidade, data, total)
select u.sigla unidade, date(a.DTH_ABERTURA) data, count(distinct a.id_protocolo) total
from sei.atividade a 
join sei.unidade u on u.id_unidade = a.id_unidade
where a.id_tarefa = '50'
group by u.sigla, date(a.DTH_ABERTURA);

insert into BD_POWER_BI.USUARIOS_ATIVOS(unidade,usuario, data, total)
select u.sigla unidade, 
us.sigla usuario,
date(a.DTH_ABERTURA) data,
count(distinct a.id_usuario_origem) total
from sei.atividade a
join sei.unidade u on u.id_unidade = a.id_unidade_origem
join sei.usuario us on us.id_usuario = a.id_usuario_origem
where us.sta_tipo = '0'
group by u.sigla, us.sigla, date(a.DTH_ABERTURA);

insert into BD_POWER_BI.DATA_ATUALIZACAO
select max(dth_abertura) from sei.atividade;

insert into BD_POWER_BI.ESTATISTICA_TIPO_PROCESSO (tipo_processo, nivel_acesso, total)
select 
tipo.nome tipo_processo,
case p.STA_NIVEL_ACESSO_GLOBAL
when '0' then 'PUBLICO'
when '1' then 'RESTRITO'
when '2' then 'SIGILOSO'
END nivel_acesso,
count(distinct p.id_protocolo) total
from
sei.protocolo p
join sei.procedimento pp on pp.id_procedimento = p.ID_PROTOCOLO
join sei.tipo_procedimento tipo on tipo.ID_TIPO_PROCEDIMENTO = pp.ID_TIPO_PROCEDIMENTO
group by tipo.nome, p.STA_NIVEL_ACESSO_GLOBAL;

-- NECESSITA DE ACESSO às tabelas do SIP

-- insert into BD_POWER_BI.unidades(sigla, raiz)
-- select upper(u.sigla),
-- connect_by_root(upper(u.descricao)) raiz
-- from bd_sip_ref_v2.rel_hierarquia_unidade h
-- primeiro pegando as unidade que estão ativas e na hierarquia
-- join sei.unidade u on h.id_unidade = u.id_unidade
-- where exists 
-- (
--     select id_unidade from sei.atividade 
--     where id_unidade = u.id_unidade and id_tarefa in (32,48,1,5,2)
-- )
-- and u.sin_ativo = 'S'
-- START WITH h.id_unidade_pai is null  
-- CONNECT BY NOCYCLE PRIOR h.id_unidade = h.id_unidade_pai;

-- depois unidades sem hierarquia ou desativadas
-- insert into BD_POWER_BI.unidades(sigla, raiz)
-- select upper(u.sigla),
-- 'DESATIVADAS' raiz
-- from sei.unidade u 
-- where exists 
-- (
--     select id_unidade from sei.atividade 
--     where id_unidade = u.id_unidade and id_tarefa in (32,48,1,5,2)
-- )
-- and u.id_unidade not in (select id_unidade from bd_sip_ref_v2.rel_hierarquia_unidade);


insert into BD_POWER_BI.TEMPO_MEDIO_TIPO_PROCESSO
select unidade, tipo_processo, nivel_acesso, avg(tempo) tempo
from (
    select unidade, tipo_processo, processo, nivel_acesso, sum(tempo) tempo 
    from (  
            select 
            u.sigla unidade,
            tipo.nome tipo_processo,
            p.id_protocolo processo,
            case p.STA_NIVEL_ACESSO_GLOBAL
            when '0' then 'PUBLICO'
            when '1' then 'RESTRITO'
            when '2' then 'SIGILOSO'
            END nivel_acesso,
            TIMESTAMPDIFF(DAY,a.DTH_abertura,ifnull(a.DTH_CONCLUSAO, sysdate())) tempo
            from sei.atividade a
            join sei.protocolo p on p.id_protocolo = a.id_protocolo
            join sei.procedimento pp on pp.id_procedimento = p.id_protocolo
            join sei.tipo_procedimento tipo on tipo.id_tipo_procedimento = pp.id_tipo_procedimento
            join sei.unidade u on u.id_unidade = a.id_unidade 
    ) tb1
    group by processo, unidade, tipo_processo, nivel_acesso
) tb2 where tb2.tempo > 1
group by unidade, tipo_processo, nivel_acesso;

CREATE TABLE unidade AS
SELECT distinct( UPPER(cri.unidade) ) sigla
FROM bd_power_bi.processos_enviados env, 
bd_power_bi.processos_criados cri, 
bd_power_bi.processos_recebidos rec where 
env.unidade=cri.unidade 
or env.unidade=rec.unidade 
or rec.unidade = cri.unidade

insert into BD_POWER_BI.MEDIA_TRAMITE_TIPO_PROCESSO
select tb1.tipo tipo_processo, truncate(avg(tb1.tramite), 0) total
from (
    select a.id_protocolo, tp.nome tipo, count(distinct a.id_unidade) tramite
    from sei.atividade a 
    join sei.procedimento p on p.ID_PROCEDIMENTO = a.id_protocolo
    join sei.TIPO_PROCEDIMENTO tp on tp.ID_TIPO_PROCEDIMENTO = p.ID_TIPO_PROCEDIMENTO
    where a.id_tarefa = 32
    group by a.id_protocolo, tp.nome
) tb1 
group by tb1.tipo;