using Luxor

using Random
Random.seed!(420)

# theme colors
c0 = (0, 121, 107) ./ 255;

Drawing(500, 500, joinpath(@__DIR__, "..", "dist", "static", "logo.svg"))

origin()

setline(4)
setcolor(c0)

for i in 1:6
    rotate(deg2rad(30))
    squircle(O, 180, 180, :fill; rt = 0.2)
end

setcolor("white")
for i in 1:8
    rotate(i * deg2rad(3))
    corners = ngon(Point(0, 0), 40 + 18i, 10; vertices = true)
    circle.(corners, 6, action = :fill)
end

finish()
preview()
