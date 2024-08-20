export default function Edit() {
    return (<div className="flex flex-col  gap-[5px] items-center mx-auto">
        <h2 className="mt-[50px] font-bold text-center">Create A New Post</h2>
        <label className="form-control w-full max-w-xs  ">

            <div className="mt-[50px]">
                <div>
                    <div className="label">
                        <span className="label-text">Caption</span>
                    </div>
                    <input type="text" placeholder="Type here" className="input input-bordered w-full max-w-xs" />
                </div>

                <div className="mt-[10px]">
                    <div className="label">
                        <span className="label-text">Body</span>
                    </div>
                    <textarea className="w-full input-bordered  textarea textarea-ghost" ></textarea>
                </div>
            </div>
        </label>
        <label className="form-control w-full max-w-xs">
            <div className="label">
                <span className="label-text">Pick a file</span>
            </div>
            <input multiple type="file" className="file-input file-input-bordered w-full max-w-xs" />
        </label>
        <div className=" flex-auto ">
            <button className=" rounded-md mt-[40px] btn bg-green-500">Create</button>
        </div>
        
    </div>)

}
