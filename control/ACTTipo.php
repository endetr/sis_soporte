<?php
/**
*@package pXP
*@file gen-ACTTipo.php
*@author  (eddy.gutierrez)
*@date 28-02-2019 16:38:04
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
	ISUE				FECHA				AUTHOR					DESCRIPCION	
 	#8					18/03/2019			EGS						Se agrega el poder de editar el tipo y recarga los subtipos correspondientes
 *  #10 EndeEtr		  1/07/2019			    EGS					    se agrego parametros para combo
 *  #17                 15/01/2020          EGS                     se agrega filtro para estado reg
*/

class ACTTipo extends ACTbase{    
			
	function listarTipo(){
		$this->objParam->defecto('ordenacion','id_tipo');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->parametros_consulta['cantidad'] = '10000';	// #10
		$this->objParam->parametros_consulta['puntero'] = '0';		//#10
		
		//#8
		if($this->objParam->getParametro('id_tipo')!= '' ){
		    $this->objParam->addFiltro("tipsop.id_tipo =" . $this->objParam->getParametro('id_tipo')." ");
		};
		
		if($this->objParam->getParametro('tipo')== 'si' ){
			$this->objParam->addFiltro("tipsop.id_tipo_fk is null");		
		};
			
		if($this->objParam->getParametro('tipo')=='no' ){
			$this->objParam->addFiltro("tipsop.id_tipo_fk = ". $this->objParam->getParametro('id_tipo_fk')." ");
					
		};	//#8
        if($this->objParam->getParametro('estado_reg')!='' ){//#17
            $this->objParam->addFiltro("tipsop.estado_reg = ''". $this->objParam->getParametro('estado_reg')."'' ");

        };
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipo','listarTipo');
		} else{
			$this->objFunc=$this->create('MODTipo');
			
			$this->res=$this->objFunc->listarTipo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipo(){
		$this->objFunc=$this->create('MODTipo');	
		if($this->objParam->insertar('id_tipo')){
			$this->res=$this->objFunc->insertarTipo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipo(){
			$this->objFunc=$this->create('MODTipo');	
		$this->res=$this->objFunc->eliminarTipo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function activarInactivarTipo(){
        $this->objFunc=$this->create('MODTipo');
        $this->res=$this->objFunc->activarInactivarTipo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>