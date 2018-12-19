---
title: Runge-Kutta integration
slug: runge_kutta_integration
weight: 1
---

$$y(t+\frac{h}{2}) = y(t)+\frac{h}{2}f\left(t, y(t)\right)$$

$$y'(t+\frac{h}{2}) = f\left(t+\frac{h}{2}, y(t+\frac{h}{2})\right)$$

$$y(t+h) = y(t) + h y'(t+\frac{h}{2})$$


````julia
function logistic(t, u; r=1.0, q=0.5)
  return u*(r-q*u)
end
````


````
logistic (generic function with 1 method)
````



````julia
function rk2(t0, u0, f; h=0.5, t=200.0, p...)
  T = typeof(t0)[]
  U = typeof(u0)[]
  push!(T, t0)
  push!(U, u0)
  for (i,ti) in enumerate(t0+h:h:t)
    y_th2 = U[i] + 0.5*h * f(ti, U[i]; p...)
    yprime_th2 = f(ti+0.5*h, y_th2; p...)
    y_th = U[i] + h*yprime_th2
    push!(T, ti)
    push!(U, y_th)
  end
  return (T, U)
end
````


````
rk2 (generic function with 1 method)
````



````julia
rk2(0.0, 0.0001, logistic; t=15.0)
````


````
([0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5  …  10.5, 11.0, 11.5, 
12.0, 12.5, 13.0, 13.5, 14.0, 14.5, 15.0], [0.0001, 0.000162495, 0.00026404
3, 0.000429039, 0.000697104, 0.00113257, 0.00183985, 0.00298823, 0.00485182
, 0.00787356  …  1.18113, 1.40832, 1.59266, 1.72918, 1.82405, 1.88736, 1.
92854, 1.95492, 1.97166, 1.98222])
````


