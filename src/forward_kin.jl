using Rotations, CoordinateTransformations, StaticArrays, Unitful, UnitfulAstro

struct DHParams
	# DH-Params
	# θ::Float64 # radians - (rotate about z-axis) - current angle of rotational joint
	d::Float64 # distance (translate across z-axis) - length of link
	a::Float64 # distance (translate across x-axis) - x-offset joints
	α::Float64 # radians (rotate about x-axis) - z-offset (usually 90 degrees if perpendicular or 0 degrees if parallel axis of rotation from one to the next)

	function DHParams(joint::Joint)
		d = joint.length;
		a = 0.0;
		α = joint.isPerp ? 90.0 : 0.0;
		new(d, a, α)
	end
end

function findEndEffector(origin::SVector, dh::Vector{DHParams}, q::Vector{Float64})
	# Make sure dof of robot equals the number of actuators
	@assert length(dh) == length(q)
	dof = length(dh)

	# Generate T_Rz Matrices
	T_Rz = Vector{LinearMap}(undef, dof)
	T_z = Vector{Translation{SArray{Tuple{3}, Float64, 1, 3}}}(undef, dof)
	T_x = Vector{Translation{SArray{Tuple{3}, Float64, 1, 3}}}(undef, dof)
	T_Rx = Vector{LinearMap}(undef, dof)
	for i in 1:dof
		T_Rz[i] = LinearMap(RotZ(q[i]))
		T_z[i] = Translation(0.0, 0.0, dh[i].d)
		T_x[i] = Translation(dh[i].a, 0.0, 0.0)
		T_Rx[i] = LinearMap(RotX(dh[i].α))

		origin = T_Rz[i] * T_z[i] * T_x[i] * T_Rx[i]
	end

	return origin
end
