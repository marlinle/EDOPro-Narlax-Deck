--Soulsucker Serena
--Coded by FunnyBones777
local s, id = GetID()
function s.initial_effect(c)
  --fusion material
  c:EnableReviveLimit()
  Fusion.AddProcMix(c,false,false,420695,420699)
  --spsummon condition
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(s.splimit)
  c:RegisterEffect(e1)
  --equip
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(s.eqtg)
  e1:SetOperation(s.eqop)
  c:RegisterEffect(e1)
  aux.AddEREquipLimit(c,nil,s.eqval,s.equipop,e1)
  --atkup
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetValue(s.atkval)
  c:RegisterEffect(e2)
end
s.listed_names={4206913}
function s.splimit(e,se,sp,st)
  return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsCode(4206913)
end
function s.eqval(ec,c,tp)
  return ec:IsControler(tp) and ec:IsRace(RACE_ZOMBIE)
end
function s.filter(c)
  return c:IsRace(RACE_ZOMBIE) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc) end
  if chk==0 then return true end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.equipop(c,e,tp,tc)
  local atk=tc:GetTextAttack()
  if atk<0 then atk=0 end
  if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,nil,true) then return end
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
  e2:SetValue(atk)
  tc:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_EQUIP)
  e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
  e3:SetReset(RESET_EVENT+RESETS_STANDARD)
  e3:SetValue(s.repval)
  tc:RegisterEffect(e3)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    s.equipop(c,e,tp,tc)
	end
end
function s.repval(e,re,r,rp)
  return (r&REASON_BATTLE)~=0
end
function s.atkval(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)*100
end
