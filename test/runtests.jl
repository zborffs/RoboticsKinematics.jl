using RoboticsKinematics
using Test
using YAML

@testset "Joint Constructors" begin
	# Basic constructor
	testJoint1 = Joint("perpendicular", 10.0)
	@test testJoint1.isPerp == true
	@test testJoint1.length == 10.0

	testJoint2 = Joint("parallel", 1.0)
	@test testJoint2.isPerp == false
	@test testJoint2.length == 1.0

	testJoint3 = Joint("perpendicular", 12.523)
	@test testJoint3.isPerp == true
	@test testJoint3.length == 12.523

	# Turn negative lengths positive
	testJoint4 = Joint("parallel", -1.23)
	@test testJoint4.isPerp == false
	@test testJoint4.length == 1.23
end

@testset "Import Sample Data" begin
	data = collect(values(YAML.load_file("config/2dof.yaml")))

	order = Vector{Union{Missing, Joint}}(missing, length(data))
	for j in data
		order[j["order"]] = Joint(j["orientation"], j["length"])
	end

	testJoint1 = Joint("parallel", 12.0)
	testJoint2 = Joint("perpendicular", 6.0)
	testJoint3 = Joint("perpendicular", 3.0)
	@test order[1] == testJoint1
	@test order[2] == testJoint2
	@test order[3] == testJoint3

	# Use function
	testJointVector = genJointVec("config/2dof.yaml")
	@test testJointVector[1] == testJoint1
	@test testJointVector[2] == testJoint2
	@test testJointVector[3] == testJoint3
end

@testset "Convert Data to DH-Params" begin
	data = collect(values(YAML.load_file("config/2dof.yaml")))

	order = Vector{Union{Missing, Joint}}(missing, length(data))
	for j in data
		order[j["order"]] = Joint(j["orientation"], j["length"])
	end

	
end
