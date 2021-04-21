-- Nightmare Tech Killer Clown
-- Coded by FunnyBones777
local s, id = GetID()
function s.initial_effect(c)
	-- synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsCode,420697),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x420a),1,99)
	c:EnableReviveLimit()
  	-- direct attack
    	local e1=Effect.CreateEffect(c)
    	e1:SetType(EFFECT_TYPE_SINGLE)
    	e1:SetCode(EFFECT_DIRECT_ATTACK)
    	c:RegisterEffect(e1)
end
s.listed_series={0x420a}