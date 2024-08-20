import { useEffect, useState } from 'react';
import { useLocation, Link } from 'react-router-dom';
import { search } from '../lib/api';
import imgavatar from '../images/avatar.png'

export default function Search() {
    const location = useLocation();
    const searchParams = new URLSearchParams(location.search);
    const query = searchParams.get('q');
    const [result, setRes] = useState({res:[]})
    const [loading, setLoading] = useState(true)

    useEffect(() => {
        (async () => {
            if(query === ""){
                return 
            }
            setLoading(true)
            const res = await search(query,1)
            if (res[0] === true) {
                setRes(res[1])
                setLoading(false)
            }
            
        })()
    }, [query])

    const handlePage = async (page) => {
        setLoading(true)
        const res = await search(query, page)
        setRes(res[1])
        setLoading(false)
    }
    console.log(result)
    return (<div className='w-[40%] mx-auto  mt-[40px] '>
        {loading === true ? <span> Loading ....</span> :
            <div className='flex flex-col  gap-[20px]'>{
                result.res.length == 0 ? <div>Nothing Found </div> :
                    result.res.map(r => <div className=' flex gap-[10px] items-center p-2 border-black border-2 rounded-md'>
                        <img className='rounded-full w-[48px] h-[48px]' src={r.avatar ? r.avatar : imgavatar} />
                        <Link to={`/user/${r.id}`} >{r.username}</Link>
                    </div>)}
                {result.res.length === 0 ? null :
                <div className="mb-[40px] join flex justify-center mt-[10px]">
                    {result.current_page <= 1 ? null : <button onClick={() => handlePage(result.current_page - 1)} className="join-item btn ">«</button>}
                    <button className="join-item btn">Page {result.current_page} of {result.total_page}</button>
                    {result.current_page >= result.total_page ? null : <button onClick={() => handlePage(result.current_page + 1)} className="join-item btn ">»</button>}
                </div>}
            </div>
        }
    </div>)
}