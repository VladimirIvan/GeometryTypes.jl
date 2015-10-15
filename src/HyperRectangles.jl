using Compat

VERSION < v"0.4-" && using Docile

maximum(b::HyperRectangle) = b.maximum
minimum(b::HyperRectangle) = b.minimum
length{T, N}(b::HyperRectangle{N, T}) = N
width(b::HyperRectangle) = maximum(b) - minimum(b)

(==){T1, T2, N}(b1::HyperRectangle{N, T1}, b2::HyperRectangle{N, T2}) =
    b1.minimum == b2.minimum && b1.maximum == b2.maximum


isequal(b1::HyperRectangle, b2::HyperRectangle) = b1 == b2

"""
Check if HyperRectangles are contained in each other. This does not use
strict inequality, so HyperRectangles may share faces and this will still
return true.
"""
function contains{T1, T2, N}(b1::HyperRectangle{N, T1}, b2::HyperRectangle{N, T2})
    for i = 1:N
        b2.maximum[i] <= b1.maximum[i] && b2.minimum[i] >= b1.minimum[i] || return false
    end
    true
end

"""
Check if a point is contained in a HyperRectangle. This will return true if
the point is on a face of the HyperRectangle.
"""
function contains{T, N}(b1::HyperRectangle{N, T}, pt::Union{FixedVector, AbstractVector})
    for i = 1:N
        pt[i] <= b1.maximum[i] && pt[i] >= b1.minimum[i] || return false
    end
    true
end

"""
Check if HyperRectangles are contained in each other. This does not use
strict inequality, so HyperRectangles may share faces and this will still
return true.
"""
in(b1::HyperRectangle, b2::HyperRectangle) = contains(b2, b1)

"""
Check if a point is contained in a HyperRectangle. This will return true if
the point is on a face of the HyperRectangle.
"""
in(pt::Union{FixedVector, AbstractVector}, b1::HyperRectangle) = contains(b1, pt)

"""
Splits an HyperRectangle into two new ones along an axis at a given axis value
"""
function split_{N, T}(b::HyperRectangle{N, T}, axis::Int, value::T) # <: Real nece
    b1max = setindex(b.maximum, value, axis)
    b2min = setindex(b.minimum, value, axis)

    return HyperRectangle{N, T}(b.minimum, b1max),
           HyperRectangle{N, T}(b2min, b.maximum)
end
"""
Perform a union between two HyperRectangles.
"""
union{T,N}(h1::HyperRectangle{N, T}, h2::HyperRectangle{N, T}) =
    HyperRectangle{N, T}(min(minimum(h1), minimum(h2)), max(maximum(h1), maximum(h2)))

"""
Perform a difference between two HyperRectangles.
"""
diff(h1::HyperRectangle, h2::HyperRectangle) = h1



"""
Perform a intersection between two HyperRectangles.
"""
intersect{T,N}(h1::HyperRectangle{N, T}, h2::HyperRectangle{N, T}) =
    HyperRectangle{N, T}(max(minimum(h1), minimum(h2)),  min(maximum(h1), maximum(h2)))


if VERSION >= v"0.4.0-"
    call{T,N}(::Type{HyperRectangle{N, T}}) =
        HyperRectangle{N, T}(Vec{N,T}(typemin(T)), Vec{N,T}(typemax(T)))
end

# submodules
include("Relations.jl")
include("Operations.jl")