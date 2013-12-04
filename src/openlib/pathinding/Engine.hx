package openlib.pathinding;
class Engine {
	public var map:Array<Array<Node>>;
	public var startNode(default, set):Node;
	public var endNode(default, set):Node;
	
	public function new(){
		this.map = [];
	}
	public function generateMap(x:Int, y:Int):Array<Array<Node>> {
		for(xi in 0...x){
			map[xi] = [];
			for(yi in 0...y){
				map[xi][yi] = new Node(xi,yi,10, NORMAL_NODE);
				map[xi][yi].setEngine(this);
			}
		}
		return map;
	}
	
	public function getMap():Array<Array<Node>> {
		return this.map;
	}
	
	function set_startNode(node:Node):Node {
		map[node.x][node.y] = node;
		node.type = START_NODE;
		return node;
	}
	
	function set_endNode(node:Node):Node {
		map[node.x][node.y] = node;
		node.type = END_NODE;
		return node;
	}
	
	public function getPath(adjacentMethod:Array<Array<Int>>):Array<Node> {
		var openList = [];
		var closeList = [];
		var currentNode:Node = this.startNode;
		while(true){
			var adjacent = currentNode.getAdjacentNodes(map, adjacentMethod);
			adjacent.sort(function(node_a, node_b){
				var num = node_a.getF() - node_b.getF();
				if(num == 0){
					num = node_a.getH()-node_b.getH();
				}
				return num;
			});
			for(node in adjacent){
				if(!node.open){
					node.open = true;
					node.parent = currentNode;
				}
			}
			currentNode.close = true;
			if(currentNode == endNode){
				break;
			}	
			currentNode = adjacent[0];
		}
		var path:Array<Node> = [];
		var currentNode = this.endNode;
		while(true){
			path.push(currentNode);
			currentNode = currentNode.parent;
			if(currentNode == startNode){
				break;
			}
		}
		path.reverse();
		return path;
	}
	
	public function getNode(x:Int, y:Int) 
	{
		return map[x][y];
	}

}
