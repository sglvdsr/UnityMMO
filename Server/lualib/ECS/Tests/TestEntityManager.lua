TestEntityManager = BaseClass(require("TestBaseClass"))

function TestEntityManager:TestIncreaseEntityCapacity(  )
    local EcsTestData = {value="number"}
    ECS.TypeManager.RegisterType("DataForTestIncreaseEntityCapacity", EcsTestData)

    local archetype = self.m_Manager:CreateArchetype({"DataForTestIncreaseEntityCapacity"})
    local count = 1024
    local array = self.m_Manager:CreateEntitiesByArcheType(archetype, count)
    for i=1,count do
        lu.assertEquals(array[i].Index, i)
        lu.assertTrue(self.m_Manager:Exists(array[i]))
    end
end

function TestEntityManager:TestEntityGSetComponent(  )
    local test_compponent_name = "DataForTestEntityGSetComponent"
    local test_compponent_name2 = "DataForTestEntityGSetComponent2"
	local EcsTestData = {x="number", y="boolean", z="integer"}
    ECS.TypeManager.RegisterType(test_compponent_name, EcsTestData)
	ECS.TypeManager.RegisterType(test_compponent_name2, {value="integer"})

	local archetype = self.m_Manager:CreateArchetype({test_compponent_name, test_compponent_name2})
    local entity = self.m_Manager:CreateEntityByArcheType(archetype)
    lu.assertNotNil(entity)
    local comp_data = self.m_Manager:GetComponentData(entity, test_compponent_name)
    lu.assertEquals(comp_data.x, 0)
    lu.assertEquals(comp_data.y, false)
    lu.assertEquals(comp_data.z, 0)

    local comp_data2 = self.m_Manager:GetComponentData(entity, test_compponent_name2)
    lu.assertEquals(comp_data2.value, 0)

    self.m_Manager:SetComponentData(entity, test_compponent_name, {x=1.123456, y=true, z=3})
    self.m_Manager:SetComponentData(entity, test_compponent_name2, {value=123456789})
    comp_data = self.m_Manager:GetComponentData(entity, test_compponent_name)
    lu.assertEquals(comp_data.x, 1.123456)
    lu.assertEquals(comp_data.y, true)
    lu.assertEquals(comp_data.z, 3)
    comp_data2 = self.m_Manager:GetComponentData(entity, test_compponent_name2)
    lu.assertEquals(comp_data2.value, 123456789)

    local entity2 = self.m_Manager:CreateEntityByArcheType(archetype)
    lu.assertNotNil(entity2)
    local comp_data2 = self.m_Manager:GetComponentData(entity2, test_compponent_name)
    lu.assertEquals(comp_data2.x, 0)
    lu.assertEquals(comp_data2.y, false)
    lu.assertEquals(comp_data2.z, 0)
    self.m_Manager:SetComponentData(entity2, test_compponent_name, {x=4.412376453451, y=false, z=0})
    comp_data2 = self.m_Manager:GetComponentData(entity2, test_compponent_name)
    lu.assertEquals(comp_data2.x, 4.412376453451)
    lu.assertEquals(comp_data2.y, false)
    lu.assertEquals(comp_data2.z, 0)
end

function TestEntityManager:TestEntityAddComponent(  )
    local test_compponent_name = "DataForTestEntityAddComponent1"
    local test_compponent_name_two = "TestEntityAddComponent2"
    local EcsTestData = {x="number", y="number", z="number"}
    ECS.TypeManager.RegisterType(test_compponent_name, EcsTestData)
    ECS.TypeManager.RegisterType(test_compponent_name_two, {value="number"})

    local archetype = self.m_Manager:CreateArchetype({test_compponent_name})
    local entity = self.m_Manager:CreateEntityByArcheType(archetype)
    lu.assertNotNil(entity)
    
    self.m_Manager:AddComponent(entity, test_compponent_name_two)
    local comp_data = self.m_Manager:GetComponentData(entity, test_compponent_name_two)
    lu.assertEquals(comp_data.value, 0)
    self.m_Manager:SetComponentData(entity, test_compponent_name_two, {value=321})
    comp_data = self.m_Manager:GetComponentData(entity, test_compponent_name_two)
    lu.assertEquals(comp_data.value, 321)
end

function TestEntityManager:TestEntityRemoveComponent(  )
    local test_compponent_name = "DataForTestEntityAddComponent"
    local EcsTestData = {x="number", y="number", z="number"}
    ECS.TypeManager.RegisterType(test_compponent_name, EcsTestData)

    local archetype = self.m_Manager:CreateArchetype({test_compponent_name})
    local entity = self.m_Manager:CreateEntityByArcheType(archetype)
    lu.assertNotNil(entity)
    local has = self.m_Manager:HasComponent(entity, test_compponent_name)
    lu.assertTrue(has)

    self.m_Manager:RemoveComponent(entity, test_compponent_name)
    local has = self.m_Manager:HasComponent(entity, test_compponent_name)
    lu.assertFalse(has)
end
