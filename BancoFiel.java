package aed.bancofiel;

import java.util.Comparator;
import es.upm.aedlib.indexedlist.IndexedList;
import es.upm.aedlib.indexedlist.ArrayIndexedList;


/**
 * Implements the code for the bank application.
 * Implements the client and the "gestor" interfaces.
 */
public class BancoFiel implements ClienteBanco, GestorBanco {

  // NOTAD. No se deberia cambiar esta declaracion.
  public IndexedList<Cuenta> cuentas;

  // NOTAD. No se deberia cambiar esta constructor.
  public BancoFiel() {
    this.cuentas = new ArrayIndexedList<Cuenta>();
  }

  // ----------------------------------------------------------------------
  // Anadir metodos aqui ...
  private int buscarCuenta(String id) {
	  boolean encontrada = false;
	  int res=0;
	  for(int i=0;i<cuentas.size() && !encontrada;i++) {
		  encontrada= cuentas.get(i).getId().equals(id);
		  if(!encontrada)
			  res=-1;
		  else
			  res=i;
	  }
	  
	  
	  return res;
  }
  
  private void insertarCuenta(Cuenta cuenta) {
	  boolean insertado=false;
	  int indice=0;
	  if(cuentas.size()==0) {
		  cuentas.add(0, cuenta);
	  }
	  else {
		  while(!insertado && indice<cuentas.size()) {
			  if(cuenta.getId().compareTo(cuentas.get(indice).getId())<0) 
				  indice++;
			  else { 
				  insertado=true;
				  cuentas.add(indice, cuenta);
			  }
		  
		  }
		  if(!insertado)
			  cuentas.add(cuentas.size(), cuenta);
	  }
	  
  }
  
  private Cuenta buscarCuentaIndice(int indice) {
	  return cuentas.get(indice);
  }




  // ----------------------------------------------------------------------
  // NOTAD. No se deberia cambiar este metodo.
  public String toString() {
    return "banco";
  }

@Override
public IndexedList<Cuenta> getCuentasOrdenadas(Comparator<Cuenta> cmp) {
	// TODO Auto-generated method stub
	IndexedList<Cuenta> cuentasOrdenadas=new ArrayIndexedList<Cuenta>();
		
	for(int i=0;i<cuentas.size();i++) {
		boolean ordenada=false;
		for(int j=0;j<cuentasOrdenadas.size() && !ordenada;j++) {
			if(cmp.compare(cuentas.get(i), cuentasOrdenadas.get(j))<0) {
				cuentasOrdenadas.add(j, cuentas.get(i));
				ordenada=true;
			}
		}
		
		if(!ordenada) 
			cuentasOrdenadas.add(cuentasOrdenadas.size(), cuentas.get(i));
	
	}

	return cuentasOrdenadas;
}

@Override
public String crearCuenta(String dni, int saldoIncial) {
	// TODO Auto-generated method stub
	Cuenta nuevaCuenta= new Cuenta(dni, saldoIncial);
	insertarCuenta(nuevaCuenta);
	return nuevaCuenta.getId();
}

@Override
public void borrarCuenta(String id) throws CuentaNoExisteExc, CuentaNoVaciaExc {
	// TODO Auto-generated method stub
	int numCuenta=buscarCuenta(id);
	if(numCuenta<0) 
		throw new CuentaNoExisteExc();
	else if(buscarCuentaIndice(numCuenta).getSaldo()>0) 
		throw new CuentaNoVaciaExc();
	else {
		cuentas.removeElementAt(numCuenta);
	}
	
	
}

@Override
public int ingresarDinero(String id, int cantidad) throws CuentaNoExisteExc {
	// TODO Auto-generated method stub
	
	int numCuenta=buscarCuenta(id);
	if(numCuenta<0) 
		throw new CuentaNoExisteExc();
	else {
		buscarCuentaIndice(numCuenta).ingresar(cantidad);
	}
	
	
	return buscarCuentaIndice(numCuenta).getSaldo();
}

@Override
public int retirarDinero(String id, int cantidad) throws CuentaNoExisteExc, InsuficienteSaldoExc {
	// TODO Auto-generated method stub
	int numCuenta=buscarCuenta(id);
	if(numCuenta<0) 
		throw new CuentaNoExisteExc();
	else if(buscarCuentaIndice(numCuenta).getSaldo()<cantidad) 
		throw new InsuficienteSaldoExc();
	else {
		buscarCuentaIndice(numCuenta).retirar(cantidad);
	}
	
	
	return buscarCuentaIndice(numCuenta).getSaldo();
	
}

@Override
public int consultarSaldo(String id) throws CuentaNoExisteExc {
	// TODO Auto-generated method stub
	int numCuenta=buscarCuenta(id);
	if(numCuenta<0) 
		throw new CuentaNoExisteExc();
		
	return buscarCuentaIndice(numCuenta).getSaldo();
	
}

@Override
public void hacerTransferencia(String idFrom, String idTo, int cantidad)
		throws CuentaNoExisteExc, InsuficienteSaldoExc {
	// TODO Auto-generated method stub
	int numCuentaFrom=buscarCuenta(idFrom);
	int numCuentaTo=buscarCuenta(idTo);
	if(numCuentaFrom<0||numCuentaTo<0)
		throw new CuentaNoExisteExc();
	else if(buscarCuentaIndice(numCuentaFrom).getSaldo()<cantidad)
		throw new InsuficienteSaldoExc();
	else {
		buscarCuentaIndice(numCuentaFrom).retirar(cantidad);
		buscarCuentaIndice(numCuentaTo).ingresar(cantidad);
	}
	
	
}

@Override
public IndexedList<String> getIdCuentas(String dni) {
	// TODO Auto-generated method stub
	IndexedList<String> idCuentas= new ArrayIndexedList<String>();
	int posIdCuentas=0;
	for(int i=0;i<cuentas.size();i++) {
		if(buscarCuentaIndice(i).getDNI().equals(dni)) {
			idCuentas.add(posIdCuentas, buscarCuentaIndice(i).getId());
			posIdCuentas++;
		}	
	}
	
	return idCuentas;
}

@Override
public int getSaldoCuentas(String dni) {
	// TODO Auto-generated method stub
	
	int saldoTotal=0;
	for(int i=0;i<cuentas.size();i++) {
		if(buscarCuentaIndice(i).getDNI().equals(dni)) {
			saldoTotal+=buscarCuentaIndice(i).getSaldo();
		}	
	}
	
	return saldoTotal;
	
}
  
}



