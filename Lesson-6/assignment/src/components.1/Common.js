import React,{Component} from 'react'

class Common extends Component {
    constructor(props){
        super(props)
        this.state = {};
    }

    componentDidMount() {
        const {payroll,web3,account} = this.props;
        // console.log(account)
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
        return(
            <div>
                <h2>通用信息</h2>
                <p>合约金额：{balance}</p>
                <p>员工人数：{employeeCount}</p>
                <p>支付N次老板跑路：{runway}</p>
            </div>
        )
    }
}

export default Common