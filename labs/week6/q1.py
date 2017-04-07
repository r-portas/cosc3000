from cs1graphics import *

canvas = Canvas()

canvas.setWidth(300)
canvas.setHeight(200)

circle = Circle()
circle.setRadius(20)
circle.setFillColor('red')
circle.moveTo(70, 70)

canvas.add(circle)

rect = Rectangle()
rect.setWidth(30)
rect.setHeight(30)
rect.setFillColor('green')
rect.moveTo(150, 150)

canvas.add(rect)
