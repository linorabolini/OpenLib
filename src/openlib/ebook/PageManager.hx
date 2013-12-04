package openlib.ebook;
import haxe.Json;
import flash.Assets;
import flash.display.DisplayObjectContainer;
import flash.Lib;
import openlib.tasks.Func;
import openlib.tasks.Task;
import openlib.tasks.TaskContainer;
import openlib.tasks.TimeBasedTask;

/**
 * ...
 * @author 
 */
class PageManager
{
		
	static public var PAGES_BASE_DIRECTORY:String = "";
	
	private var _currentPageIndx:Int;
	private var _currentPageScript:PageScript;
	private var _pageIndex:Map<Int, String>;
	private var _pagesCount:Int;
	private var _currentPageName:String;
	private var _started:Bool;
	
	public var tasks:TaskContainer;
	
	private var createPageScriptFunction:String->PageScript;
	var _container:DisplayObjectContainer;

	public function new(container, ?createPageScriptFunction:String->PageScript) 
	{
		// setup the page script constructor function
		this.createPageScriptFunction = createPageScriptFunction == null ? createPageScript : createPageScriptFunction;
		
		// set the container
		_container = container;
		// lala
		
		// init tasks
		tasks = new TaskContainer();
		tasks.start();
	}
	
	public function start() 
	{
		_started = true;
		gotoPage(0);
	}
	
	public function dispose() 
	{
		disposeCurrentPage();
		_pageIndex = null;
		_container = null;
		tasks.dispose();
		tasks = null;
	}
	
	public function setPages(pages:Array<String>) 
	{
		_pageIndex = new Map<Int, String>();
		
		var idx = 0;
		
		for (page in pages)
			_pageIndex.set(idx++, page);
		
		_pagesCount = idx;
	}
	
	public function getCurrentPage():Int
	{
		return _currentPageIndx;
	}
	
	public function getPageScript():PageScript
	{
		return _currentPageScript;
	}
		
	public function previousPage() 
	{
		gotoPage(_currentPageIndx - 1);
	}
	
	public function nextPage() 
	{
		gotoPage(_currentPageIndx + 1);
	}
	
	public function getCurrentPageName():String
	{
		return _currentPageName;
	}
	
	public function gotoPage(indx:Int) 
	{
		disposeCurrentPage();
		
		setCurrentPageIndx(indx);
		
		_currentPageName = _pageIndex.get(_currentPageIndx);
		
		_currentPageScript = createPageScriptFunction(_currentPageName);
		
		_currentPageScript.load(_container);
	}
	
	public function update(dt:Float) 
	{
		if (_currentPageScript != null)
			_currentPageScript.update(cast dt);
		
		tasks.update(cast dt);
	}
	
	function disposeCurrentPage() :Void
	{
		if (_currentPageScript != null)
			_currentPageScript.dispose();
			
		EntityManager.dispose();
	}
	
	function setCurrentPageIndx(indx:Int) 
	{
		_currentPageIndx = indx;
		if (_currentPageIndx < 0) _currentPageIndx = _pagesCount - 1;
		if (_currentPageIndx >= _pagesCount ) _currentPageIndx = 0;
	}
	
	public function getNextPageName():String
	{
		var idx = _started ? getNextPageIndex(): 0;
		
		return _pageIndex.get(idx);
	}
	
	public function getPreviousPageName():String
	{
		var idx = _started ? getPreviousPageIndex(): _pagesCount - 1;
		
		return _pageIndex.get(idx);
	}
	
	private function getNextPageIndex():Int
	{
		var idx = _currentPageIndx + 1;
		
		if (idx >= _pagesCount ) idx = 0;
		
		return idx;
	}
	
	private function getPreviousPageIndex():Int
	{
		var idx = _currentPageIndx - 1;
		
		if (idx < 0) idx = _pagesCount - 1;
		
		return idx;
	}
	
	function createPageScript(name:String):PageScript
	{
		var page:EBookPageFormat = Json.parse(Assets.getText(PAGES_BASE_DIRECTORY + name + ".json"));
		
		return new PageScript(page);
	}
	

	
}