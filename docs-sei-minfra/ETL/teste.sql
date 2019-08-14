select 
tb1.sigla, 
tb5.processos_gerados,
tb1.recebido, 
tb2.enviado,
tb3.documentos_gerados,
tb4.documentos_assinados

from

(
      select u.sigla, count(distinct a.id_protocolo) recebido
      from bd_sei_ref_v2.atividade a
      join bd_sei_ref_v2.unidade u on u.id_unidade = a.id_unidade 
      where a.id_tarefa = '32' 
      group by u.sigla
) tb1 

join

(
      select u.sigla, count(distinct a.id_protocolo) enviado
      from bd_sei_ref_v2.atividade a
      join bd_sei_ref_v2.unidade u on u.id_unidade = a.id_unidade_origem 
      where a.id_tarefa = '32'
      group by u.sigla
) tb2

on tb1.sigla = tb2.sigla

join

(
      select u.sigla, count(distinct a.id_protocolo) documentos_gerados
      from bd_sei_ref_v2.atividade a
      join bd_sei_ref_v2.unidade u on u.id_unidade = a.id_unidade
      where a.id_tarefa = '2'
      group by u.sigla
) tb3

on tb1.sigla = tb3.sigla

join

(
      select u.sigla, count(distinct a.id_protocolo) documentos_assinados
      from bd_sei_ref_v2.atividade a
      join bd_sei_ref_v2.unidade u on u.id_unidade = a.id_unidade 
      where a.id_tarefa = '5'
      group by u.sigla
) tb4

on tb1.sigla = tb4.sigla

join

(
      select u.sigla, count(distinct a.id_protocolo) processos_gerados
      from bd_sei_ref_v2.atividade a
      join bd_sei_ref_v2.unidade u on u.id_unidade = a.id_unidade
      where a.id_tarefa = '1'
      group by u.sigla
) tb5

on tb1.sigla = tb5.sigla

order by tb1.sigla
;
