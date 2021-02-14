-- Nightmare Tech Heartless Angel
local s, id = GetID()
function s.initial_effect(c)
	-- fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x420a),3)
    	--pierce
    	local e2=Effect.CreateEffect(c)
    	e2:SetType(EFFECT_TYPE_SINGLE)
    	e2:SetCode(EFFECT_PIERCE)
    	c:RegisterEffect(e2)
end
s.material_setcode={0x420a}