using Luxor

using Random
Random.seed!(1234567)

# theme colors
c1 = (255, 138, 67) ./ 255;
c2 = (112, 110, 177) ./ 255;
c3 = (0, 131, 166) ./ 255;

Drawing(500, 500, joinpath(@__DIR__, "..", "dist", "static", "logo.svg"))

origin()

setcolor(66 / 255, 148 / 255, 150 / 255)
rotate(deg2rad(15))
squircle(O, 200, 200; rt = 0.5, action = :stroke)
rotate(deg2rad(-3))

for i in 1:12
    #setcolor(rand([c1, c2, c3])...)
    #setcolor(c2...)
    rotate(i * deg2rad(41))
    corners = ngon(Point(0, 0), 20 + 12i, 6; vertices = true)
    circle.(corners, (12 - i + 1), action = rand() < 0.5 ? :fill : :stroke)
end

finish()
preview()

Drawing(500, 500, joinpath(@__DIR__, "..", "dist", "static", "favicon.svg"))

origin()

setcolor(66 / 255, 148 / 255, 150 / 255)
rotate(deg2rad(15))
squircle(O, 200, 200; rt = 0.5, action = :fill)
rotate(deg2rad(-3))

for i in 1:12
    setcolor(255, 255, 255)
    rotate(i * deg2rad(41))
    corners = ngon(Point(0, 0), 20 + 12i, 6; vertices = true)
    circle.(corners, (12 - i + 1), action = rand() < 0.5 ? :fill : :stroke)
end

finish()
preview()