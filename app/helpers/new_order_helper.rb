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

  def plan_price(plan_type)
    if plan_type == "Recurrente"
      return "$34.900 al mes"
    elsif plan_type == "1Mes"
      return "$34.900"
    elsif plan_type == "3Meses"
      return "$33.167 al mes"
    elsif plan_type == "6Meses"
      return "$31.417 al mes"
    end
  end

  def order_description(plan_type)
    if plan_type == "Recurrente"
      return "Suscripción mensual a The Women Box"
    elsif plan_type == "1Mes"
      return "1 mes de suscripción a The Women Box"
    elsif plan_type == "3Meses"
      return "3 meses de suscripción a The Women Box"
    elsif plan_type == "6Meses"
      return "6 meses de suscripción a The Women Box"
    end
  end

  def order_delivery_date(plan_type)
    if plan_type == "Recurrente"
      return "de cada mes"
    elsif plan_type == "1Mes"
      return "del mes"
    elsif plan_type == "3Meses"
      return "de cada mes"
    elsif plan_type == "6Meses"
      return "de cada mes"
    end
  end

  def order_plan(plan_type, plan_name)
    if plan_type == "Recurrente"
      return "mensual (#{plan_name})"
    elsif plan_type == "1Mes"
      return "1 mes (#{plan_name})"
    elsif plan_type == "3Meses"
      return "3 meses (#{plan_name})"
    elsif plan_type == "6Meses"
      return "6 meses (#{plan_name})"
    end
  end
end
