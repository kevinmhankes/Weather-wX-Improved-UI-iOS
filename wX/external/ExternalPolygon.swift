/*
 
 Copyright 2013-present Roman Kushnarenko
 
 Licensed under the Apache License, Version 2.0 (the "License")
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 https://github.com/sromku/polygon-contains-point
 
 */

/**
 * The 2D polygon. <br>
 *
 * @see {@link Builder}
 * @author Roman Kushnarenko (sromku@gmail.com)
 */
final class ExternalPolygon {
    
    private let boundingBox: BoundingBox
    private let sides: [ExternalLine]

    init(_ sides: [ExternalLine], _ boundingBox: BoundingBox) {
        self.sides = sides
        self.boundingBox = boundingBox
    }

    /**
     * Builder of the polygon
     *
     * @author Roman Kushnarenko (sromku@gmail.com)
     */
    final class Builder {
        
        private var vertexes = [ExternalPoint]()
        private var sides = [ExternalLine]()
        private var boundingBox = BoundingBox()
        private var firstPoint = true
        private var isClosed = false

        /**
         * Add vertex points of the polygon.<br>
         * It is very important to add the vertexes by order, like you were drawing them one by one.
         *
         * @param point
         *            The vertex point
         * @return The builder
         */
        func addVertex(_ point: ExternalPoint ) -> Builder {
            if isClosed {
                // each hole we start with the new array of vertex points
                vertexes = []
                isClosed = false
            }
            updateBoundingBox(point)
            vertexes.append(point)
            // add line (edge) to the polygon
            if vertexes.count > 1 {
                let line =  ExternalLine(vertexes[vertexes.count - 2], point)
                sides.append(line)
            }
            return self
        }

        /**
         * Build the instance of the polygon shape.
         *
         * @return The polygon
         */
        func build() -> ExternalPolygon {
            validate()
            // in case you forgot to close
            if !isClosed {
                // add last Line
                sides.append(ExternalLine(vertexes[vertexes.count - 1], vertexes[0]))
            }
            let polygon = ExternalPolygon(sides, boundingBox)
            return polygon
        }

        /**
         * Update bounding box with a new point.<br>
         *
         * @param point
         *            New point
         */
        func updateBoundingBox(_ point: ExternalPoint ) {
            if firstPoint {
                boundingBox =  BoundingBox()
                boundingBox.xMax = point.x
                boundingBox.xMin = point.x
                boundingBox.yMax = point.y
                boundingBox.yMin = point.y
                firstPoint = false
            } else {
                // set bounding box
                if point.x > boundingBox.xMax {
                    boundingBox.xMax = point.x
                } else if point.x < boundingBox.xMin {
                    boundingBox.xMin = point.x
                }
                if point.y > boundingBox.yMax {
                    boundingBox.yMax = point.y
                } else if point.y < boundingBox.yMin {
                    boundingBox.yMin = point.y
                }
            }
        }

        func validate() {
            if vertexes.count < 3 {
                // throw new RuntimeException("Polygon must have at least 3 points")
            }
        }
    }

    /**
     * Check if the the given point is inside of the polygon.<br>
     *
     * @param point
     *            The point to check
     * @return <code>True</code> if the point is inside the polygon, otherwise return <code>False</code>
     */
    func contains(_ point: ExternalPoint) -> Bool {
        if inBoundingBox(point) {
            let ray = createRay(point)
            var intersection = 0
            for side in sides {
                if intersect(ray, side) {
                    intersection += 1
                }
            }
            /*
             * If the number of intersections is odd, then the point is inside the polygon
             */
            if intersection % 2 == 1 {
                return true
            }
        }
        return false
    }

    /**
     * By given ray and one side of the polygon, check if both lines intersect.
     *
     * @param ray
     * @param side
     * @return <code>True</code> if both lines intersect, otherwise return <code>False</code>
     */
    func intersect(_ ray: ExternalLine, _ side: ExternalLine) -> Bool {
        var intersectPoint = ExternalPoint()
        // if both vectors aren't from the kind of x=1 lines then go into
        if !ray.isVertical() && !side.isVertical() {
            // check if both vectors are parallel. If they are parallel then no intersection point will exist
            if ray.getA() - side.getA() == 0 {
                return false
            }
            let x = ((side.getB() - ray.getB()) / (ray.getA() - side.getA())) // x = (b2-b1)/(a1-a2)
            let y = side.getA() * x + side.getB() // y = a2*x+b2
            intersectPoint = ExternalPoint(x, y)
        } else if ray.isVertical() && !side.isVertical() {
            let x = ray.getStart().x
            let y = side.getA() * x + side.getB()
            intersectPoint =  ExternalPoint(x, y)
        } else if !ray.isVertical() && side.isVertical() {
            let x = side.getStart().x
            let y = ray.getA() * x + ray.getB()
            intersectPoint = ExternalPoint(x, y)
        } else {
            return false
        }
        if side.isInside(intersectPoint) && ray.isInside(intersectPoint) {
            return true
        }
        return false
    }

    /**
     * Create a ray. The ray will be created by given point and on point outside of the polygon.<br>
     * The outside point is calculated automatically.
     * 
     * @param point
     * @return
     */
    func createRay(_ point: ExternalPoint) -> ExternalLine {
        // create outside point
        let epsilon = (boundingBox.xMax - boundingBox.xMin) / 100.0
        let outsidePoint = ExternalPoint(boundingBox.xMin - epsilon, boundingBox.yMin)
        let vector = ExternalLine(outsidePoint, point)
        return vector
    }

    /**
     * Check if the given point is in bounding box
     * 
     * @param point
     * @return <code>True</code> if the point in bounding box, otherwise return <code>False</code>
     */
    func inBoundingBox(_ point: ExternalPoint) -> Bool {
        if point.x < boundingBox.xMin
            || point.x > boundingBox.xMax
            || point.y < boundingBox.yMin
            || point.y > boundingBox.yMax {
            return false
        }
        return true
    }

    final class BoundingBox {
        var xMax = -Float.infinity
        var xMin = -Float.infinity
        var yMax = -Float.infinity
        var yMin = -Float.infinity
    }
    
    static func polygonContainsPoint(_ latLon: LatLon, _ latLons: [LatLon]) -> Bool {
        let polygonFrame = ExternalPolygon.Builder()
        latLons.forEach { _ = polygonFrame.addVertex(ExternalPoint($0)) }
        let polygonShape = polygonFrame.build()
        let contains = polygonShape.contains(latLon.asPoint())
        return contains
    }
}
