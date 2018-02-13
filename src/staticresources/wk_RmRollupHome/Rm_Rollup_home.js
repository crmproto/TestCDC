
          function createLineChart(sfData){
                $('#rm-violation-chart').html('');
                if(sfData != ''){
                    
                  var chartConfig = {};
                  var chartDataSF = JSON.parse(sfData);
                  var chartData = {dates: chartDataSF.map((x) => x.monthValues), 
                                   accounts: chartDataSF.map((x) => x.accAndVioVlaues) };

                  chartData.dates.chartIndexOf = function(date){
                        for(var i=0; i< this.length; i++){

                                /* var formattedDate = date.getFullYear()+
                                                "-" + ('0' + (date.getMonth()+1)).slice(-2) + 
                                                "-" + ('0' + date.getDate()).slice(-2); */
                                
                            if(date.toDateString() == (new Date(this[i])).toDateString())
                                return i;

                        }

                        return -1;
                    };
                  
                  var accountsTotal = chartData.accounts.map((accounts) => accounts.reduce((sum, account) => sum + parseInt(account.split("#")[1]), 0))
                  
                  accountsTotal.interval = function(){
                    
                    var maxValue = Math.max.apply(null, this) 
                    var divisor = (maxValue % 10 == 0 ) ? 10 : 5;
                    var maxPoint = (divisor - (maxValue%divisor) + maxValue);
                    var dataPoints = [0]
                    
                    var interval = (maxValue <=  10) ?  1 :
                                   (maxValue <=  20) ?  5 :
                                   (maxValue <= 100) ? 10 : 25;

                    var length = (maxValue<=10)? maxValue + 1 : 
                    			 (maxPoint%interval != 0) ? parseInt(maxPoint / interval)+ 2 : parseInt(maxPoint / interval) + 1;

                    dataPoints = Array.apply(null, Array(length)).map(function (_, i) {return i*interval});
                    return dataPoints;
                  }
                  
                  chartConfig.bindto = "#rm-violation-chart";
                  chartConfig.data = {
                      x: 'date',
                      columns:[
                        ["date"].concat(chartData.dates),
                        ["data1"].concat(accountsTotal)
                      ]
                  };
                  
                  chartConfig.point = {
                    r: 5,
                    focus:{expand: {r: 6}}
                  };
                  
                  var xLines = [];
                  chartData.dates.forEach((date) =>{ xLines.push({value: date})});

                  var yLines = [];
                  accountsTotal.forEach((total) =>{ yLines.push({value: total * 10})});
                  
                  chartConfig.grid = {
                    x: {lines: xLines},
                    y: {show: true},
                  };
                  
                  chartConfig.axis = {
                        x: { type: 'timeseries', 
                             tick: { format: (chartDataSF[0].mode == "M") ? '%b' : '%e-%b' },
                             padding: {left: 0}
                       	},
                        y: {
                        	tick: {values: accountsTotal.interval()},
                        	min: 0,
                        	padding: {bottom: 0}
                    	}
                  };
                  
                  chartConfig.tooltip = {
                  	  show: false,
                      contents: function(d, defaultTitleFormat, defaultValueFormat, color){
                           
                        dateIndex = chartData.dates.chartIndexOf(d[0].x);
                            
                        var accountsInfo = "<div>"+chartData.accounts[dateIndex].join("</div>"+"<div>")+"</div>";
                        return '<div >'+accountsInfo.replace(/#/g, " - ")+'</div>';

                      }
                  };

                  var chart = c3.generate(chartConfig);  
                  drawGrpahLines();     
              }     
          }
          
          function createDoughnutChart(sfData){
            $('.doughnutChart').html('');
            $('.doughnutChart + div').html('');
            
            if (sfData != ''){
                                
                var chartData = JSON.parse(sfData);
                var data = [];
                var colors = ['#c6c6c6', 
                              '#6cd1f7', 
                              '#003660', 
                              '#00adef', 
                              '#003da8', 
                              '#0259f1', 
                              '#3c8eed', 
                              '#5e5e5e',
                              '#828282',
                              '#6fb2ff',
                              "007da9",
                              "0093c8",
                              "#c3f7ff",
                              "#b0b0b0",
                              "#b0b0b0"];
                
                var allAccountsTotal = chartData.reduce((sum, account) => sum + parseInt(account.numberOfRecs) , 0);

                chartData.forEach((account, index) => {
                    data.push({ 
                                label: account.accValues, 
                                value: account.numberOfRecs,
                                color: colors[index],
                                percentage: Math.round((account.numberOfRecs / allAccountsTotal) * 100)
                              });
                });          
                
                var width=500, height=300, radius = Math.min(width, height) / 2;
                
                

                var svg = d3.select('.doughnutChart').append('svg')
                svg.attr("preserveAspectRatio", "xMidYMin");

                var group = svg.append('g').attr("transform", "translate(" + width / 4 + "," + height / 2 + ")");
                
                group.append('g').attr('class', 'slices');
                group.append('g').attr('class', 'labelName');
                group.append('g').attr('class', 'labelValue');
                
                var arc = d3.svg.arc()
                          .outerRadius(radius * 0.7)
                          .innerRadius(radius * 0.4);
                          
                var pie = d3.layout.pie().value( function(d) { return d.value; } );
                
                var toolTip = d3.select("body").append("div").attr("class", "toolTip");
                
                var slices = group.select('.slices').selectAll('path')
                                  .data(pie(data), function(d) {return d.data.label} );
                                 
                slices.enter()
                     .insert('path')
                     .style('fill', function(d) { return d.data.color });
                         
                slices.attr("d", arc);
     
                slices.on("mousemove", function(d){
                        toolTip.style("left", d3.event.pageX+10+"px");
                        toolTip.style("top", d3.event.pageY-25+"px");
                        toolTip.style("display", "inline-block");
                        toolTip.style("border-color", d.data.color);
						toolTip.style("text-transform", "uppercase");
						toolTip.html(d.data.label +' - '+d.data.value);
                    });
                    
                slices.on("mouseout", function(d) { toolTip.style("display", "none"); });
            
                slices.exit().remove();
                
                var labels = group.select('.labelName').selectAll('text')
                                  .data(pie(data), function(d) {return d.data.label} );
                                  
                labels.enter().append("text")
                      .attr('transform', function(d){ return "translate(" + arc.centroid(d) + ")"; })
                      .attr('text-anchor', 'middle')
                      .attr("dy", ".35em")
                      .text(function(d) { return (d.data.percentage) ? d.data.percentage + "%" : ''; });

                labels.enter().append("text")
                      .attr("dy", ".25em")
                      .style("text-anchor", "middle")
                      .attr("class", "inside")
                      .text(function(d) { return allAccountsTotal; });

                labels.enter().append("text")
                      .attr("dy", "2em")
                      .style("text-anchor", "middle")
                      .attr("class", "data")
                      .text(function(d) { return 'TOTAL'; });

                //Override text tag for inner circle , removing duplicate tags
                if($("text.inside").length > 1)
                    $("text.inside:not(:first) , text.data:not(:first)").remove();


                var sum = 0 ;
                for (var i=0 ; i<data.length;i++){
                  sum = sum + data[i].percentage;

                }
                
                if (sum > 100 && sum == 101 ){
                  data[0].percentage -- ;                    
                } 

                if (sum < 100 && sum == 99 ){
                  data[0].percentage ++ ;                    
                } 

                drawDoughnutAccountsLabels(data);
            }
          }

          function drawDoughnutAccountsLabels(accounts){

            var accountLabel = function(account){
              return '<div class="valet-key-item">'+
                        ' <span class="valet-key key-square" style="background-color:'+account.color+'"></span> '+
                            account.label+
                     ' </div>';   
            }
            
            var accountsLabels = accounts.reduce((join, account) => join +  accountLabel(account), '');
            $('.doughnutChart + div').html(accountsLabels);
          }

          function initializeSelect(){
            $('select').niceSelect();
          }

          function drawGrpahLines(){
            // override VF page behaviour and draw and make visible rect manually
              $(document).find('svg').each(function(){
                var svgHeight = $(this).attr("height"); var svgWidth = $(this).attr("width");
                $(this).find("rect").each( function() { $(this).attr('width',svgWidth).attr('height',svgHeight);});
            });
          }

          function renderPage(lineChartDate, doughnutChartData){
            initializeSelect();
            createLineChart(lineChartDate);
            createDoughnutChart(doughnutChartData);
          }
                    

         /* Noi Scripts and My Property scripts */

                    // Swiper Settings
            function createSwiper() {
                var appendNumber = 4;
                var prependNumber = 1;
                var swiper = new Swiper('.swiper-container', {
                    pagination: '.swiper-pagination',
                    nextButton: '.swiper-button-next',
                    prevButton: '.swiper-button-prev',
                    paginationClickable: true,
                    slidesPerView: 5,
                    spaceBetween: 10,
                    breakpoints: {
                        991: {
                            slidesPerView: 2,
                            spaceBetween: 10
                        }
                    }
                });
            }
            
            function goToAccountFun(accId) {
                goToHomepageController(accId);
            }
            
            function calculateImpact(self,violations,valetTrash) {

                var valetTrashPercentage = valetTrash / (valetTrash + violations) * 100 * 0.8,
                    violationsPercentage = 80 - valetTrashPercentage;
                
                // Animate Impact Graph
                setTimeout(function() {
                    $(self).find('.impact-valet-violation-bar').css('width', violationsPercentage + '%');
                    $(self).find('.impact-valet-trash-bar').css('width', valetTrashPercentage + '%');
                    
                }, 500);
                
                setTimeout(function() {
                    // Get Bar Widths
                    var impactValetBarWidth = $(self).find('.impact-valet-violation-bar').width();
                    var impactViolationBarWidth = $(self).find('.impact-valet-trash-bar').width();

                    var totalImpactWidth = impactValetBarWidth + impactViolationBarWidth;

                    if (parseFloat(impactValetBarWidth) < totalImpactWidth * .10) {
                            $(self).find('.impact-valet-violation-bar span').hide();
                        } else {
                            $(self).find('.impact-valet-violation-bar span').show();
                        }
                        if (parseFloat(impactViolationBarWidth) < totalImpactWidth * .10) {
                            $(self).find('.impact-valet-trash-bar span').hide();
                        } else {
                            $(self).find('.impact-valet-trash-bar span').show();
                        }

                }, 1500);
                
                $(self).find('#impactTotal').attr('total', impactTotal).text(commaSeparateNumber(valetTrash + violations));
                
                $(self).find('.impact-valet-trash-value').text(commaSeparateNumber(valetTrash));
                
               $(self).find('.impact-valet-violation-value').text(commaSeparateNumber(violations));

            } 

             // Format large number to include comma.
                function commaSeparateNumber(val) {
                    while (/(\d+)(\d{3})/.test(val.toString())) {
                        val = val.toString().replace(/(\d+)(\d{3})/, '$1' + ',' + '$2');
                    }
                    return val;
                }

            function initImactCharts(){
                $( ".impact-chart" ).each(function( index ) {
                      var violation = $(this).attr('data-violations');
                      var valetTrash = $(this).attr('data-valet-trash');
                      violation = parseInt(violation);
                      valetTrash = parseInt(valetTrash);
                      calculateImpact(this,violation,valetTrash);
                      commaOnTotal();
                });
            }

            function initShowMore(){
                /*Code for Show More NOI starts here*/
                $('.showMore').hide();
                //Count no.of divs 
                var numItems = $('.impact-chart').length;
                if (numItems > 4){
                    $('.showMore').show();
                    $( ".impact-chart" ).each(function( index ) {
                      if(index >3){
                        $(this).hide();
                      }
                    });
                }                

                $( ".showMore" ).on( "click", function() {
                   
                    if($( ".showMore .text" ).text() == "SHOW LESS" )
                    {
                          $( ".impact-chart" ).each(function( index ) {
                          if(index >3){
                            $(this).hide();
                          }
                        });
                          $( ".showMore .text" ).text("SHOW MORE");
                    }
                    else{
                          $( ".impact-chart" ).show();
                          $( ".showMore .text" ).text("SHOW LESS");

                    }     
                });
            /*Code for Show More NOI ends here*/
            }

            function initNOI(sfData){
                initImactCharts();
                initShowMore();
            }
            /* End of Noi Scripts and My Property scripts */
            
            // ForOnchangeOfSequence
            function picklistValuesJS(){
              picklistValuesAS();
            }

            function picklistValuesNOIJS(){
              picklistValuesNOIAS();
            }
