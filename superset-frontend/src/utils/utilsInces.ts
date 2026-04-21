
interface RowDataChart {
    chart_id: number;
    titulo: string;
    query_sql: string;
    columnas: any[];
    data_filas: any[];
    configuracion: any;
}

 
export function cleanDashboardJson(data: RowDataChart[]):string{
    const clearedData = data.map(chart=>({
        chart_id: chart.chart_id,
        titulo: chart.titulo,
        data: chart.data_filas
    }));

    return JSON.stringify(clearedData, null,2);
}