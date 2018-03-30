import React,{Component} from 'react'
import PayrollContract from '../build/contracts/Payroll.json'
import getweb3 from './utils/getWeb3'


import {Layout,Menu,Spin,Alert} from 'antd'

//Accounts 账号列表
// import Accounts from './components/Accounts'
//Employer 老板
import Employer from './components/Employer'
//Employee 马仔
import Employee from './components/Employee'
//Common 通用信息
// import Common  from './components/Common'

// import './css/oswald.css'
// import './css/open-sans.css'
// import './css/pure-min.css'

import 'antd/dist/antd.css'
import './css/App.css'

const {Header,Content,Footer} = Layout

class App extends Component {
    constructor(props){
        super(props)

        this.state = {
            web3:null,
            mode:'employer',
            employeeId:null
        }
    }

    componentWillMount(){
        getweb3
        .then((results) => {
            this.setState({
                web3:results.web3
            })

            this.instantiateContract() 
        }).catch(() => {
            console.log('初始化web3失败！')
        })
    }



    instantiateContract(){
        const contract = require('truffle-contract')
        const Payroll = contract(PayrollContract)
        Payroll.setProvider(this.state.web3.currentProvider)
        this.state.web3.eth.getAccounts((error,accounts) => {
            if (error) {
                console.log('初始化account失败！')
                return
            }
            this.setState({
                account:accounts[0],
                employeeId:accounts[0]
            })
        })
        Payroll.deployed().then((instance) => {
            this.setState({
                payroll:instance
            })
        }).catch(() => {
            console.log('初始化payroll失败！')
        })
    }

    // onSelectAccount = (ev) => {
    //     this.setState({
    //         account:ev.target.text
    //     })
    // }

    onSelectTab = ({key}) => {
        this.setState({
            mode:key
        })
    }


    changerole = (mode,employeeId = null) => {
        // console.log(mode,employeeId)
        this.setState({
            mode:mode
        })
        if (employeeId) {
            this.setState({
                employeeId:employeeId
            })
        }
    }


    renderContent = () => {
        const {account,payroll,web3,mode,employeeId} = this.state

        if (!payroll) {
            return <Spin tip="Loading..."  />
        }

        switch(mode) {
            case 'employer':
            // console.log('老板模式');
                return <Employer account={account} payroll={payroll} web3={web3} onChangeRole={this.changerole.bind(this)} />
            case 'employee':
                return <Employee account={account} payroll={payroll} web3={web3} employeeId={employeeId} />
            default:
                return <Alert message="请选择一种模式" type="info" showIcon />
        }
    }




    render(){

        return(
            <Layout>
                <Header className="header">
                    <div className="logo">老董区块链干货铺员工系统</div>
                    <Menu theme="dark" mode="horizontal" defaultSelectedKeys={[this.state.mode]} sytle={{lineHeight:'64px'}} onSelect={this.onSelectTab}>
                        <Menu.Item key="employer">老板</Menu.Item>
                        <Menu.Item key="employee">员工</Menu.Item>
                    </Menu>
                </Header>
                <Content style={{padding:'0 50px'}}>
                    <Layout style={{padding:'24px 0',background:'#fff',minHeight:'20px'}}>
                        {this.renderContent()}
                    </Layout>
                </Content>
                <Footer style={{textAlign:'center'}}>
                    Payroll @2018 老董区块链干货铺
                </Footer>    
            </Layout>

        )

    }

}


export default App
