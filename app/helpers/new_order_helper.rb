module NewOrderHelper
  def plan_title(plan_type)
    if plan_type == "Recurrente"
      return "NUESTRO PLAN MENSUAL"
    elsif plan_type == "1Mes"
      return "PRUEBA THE WOMEN BOX POR UN MES"
    elsif plan_type == "3Meses"
      return "NUESTRO PLAN DE 3 MESES"
    elsif plan_type == "6Meses"
      return "NUESTRO PLAN DE 6 MESES"
    end
  end
end
