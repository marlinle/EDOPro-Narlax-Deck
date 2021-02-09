-- Rexne the Nightmare King
-- Coded by FunnyBones777
local s,id=GetID()
function s.initial_effect(c)
Pendulum.AddProcedure(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.value)
	c:RegisterEffect(e1)
	--pierce
    	local e2=Effect.CreateEffect(c)
    	e2:SetType(EFFECT_TYPE_SINGLE)
    	e2:SetCode(EFFECT_PIERCE)
    	c:RegisterEffect(e2)
	--Special summon this card from pendulum zone
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.value(e,c)
	return Duel.GetMatchingGroupCount(s.AtkBoostFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)*300
end
function s.AtkBoostFilter(c,e,tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsFaceup()
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
	--Check for 3+ zombies monsters in your GY+field
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,3,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
	--Performing the effect of special summoning this card from scale
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
