import React,{Component} from 'react'

class Employee extends Component{

    constructor(props){
        super(props)

        this.state = {
            employee:this.props.employee
        }


    }

    componentDidMount(){
        this.checkEmployee()
    }

    componentWillReceiveProps(nextProps){
        // console.log("旧的employee:",this.state.employee)
        // console.log("新的employee:",nextProps.employee)
        if (nextProps.employee !== this.state.employee) {
            
            this.setState({employee:nextProps.employee})
            // console.log("更新后的employee:",this.state.employee)
            this.checkEmployee(nextProps.employee)
        }
        
    } 

    checkEmployee = (employee = null) => {
        const {payroll,web3} = this.props
        if (employee == null){
            employee = this.props.employee
        }
        // console.log("employee.js employee:",employee)
        payroll.employees.call(employee,{from:employee,gas:1000000}).then((result)=>{
            // console.log(result)
            this.setState({
                salary:web3.fromWei(result[1].toNumber()),
                lastPayDate:new Date(result[2].toNumber() * 1000)
            })
        })

        var balance = web3.eth.getBalance(employee)

        this.setState({
            balance:web3.fromWei(balance.toNumber())
        })

    }

    getPaid = () =>{
        const {payroll,employee} = this.props
        payroll.getPaid({from:employee,gas:1000000}).then(alert('已经成功领取工资'))

    }

    render(){
        const {salary,lastPayDate,balance} = this.state
        const {employee} = this.props

        return(
            <div>
                <h2>员工 {employee}</h2>
                {/* {console.log("salary",salary)} */}
                {
                    !salary || salary === '0' ?
                    <p>你现在不是员工地址</p>    :
                    (
                    <div>
                        <p>员工地址：{employee}</p>
                        <p>当前余额：{balance}</p>
                        <p>工资：{salary}</p>
                        <p>上次支付时间：{lastPayDate.toString()}</p>
                        <button type="button" className="pure-button" onClick={this.getPaid}>领取工资</button>
                    </div>
                    )
                }
            </div>
        )
    }

}

export default Employee