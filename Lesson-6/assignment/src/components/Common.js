import React,{Component} from 'react'
import {Card,Col,Row} from 'antd'

class Common extends Component {
    constructor(props){
        super(props)
        this.state = {}
    }

    componentDidMount() {
        const {payroll} = this.props;

        const updateInfo = (error,result) =>{
            if (!error){
                this.checkInfo()
            }
        }

        this.newFund = payroll.NewFund(updateInfo)
        this.getPaid = payroll.GetPaid(updateInfo)
        this.newEmployee = payroll.NewEmployee(updateInfo)
        this.updateEmployee = payroll.UpdateEmployee(updateInfo)
        this.RemoveEmployee = payroll.RemoveEmployee(updateInfo)

        this.checkInfo()

    }


    componentWillUnmount(){
        this.newFund.stopWatching()
        this.getPaid.stopWatching()
        this.newEmployee.stopWatching()
        this.updateEmployee.stopWatching()
        this.RemoveEmployee.stopWatching()
    }


    checkInfo = () => {
        const {payroll,web3,account} = this.props;
        payroll.getInfo.call({from:account}).then((result) => {
            this.setState({
                balance:web3.fromWei(result[0].toNumber()),
                runway:result[1].toNumber(),
                employeeCount:result[2].toNumber()
            })
        })
    }

    render(){
        const {balance,runway,employeeCount} = this.state
        // const {web3} = this.props
        var formatBalance = 0
        // console.log(typeof(balance))
        if (typeof(balance) === 'string'){
            formatBalance = Number(balance).toFixed(2)
        }
        return(
            <div>
                <h2>通用信息</h2>
                <Row gutter={16}>
                    <Col span={8}>
                        <Card title="合约金额">{formatBalance} Ether</Card>
                    </Col>
                    <Col span={8}>
                        <Card title="员工人数">{employeeCount}</Card>
                    </Col>
                    <Col span={8}>
                        <Card title="支付N次老板跑路">{runway}</Card>
                    </Col>
                </Row>
            </div>
        )
    }
}

export default Common