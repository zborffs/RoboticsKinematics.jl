using YAML

export Joint
export genJointVec

struct Joint
	isPerp::Bool
	length::Float64

	function Joint(o::String, l::Float64)
		isPerp = (o == "perpendicular");
		length = abs(l);
		new(isPerp, length)
	end
end

function genJointVec(fileName::String)::Vector{Union{Missing, Joint}}
	data = collect(values(YAML.load_file("config/2dof.yaml")))

	order = Vector{Union{Missing, Joint}}(missing, length(data))
	for j in data
		order[j["order"]] = Joint(j["orientation"], j["length"])
	end

	return order
end

# data = YAML.load_file("config/2dof.yaml")[1]

# jointVector = Vector{Joint}
# let l = data["base"]["length"], o = data["base"]["orientation"], n = data["base"]["to"]
#
# 	while n != nothing
#
# 	end
# end
# for i in 1:length(data)
# 	l = data[i]["length"];
# 	o = data[i]["orientation"];
# 	n = data[i]["to"]
# end
