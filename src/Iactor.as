package
{
	import flash.geom.Vector3D;

	public interface Iactor {
		function render_shadow ( ) :void ;
		function render ( ) :void ;
		function get pos ( ) :Vector3D ;
	}
}