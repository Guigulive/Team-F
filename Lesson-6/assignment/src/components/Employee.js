import React,{Component} from 'react'
import {Card,Col,Row,Layout,Alert,message,Button} from 'antd'
import Common from './Common'

class Employee extends Component{

    constructor(props){
        super(props)

        this.state = {
            // employee:this.props.employee
        }


    }

    componentDidMount(){
        this.checkEmployee()
    }

    // componentWillReceiveProps(nextProps){
    //     // console.log("旧的employee:",this.state.employee)
    //     // console.log("新的employee:",nextProps.employee)
    //     if (nextProps.employee !== this.state.employee) {
            
    //         this.setState({employee:nextProps.employee})
    //         // console.log("更新后的employee:",this.state.employee)
    //         this.checkEmployee(nextProps.employee)
    //     }
        
    // } 

    checkEmployee = (employee = null) => {
        const {payroll,web3} = this.props
        const {account,employeeId} = this.props
        // console.log(account,payroll,web3)
        // if (employee == null){
        //     employee = this.props.employee
        // }
        // console.log("employee.js employee:",employee)
        payroll.employees.call(employeeId,{from:account,gas:1000000}).then((result)=>{
            // console.log(result)
            this.setState({
                salary:web3.fromWei(result[1].toNumber()),
                lastPayDate:new Date(result[2].toNumber() * 1000)
            })
        })

        web3.eth.getBalance(employeeId,(err,result) =>{
            this.setState({
                balance:web3.fromWei(result.toNumber())
            })
        })
    }

    getPaid = () =>{
        const {payroll,employeeId} = this.props
        payroll.getPaid({from:employeeId,gas:1000000}).then(message.info('已经成功领取工资'))

    }

    renderContent(){
        const {salary,lastPayDate,balance} = this.state
        const {employeeId} = this.props

        // console.log(salary)
        

        if (!salary || salary === '0') {
            return <Alert message="你现在不是员工地址" type="error" showIcon />
        }

        return(
            <div>
                <Row gutter={16}>
                    <Col span={10}>
                        <Card title="员工地址">{employeeId}</Card>
                    </Col>
                    <Col span={4}>
                        <Card title="当前余额">{Number(balance).toFixed(2)} Ether</Card>
                    </Col>
                    <Col span={4}>
                        <Card title="工资">{salary} Ether</Card>
                    </Col>
                    <Col span={6}>
                        <Card title="上次支付时间">{lastPayDate.toString()}</Card>
                    </Col>
                </Row>
                <Button type="primary" icon="bank" onClick={this.getPaid}>领取工资</Button>
                <p></p>
            </div>
        )
    }





    render(){

        const {account,payroll,web3} = this.props
        
        // console.log(account,payroll,web3)
        return(
            <Layout>
                <Common account={account} payroll={payroll} web3={web3} />
                <h2>员工</h2>
                {this.renderContent()}
            </Layout>
        )
    }

}

export default Employee