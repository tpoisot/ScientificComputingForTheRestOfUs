using Luxor

using Random
Random.seed!(420)

# theme colors
c0 = (66, 148, 150) ./ 255;
c1 = (255, 138, 67) ./ 255;
c2 = (112, 110, 177) ./ 255;
c3 = (0, 131, 166) ./ 255;

Drawing(500, 500, joinpath(@__DIR__, "..", "dist", "static", "logo.svg"))

origin()

setline(1)
setcolor(c0)

for i in 1:8
    circle(rand(-15:15), rand(-15:15), rand(200:240), action = :stroke)
end

setline(3)
setcolor(c2)
circle(O, 220, action = :stroke)

for i in 1:10
    rotate(deg2rad(3i))
    corners = ngon(Point(0, 0), 20 + 15i, 5; vertices = true)
    for corner in corners
        rotate(deg2rad(rand(-5:5)))
        setline(rand(2:5))
        setcolor(rand([c1, c3]))
        circle(corner, rand(2:6); action = rand([:fill, :stroke]))
    end
end

finish()
preview()
