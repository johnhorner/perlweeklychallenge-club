#!raku

class Point {
    has Int $.x;
    has Int $.y;
}


class Rectangle {
    has Point $.corner-left;
    has Point $.corner-right;

    method area() {
        abs( $!corner-right.x - $!corner-left.x )
        * abs( $!corner-right.y - $!corner-left.y );
    }

    method overlapping-area( Rectangle $r ) {
        my $left = Point.new( x => max( $!corner-left.x, $r.corner-left.x ),
                              y => max( $!corner-left.y, $r.corner-left.y )
                            );
        my $right = Point.new( x => min( $!corner-right.x, $r.corner-right.x ),
                               y => min( $!corner-right.y, $r.corner-right.y )
                             );

        my Rectangle $overlapping = Rectangle.new:
                                    corner-left =>  $left,
                                    corner-right => $right;
        return $overlapping.area;

    }
}

# Example:
# $ raku ch-2.p6 -1 0 2 2   0 -1 4 4
# 22
#
# $ raku ch-2.p6 -3 -1 1 3 -1 -3 2 2
# 25
sub MAIN(  *@points where { @points.elems == 8 && @points.grep( * ~~ Int ) == @points.elems } ) {
    my @corners;
    @corners.push: Point.new( x => $_[ 0 ].Int, y => $_[ 1 ].Int ) for @points.rotor( 2 );
    my Rectangle $r1 = Rectangle.new: corner-left => @corners[ 0 ], corner-right => @corners[ 1 ];
    my Rectangle $r2 = Rectangle.new: corner-left => @corners[ 2 ], corner-right => @corners[ 3 ];

    "{ $r1.area + $r2.area - $r1.overlapping-area( $r2 ) }".say;
}
