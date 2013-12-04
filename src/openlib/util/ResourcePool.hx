package openlib.util;

/**
 * ...
 * @author ...
 */
class ResourcePool<T>  {
    private var m_newItemFunction : ( Void -> T );
	private var m_disposeItemFunction : ( T -> Void );
    private var m_free : Array<T>;
    
    public function new( size : Int, newItemFunction : Void -> T, disposeItemFunction :  T -> Void ) {
        m_newItemFunction = newItemFunction;
		m_disposeItemFunction = disposeItemFunction;
        m_free = new Array<T>();
        var i : Int; var item : T;
        for ( i in 0...size ) {
            item = m_newItemFunction();
            m_free.push( item ); 
		}
	}
    
    public function free( obj : T ) : Void { 
		m_free.push( obj );   
	}
    
    public function getItem() : T {
        if ( m_free.length > 0 ) {
            return m_free.pop();
        } else {
            var item : T = m_newItemFunction();
            return item; 
		}
	}
	
	  public function getRandomItem() : T {
        if ( m_free.length > 0 ) {
            swap( m_free, Math.ceil(Math.random() * m_free.length), m_free.length - 1);
			return m_free.pop();
        } else {
            var item : T = m_newItemFunction();
            return item; 
		}
	}
	
	function swap(m_free:Array<T>, indx:Int, last:Int) 
	{
		if (indx == last) return;
		var tmp:T = m_free[indx];
		m_free[indx] = m_free[last];
		m_free[last] = tmp;
	}
	
	public function dispose():Void {
		for ( item in m_free) {
			m_disposeItemFunction( item );
		}
		m_free = null;
	}
}