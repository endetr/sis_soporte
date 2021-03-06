CREATE OR REPLACE FUNCTION sopte.ft_tipo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Soporte
 FUNCION: 		sopte.ft_tipo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sopte.ttipo'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        28-02-2019 16:38:04
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				28-02-2019 16:38:04								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sopte.ttipo'	
 #
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
                
BEGIN

    v_nombre_funcion = 'sopte.ft_tipo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'SOPTE_TIPSOP_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        eddy.gutierrez    
     #FECHA:        28-02-2019 16:38:04
    ***********************************/

    if(p_transaccion='SOPTE_TIPSOP_SEL')then
                     
        begin
            --Sentencia de la consulta
            v_consulta:='select
                        tipsop.id_tipo,
                        tipsop.codigo,
                        tipsop.estado_reg,
                        tipsop.id_tipo_fk,
                        tipsop.descripcion,
                        tipsop.fecha_reg,
                        tipsop.usuario_ai,
                        tipsop.id_usuario_reg,
                        tipsop.id_usuario_ai,
                        tipsop.fecha_mod,
                        tipsop.id_usuario_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        tipsop.nombre    
                        from sopte.ttipo tipsop
                        inner join segu.tusuario usu1 on usu1.id_usuario = tipsop.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = tipsop.id_usuario_mod
                        where  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;
                        
        end;

    /*********************************    
     #TRANSACCION:  'SOPTE_TIPSOP_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        eddy.gutierrez    
     #FECHA:        28-02-2019 16:38:04
    ***********************************/

    elsif(p_transaccion='SOPTE_TIPSOP_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_tipo)
                        from sopte.ttipo tipsop
                        inner join segu.tusuario usu1 on usu1.id_usuario = tipsop.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = tipsop.id_usuario_mod
                        where ';
            
            --Definicion de la respuesta            
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
                    
    else
                         
        raise exception 'Transaccion inexistente';
                             
    end if;
                    
EXCEPTION
                    
    WHEN OTHERS THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
            v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
            raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;