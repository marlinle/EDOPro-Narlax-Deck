-- Rexne the Nightmare King
local s,id=GetID()
function s.initial_effect(c)
Pendulum.AddProcedure(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--pierce
    	local e2=Effect.CreateEffect(c)
    	e2:SetType(EFFECT_TYPE_SINGLE)
    	e2:SetCode(EFFECT_PIERCE)
    	c:RegisterEffect(e2)
	--special summon
    	local e3=Effect.CreateEffect(c)
    	e3:SetDescription(aux.Stringid(id,0))
    	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    	e3:SetType(EFFECT_TYPE_IGNITION)
    	e3:SetRange(LOCATION_PZONE)
    	e3:SetCondition(s.spcon)
    	e3:SetTarget(s.sptg)
    	e3:SetOperation(s.spop)
    	c:RegisterEffect(e3)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.AtkBoostFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)*300
end
function s.AtkBoostFilter(c,e,tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsFaceup()
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and    Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,3,nil)
end