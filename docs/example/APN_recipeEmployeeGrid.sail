load(
  local!pagingInfo: a!pagingInfo(
    startIndex: 1,
    batchSize: -1,
    sort: a!sortInfo(
      field: "department",
      ascending: true
    )
  ),
  local!showAsGrid:false,
  with(
    local!datasubset: a!queryEntity(
      entity: cons!EMPLOYEE_ENTITY,
      query: a!query(
        aggregation: a!queryAggregation(
         aggregationColumns: {
          a!queryAggregationColumn(field: "department", isGrouping: true),
          a!queryAggregationColumn(field: "title", isGrouping: true),
          a!queryAggregationColumn(field: "id", aggregationFunction: "COUNT")
         }
        ),
        pagingInfo: local!pagingInfo
      )
    ), 
    local!categories: index(local!datasubset.data, "department", {}),
    /* Use union() to remove duplicates */
    local!uniqueCategories: union(local!categories, cast(typeof(local!categories), {})),
    local!labels: index(local!datasubset.data, "title", {}),
    /* Use union() to remove duplicates */
    local!uniqueLabels: union(local!labels, cast(typeof(local!labels), {})),
    local!series: a!forEach(
        items: local!uniquelabels,
        expression: with(
          local!label: fv!item,
            a!chartSeries(
              label: local!label,
              /* 
               * Loops over list of categories to find each datapoint that matches  
               * the series label and the category. This will ensure that the 
               * datapoints are in the correct order to display in the chart.                       
               */
              data: a!forEach(
                items: local!uniqueCategories,
                expression: with(
                /* Find all datapoints that match both the category and chart series label   */
                  local!intersection: intersection(
                    where( local!categories = cast( typeof(local!categories), fv!item), 0),
                    where( local!labels = cast( typeof(local!labels), local!label), 0)
                  ),
                  if(
                    length(local!intersection)=0,
                    /* 
                     * If there is no datapoint for this category-label pair, return 0 
                     * so that all subsequent points are in the correct order with the 
                     * categories.      
                     */
                    0,
                    index(index(local!datasubset.data, "id", {}), local!intersection, 0)
                  )
                )
              )
            )
          )
       ),
       a!sectionLayout(
         contents:{
          a!linkField(
          links:{
            a!dynamicLink(
              label: "View this data as a "&if(local!showAsGrid,"chart","grid"),
              value: not(local!showAsGrid),
              saveInto: local!showAsGrid
            )
          }
        ), 
        a!columnChartField(
          categories: local!uniqueCategories,
          series: local!series,
          xAxisTitle: "Departments",
          yAxisTitle: "Number of Employees",
          stacking: "NORMAL",
          showWhen: not ( local!showAsGrid )
        ),
        a!gridField(
         label:"Data",
         labelPosition:"COLLAPSED",
         totalCount:count(local!series),
         columns:{ 
          /* 
           * The first grid text column generates the Department names while the
           * forEach() statement creates an array of grid text columns. This 
           * expression is virtually identical to the forEach statement that
           * generated the chart series array for the stacked column chart.
           */
           a!gridTextColumn(label:"Department",data:local!uniqueCategories),
           a!forEach(
            items:local!uniquelabels,
            expression: with(
              local!gridLabel:fv!item,
               a!gridTextColumn(
                label: local!gridLabel,
                /* Loops over list of categories to find each datapoint that matches  
                 * the series label and the category. This will ensure that the 
                 * datapoints are in the correct order to display in the chart.                       
                 */
                data: a!forEach(
                  items:local!uniqueCategories,
                  expression: with(
                  /* Find all datapoints that match both the category and chart series label   */
                    local!gridIntersection: intersection(
                      where(local!categories=cast(typeof(local!categories), fv!item), 0),
                      where(local!labels=cast(typeof(local!labels), local!gridLabel), 0)
                    ),
                    if(
                    length(local!gridIntersection)=0,
                    /* If there is no datapoint for this category-label pair, return 0 
                     * so that all subsequent points are in the correct order with the 
                     * categories.      
                     */
                    0,
                    index(index(local!datasubset.data, "id", {}), local!gridIntersection, 0)
                    )
                  )
                ),
                alignment:"RIGHT"
              )
            )
           )
         },
         value:local!pagingInfo,
         rowHeader: 1,
         showWhen: local!showAsGrid
      )
       }
     )
  )
)